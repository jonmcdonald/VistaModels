//
//--------------------------------------------
// Call Back to Thread Couple 
//
// Creates FIFO-like object which allows a TLM callback function to communicate 
// with a SystemC thread.  This allows the callback and thread to operate simultaneously 
// that is, to be de-coupled from each other...
//--------------------------------------------
// --*In Development*-- MickBradWare
//--------------------------------------------
// History
//    xxxx Initial release
//--------------------------------------------
#pragma once


// allow caller to enable/disable debugging
#undef COUT_DBG
#if 1
  #define COUT_DBG(x) if (throuple_debug) {cout x;}
#else
  #define COUT_DBG(...);
#endif
// enable/disable warnings
#undef COUT_WARN
#if 1
  #define COUT_WARN(x) cout x;
#else
  #define COUT_WARN(...);
#endif


enum DREGS { OK, DROP_INPACKET, BLOCK_INPACKET };

//             ----------
typedef struct transQuple 
{//            ----------
    typedef esl::tlm_types::Address mb_address_type;
    mb_address_type address;
    unsigned        size;
    sc_time         arriveTime;
    unsigned char*  data;

    // construct - destruct
  transQuple() : data(0) 
    {}
    ~transQuple() {
        delete data;
    }

    void allocate(unsigned bytes) 
    {
        size = bytes;  // store to prevent memory corruption
        data = new unsigned char[bytes];
    }

    void copyIn(sc_time aTime, mb_address_type a, unsigned char* d)
    {
        address    = a;
        arriveTime = aTime;
        if (data == 0) 
            cout <<" transQuple_t "<<" @ "<<sc_time_stamp()<<" ERROR: Attempt to copy data into unallocated transQuple memory \n";
        else
            memcpy(data,d,size);
    }
} transQuple_t;


//    -------------
class cb_throuple_c
{//   -------------
    typedef esl::tlm_types::Address                        mb_address_type;
    typedef _mgc_vista_model_builder_mb::mb_variable<int>  mb_varInt;

    mb::mb_module* scMod;                              // pointer to sc_module instance (parent)
    sc_time        clock;                              // clock of the input bus to this block
    unsigned       maxNumTrans;                        // max number of transfers to buffer (fifo size)
    unsigned       portWidth;                          // width of input port in bytes
    mb_varInt*     overflow;                           // external overflow variable
    mb_varInt*     underflow;                          // external underflow variable
    mb_varInt*     level;                              // monitor FIFO level 
    unsigned       inputWait;                          // Vista T policy wait states on the input
    unsigned       inputDelay;                         // Vista T policy latency on the input
    
    unsigned       numTransInBuf;                      // current number of transfers in the buffer
    unsigned       readPtr, writePtr;                  // fifo read/write pointers
    transQuple_t** dataBufPtrArr;                      // fifo is an array of pointers 
    transQuple_t*  dataOutBufPtr;                      // Output buffer
    bool           needPop;                            // flag to warn if output buffer not pop'ed by user
    sc_event       unblockEvent;                       // event to unblock input or output
    mb_varInt      oDummy, uDummy, lvlDummy;           // dummy target in case over/underflow, level not assigned via init()
    unsigned       throuple_debug;                     // debug flag
    

    public:
    cb_throuple_c()
        : clock(SC_ZERO_TIME), maxNumTrans(0)    , portWidth(0)          , overflow(&oDummy), underflow(&uDummy)
         ,inputWait(0)       , inputDelay(0)     , numTransInBuf(0)      , readPtr(0)       , writePtr(0)       
         ,dataBufPtrArr(0)   , dataOutBufPtr(0)  , needPop(false)   
         ,oDummy("oDummy",0) , uDummy("uDummy",0), lvlDummy("lvlDummy",0), throuple_debug(0)
    { 
    }
   
    //   ----
    //void init(unsigned num, unsigned width, sc_time clk)  // no input Delay Policy, no under/over flow indicators
    void init(unsigned num, unsigned width, sc_time clk)  // no input Delay Policy, no under/over flow indicators
    {//  ----
        maxNumTrans   = num; 
        portWidth     = width; 
        clock         = clk;  // get_clock() returned value already in SC_PS
        dataBufPtrArr = new transQuple_t*[maxNumTrans];  // array of pointers to buffered data 
    }

    //   ----
    void init(                                          // init() all features
    //   ----
               mb::mb_module*  mod
              ,unsigned        portIndex
              ,unsigned        num
              ,mb_varInt*      oFlow ,     mb_varInt*    uFlow,      mb_varInt*  lvl
              ,unsigned        inWait,     unsigned      inDel
              ,unsigned        debug
              )
    {
        scMod          = mod;
        clock          = mb::sysc::ps_to_sc_time( scMod->getSystemCBaseModel()->get_clock(portIndex));
        maxNumTrans    = num; 
        portWidth      = scMod->getSystemCBaseModel()->get_port_width(portIndex);
        overflow       = oFlow;
        underflow      = uFlow;
        level          = lvl;
        inputWait      = inWait;
        inputDelay     = inDel;
        throuple_debug = debug;
        dataBufPtrArr  = new transQuple_t*[maxNumTrans];  // array of pointers to buffered data 
    }


    //   ---
    void put(mb_address_type address, unsigned char* data, unsigned size)
    {//  ---
        sc_time arriveTime = sc_time_stamp();

        // Wait if there is no room in the buffer/fifo
        if (numTransInBuf >= maxNumTrans) {
            // Note: This can occur in zero delay, which causes zero delay glitches on overflow
            *overflow = 1;
            wait(unblockEvent);
            *overflow = 0;

            if (mb::tlm20::is_AT_mode())
            {
                // Allow time for data to be read from bus.  This could not have already happened
                // as to this point the FIFO was full.
                unsigned busCycles    =  size / portWidth;
                busCycles            += (size % portWidth)>0 ? 1:0;                          // bus transaction of < 1 word
                sc_time  inTransTime  =  busCycles * clock;                                  // transfer time
                inTransTime          += (inputDelay + (busCycles * inputWait)) * clock ;     // Delay policy

                COUT_DBG(<<scMod->name()<<" @ "<<sc_time_stamp()<<" newly un-blocked put() inTransTime= "<< inTransTime <<endl);
                // use wait() instead of T policies to remove dependency from .mb file, and make this class more portable.
                wait(inTransTime);
            }
        }
       
        COUT_DBG(<<scMod->name()<<" @ "<<sc_time_stamp()<<" put() new data into FIFO "<<endl);
        // allocate new buffer and copy incoming transfer
        dataBufPtrArr[writePtr] = new transQuple_t;
        dataBufPtrArr[writePtr]->allocate(size);
        dataBufPtrArr[writePtr]->copyIn(arriveTime, address, data);

        // update read/write pointers and number of transfers in FIFO
        numTransInBuf++;
        *level = numTransInBuf;
        if (writePtr == maxNumTrans-1)
            writePtr=0;
        else
            writePtr++; 

        // If otherside was potentially blocking, send unblock event
        if (numTransInBuf == 1)
            unblockEvent.notify();
    }
  

    //   ----
    void get(sc_time& makeupTime, transQuple_t*& gotData)
    {//  ----
        // delete current output data buffer, copy data pointer from FIFO to output Buffer

        if (numTransInBuf == 0) {
            // Note: This can occur in zero delay, which causes zero delay glitches on underflow
            *underflow = 1;
            wait(unblockEvent);
            *underflow = 0;
        }
        
        COUT_DBG(<<scMod->name()<<" @ "<<sc_time_stamp()<<" get() data from FIFO to output buffer "<<endl);
        // calculate how much time it should have taken to input the transfer, 
        // as this delay needs to be passed to the outgoing thread
        unsigned busCycles    =  dataBufPtrArr[readPtr]->size / portWidth;
        busCycles            += (dataBufPtrArr[readPtr]->size % portWidth)>0 ? 1:0;  // bus transaction of < 1 word
        sc_time  inTransTime  =  busCycles * clock;                                  // transfer time
        inTransTime          += (inputDelay + (busCycles * inputWait)) * clock ;     // Delay policy
        sc_time  timePassed   =  sc_time_stamp() - dataBufPtrArr[readPtr]->arriveTime;

        if (timePassed >= inTransTime) 
        {   // This results from FIFO overflow condition (waiting to output downstream)
            // We could set overflow here, it would have no glitches, but would be set 
            // after the overflow is over
            makeupTime = SC_ZERO_TIME;
        } else {
            makeupTime = inTransTime - timePassed;
        }

        // delete old output buffer, don't delete FIFO data, as we delete it only once it moves to output buffer
        delete dataOutBufPtr;

        // Copy data from FIFO to output buffer, return pointer to output buffer
        gotData = dataOutBufPtr = dataBufPtrArr[readPtr];
        needPop = true;
    }


    //   ---
    void pop()
    {//  ---
        // pop FIFO control signals, user already has data, no data is deleted
        COUT_DBG(<<scMod->name()<<" @ "<<sc_time_stamp()<<" pop() data from FIFO "<<endl);

        if (numTransInBuf == 0) 
        {
            COUT_WARN(<<scMod->name()<<" @ "<<sc_time_stamp()<<" Warning pop(): pop requested but no data in FIFO"<<endl);
        }
        else
        {
            if (!needPop) 
            {
                COUT_WARN(<<scMod->name()<<" @ "<<sc_time_stamp()<<" Warning pop(): pop'ing FIFO data which was never read"<<endl);
                delete dataBufPtrArr[readPtr];
            }
            numTransInBuf--;
            *level = numTransInBuf;
            if (readPtr == maxNumTrans-1)
                readPtr = 0;
            else
                readPtr++;
        }
        needPop = false;

        // If otherside was potentially blocking, send unblock event
        if (numTransInBuf == maxNumTrans-1)
            unblockEvent.notify();
    }
  

    //            ------
    void getAndPop(sc_time& makeupTime, transQuple_t*& gotData) 
    {//           ------
        get(makeupTime, gotData);
        pop();
    }
    bool ok2put() 
    {
        if (numTransInBuf < maxNumTrans)
            return true;
        else
            return false;
    }
    bool ok2get() 
    {
        if (numTransInBuf > 0)
            return true;
        else
            return false;
    }
};
