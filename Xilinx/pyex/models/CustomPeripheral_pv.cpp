
/**************************************************************/
/*                                                            */
/*      Copyright Mentor Graphics Corporation 2006 - 2012     */
/*                  All Rights Reserved                       */
/*                                                            */
/*       THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY      */
/*         INFORMATION WHICH IS THE PROPERTY OF MENTOR        */
/*         GRAPHICS CORPORATION OR ITS LICENSORS AND IS       */
/*                 SUBJECT TO LICENSE TERMS.                  */
/*                                                            */
/**************************************************************/

//*<
//* Generated By Model Builder, Mentor Graphics Computer Systems, Inc.
//*
//* This file contains the PV class for CustomPeripheral.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.8.1RND2
//* Generated on: Aug. 04, 2014 05:30:23 PM, (user: markca)
//* Automatically merged on: Aug. 14, 2014 03:06:49 PM, (user: jon)
//* Automatically merged on: Aug. 14, 2014 03:16:37 PM, (user: jon)
//*>

#include "CustomPeripheral_pv.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

using namespace sc_core;
using namespace sc_dt;
using namespace std;

//constructor
CustomPeripheral_pv::CustomPeripheral_pv(sc_module_name module_name) 
  : CustomPeripheral_pv_base(module_name)
#ifdef __VISTA_OSCI23__
  ,safe_ev("safe_ev")
#endif
{
  int r;
  /* First call to socket() function */
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd < 0) 
    {
      perror("ERROR opening socket");
      exit(1);
    }
  /* Initialize socket structure */
  bzero((char *) &serv_addr, sizeof(serv_addr));
  portno = 5005;
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);
  int yes = 1;
  if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
    perror("setsockopt");
    exit(1);
  }

  /* Now bind the host address using bind() call.*/
  if (bind(sockfd, (struct sockaddr *) &serv_addr,
           sizeof(serv_addr)) < 0) {
    perror("ERROR on binding");
      exit(0);
  }
  
  child_pid = 0;
  if((child_pid = fork()) < 0 )  {
    perror("fork failure");
    exit(1);
  }
  if(child_pid == 0) {
    execl("peripheral.py", "peripheral.py", (char*) 0);
    perror("execl() failure!\n\n");
    _exit(1);
  }
  
  /* Now start listening for the clients, here process will
   * go in sleep mode and will wait for the incoming connection
   */
  listen(sockfd,5);
  clilen = sizeof(cli_addr);

  cout << "CustomPeripheral: Awaiting connection from GUI on port 5005" << endl;

  /* Accept actual connection from the client */
  newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
  if (newsockfd < 0) 
    {
      perror("ERROR on accept");
      exit(0);
    }
  
  SC_THREAD(input);
  SC_THREAD(output);

  r = pthread_create( &readerThread, NULL, &CustomPeripheral_pv::call_startReader, this);
  if (r ==0) pthread_detach(readerThread);

}    

// Destructor cleans up the forked python script
CustomPeripheral_pv::~CustomPeripheral_pv()
{
  if(child_pid) { 
    cout << "CustomPeripheral: Sending kill signal to forked Python script" << endl;
    kill(child_pid, SIGKILL);
    child_pid = 0;
  }
}


// SystemC process which takes data from input and writes out through the tlm port
void CustomPeripheral_pv::output() {
  DataType *data;

  master_write(0x0, 0);

  while (1) {
    data = fifo.get();
cout<< "sending data-v = "<< data->v <<endl;
    master_write(0x0, data->v);
    free(data);
  }
}

// SystemC process which waits for asynchronous input from external process
void CustomPeripheral_pv::input() {
  DataType *data;

  while (1) {
#ifdef __VISTA_OSCI23__
    wait(safe_ev.default_event());  	// Waits for data from startReader pthread
#else
    wait();
#endif

    // To safely pass data a mutex must be used between startReader and input 
    // protecting each process' modifications of the shared q
    pthread_mutex_lock(&mutex);		
    while (q.size()) {
      data = q.front();		// get the data from the q
      q.pop_front();
      fifo.nb_put(data);	// pass the data to the output process through a tlm_fifo
    }
    pthread_mutex_unlock(&mutex);  // After all data is read from the q release the mutex
  }
}
 

// C++ pthread which will read the socket and wait for input
// from the external process.  It will forward and call notify on safe_ev
void *CustomPeripheral_pv::startReader(void) {
  char buffer[256];
  uint id;
  uint v;
  uint t;
  DataType *data;
  
  /* If connection is established then start communicating */
  ssize_t bytes_read;
  cout << "CustomPeripheral: GUI connected, awaiting commands" << endl;
  while(1) {
    do {
        bzero(buffer, 256);
        bytes_read = recv(newsockfd, buffer, sizeof(buffer), 0);
        if (bytes_read > 0) {
          string cmd(buffer);
          sscanf(buffer, "%x",  &v);
cout << "val = "<< std::hex<<v << endl;
          data = new DataType();	// Create new data structure then fill in values
          data->v = v;
          pthread_mutex_lock(&mutex);	// Use mutex to safely modify q
          q.push_back(data);
#ifdef __VISTA_OSCI23__
          safe_ev.notify();			// input SystemC thread is waiting on safe_ev
#else
          cout << "CustomPeripheral: Error, GUI input requires SystemC 2.3" << endl;
#endif
          pthread_mutex_unlock(&mutex);	// Release mutex when done modifying q
        } else if(bytes_read == 0) {
          cout << "CustomPeripheral: GUI disconnected, ending simulation" << endl;
          if(child_pid) {
            child_pid = 0;
            sc_stop();
          }
          return 0;
        }
      } while (bytes_read > 0);
  }
  return 0;
}


// Write callback for SETUP register.
// The newValue has been already assigned to the SETUP register.
void CustomPeripheral_pv::cb_write_SETUP(unsigned int newValue) {

  if(send(newsockfd, &newValue, sizeof(newValue), 0) < 0) {
    cout << "CustomPeripheral: Error, send data to Peripheral GUI failed" << endl;
  }
}
  

// Read callback for slave port.
// Returns true when successful.
bool CustomPeripheral_pv::slave_callback_read(mb_address_type address, unsigned char* data, unsigned size) {
  
  return true;
}

// Write callback for slave port.
// Returns true when successful.
bool CustomPeripheral_pv::slave_callback_write(mb_address_type address, unsigned char* data, unsigned size) {
  
  return true;
} 



void CustomPeripheral_pv::cb_transport_dbg_SETUP(tlm::tlm_generic_payload& trans) {}

unsigned CustomPeripheral_pv::slave_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size) {
  return 0;
} 

unsigned CustomPeripheral_pv::slave_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size) {
  return 0;
} 

bool CustomPeripheral_pv::slave_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData) {
  return false;
}

 