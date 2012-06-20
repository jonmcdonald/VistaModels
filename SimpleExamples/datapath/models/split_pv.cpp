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
//* This file contains the PV class for process.
//* This is a template file: You may modify this file to implement the
//* behavior of your component.
//*
//* Model Builder version: 3.2.0RC
//* Generated on: Feb. 23, 2012 08:28:55 AM, (user: jon)
//*>


#include "split_pv.h"
#include <iostream>

using namespace sc_core;
using namespace sc_dt;
using namespace std;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//constructor

split_pv::split_pv(sc_module_name module_name)
    : split_pv_base(module_name)
{
    SC_THREAD(thread1);
    SC_THREAD(thread2);
    SC_THREAD(thread3);
    SC_THREAD(thread4);
    SC_THREAD(thread5);
    SC_THREAD(thread6);
    SC_THREAD(thread7);
    SC_THREAD(thread8);

    for (unsigned int i = 0; i < NumberOfPorts; i++) {
        fifo[i].nb_bound(InputFifoDepth + PipelineStages);
        for (unsigned int j = 0; j < PipelineStages; j++) pipeInTime[i].push(SC_ZERO_TIME);
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void split_pv::general_thread(tlm::tlm_fifo<datastruct *> & fifo,
                              queue<sc_time> & pipeInTime,
                              bool (split_pv_base::*writeMethod_a)(mb_address_type, unsigned char *, unsigned, unsigned),
                              bool (split_pv_base::*writeMethod_b)(mb_address_type, unsigned char *, unsigned, unsigned),
                              mb::mb_variable<int>& deltaVar,
                              mb::mb_variable<int>& startVar,
                              mb::mb_variable<int>& stopVar)
{
    datastruct *ds;
    int proc;
    sc_time startProcT;

    for(;;) {
        // Get the next transaction to be processed.  Do not remove it from the queue
        ds = fifo.peek();

        // Calculate the time that we could start processing the transaction, which is the
        // later of the time we received the input or the time the last element finished processing
        startProcT = pipeInTime.front();
        pipeInTime.pop();
        startProcT = (startProcT > ds->startT) ? startProcT : ds->startT;

        // Calculate the time to wait until we can start processing.  This can not be less than 0
        proc = (startProcT/clock) - (sc_time_stamp()/clock);
        if(proc < -ProcessDelay) {
            proc = -ProcessDelay;
        }
        deltaVar = ProcessDelay + proc;

        // Timing policy: Sequential delay TP2.write -> TP1.write of ProcessDelta cycles
        startVar = (startVar + 1) % 8;
        stopVar = (stopVar + 1) % 8;

        // Save the current token information for the upcoming transaction and clear it from the queue
        set_current_token(ds->currentToken);
        fifo.get();
        // Save the time that we finished processing this transaction
        pipeInTime.push(sc_time_stamp());

        // If the data has been in circulation for less than "DecisionTime" then send it around again...
        if((sc_time_stamp() - ds->currentToken->getFieldAsTime("CreateTime")) < DecisionTime) {
            (this->*writeMethod_a)(ds->address, ds->data, ds->size, 0);
        } else {
            (this->*writeMethod_b)(ds->address, ds->data, ds->size, 0);
        }
        free(ds->data);
        free(ds);
    }
}

void split_pv::thread1()
{
    general_thread(fifo[0], pipeInTime[0], &split_pv_base::master_1a_write, &split_pv_base::master_1b_write,
                   slave_1_ProcessDelta, slave_1_PD_start, slave_1_PD_stop);
}

void split_pv::thread2()
{
    general_thread(fifo[1], pipeInTime[1], &split_pv_base::master_2a_write, &split_pv_base::master_2b_write,
                   slave_2_ProcessDelta, slave_2_PD_start, slave_2_PD_stop);
}

void split_pv::thread3()
{
    general_thread(fifo[2], pipeInTime[2], &split_pv_base::master_3a_write, &split_pv_base::master_3b_write,
                   slave_3_ProcessDelta, slave_3_PD_start, slave_3_PD_stop);
}

void split_pv::thread4()
{
    general_thread(fifo[3], pipeInTime[3], &split_pv_base::master_4a_write, &split_pv_base::master_4b_write,
                   slave_4_ProcessDelta, slave_4_PD_start, slave_4_PD_stop);
}

void split_pv::thread5()
{
    general_thread(fifo[4], pipeInTime[4], &split_pv_base::master_5a_write, &split_pv_base::master_5b_write,
                   slave_5_ProcessDelta, slave_5_PD_start, slave_5_PD_stop);
}

void split_pv::thread6()
{
    general_thread(fifo[5], pipeInTime[5], &split_pv_base::master_6a_write, &split_pv_base::master_6b_write,
                   slave_6_ProcessDelta, slave_6_PD_start, slave_6_PD_stop);
}

void split_pv::thread7()
{
    general_thread(fifo[6], pipeInTime[6], &split_pv_base::master_7a_write, &split_pv_base::master_7b_write,
                   slave_7_ProcessDelta, slave_7_PD_start, slave_7_PD_stop);
}

void split_pv::thread8()
{
    general_thread(fifo[7], pipeInTime[7], &split_pv_base::master_8a_write, &split_pv_base::master_8b_write,
                   slave_8_ProcessDelta, slave_8_PD_start, slave_8_PD_stop);
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

bool split_pv::general_write(mb_address_type address,
                             unsigned char* data,
                             unsigned int size,
                             port_enum idx,
                             tlm::tlm_fifo<datastruct *> & fifo,
                             mb::mb_variable<int>& deltaVar,
                             mb::mb_variable<int>& startVar,
                             mb::mb_variable<int>& stopVar)
{
    datastruct* ds = new datastruct;
    ds->address = address;
    ds->data = new unsigned char [size];
    memcpy(ds->data, data, size);
    ds->size = size;
    ds->currentToken = get_current_token();

    bool putBlocked = !fifo.nb_can_put();
    fifo.put(ds);

    int throughput = size / getSystemCBaseModel()->get_port_width(idx);
    int receiveT = throughput + InputDelay;
    ds->startT = sc_time_stamp() + (receiveT * clock);

    if (putBlocked) {
        deltaVar = receiveT;
        startVar = (startVar + 1) % 8;
        stopVar = (stopVar + 1) % 8;
    }

    return true;
}

bool split_pv::slave_1_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_1_idx, fifo[0],
                         slave_1_InputDelta, slave_1_ID_start, slave_1_ID_stop);
}

bool split_pv::slave_2_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_2_idx, fifo[1],
                         slave_2_InputDelta, slave_2_ID_start, slave_2_ID_stop);
}

bool split_pv::slave_3_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_3_idx, fifo[2],
                         slave_3_InputDelta, slave_3_ID_start, slave_3_ID_stop);
}

bool split_pv::slave_4_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_4_idx, fifo[3],
                         slave_4_InputDelta, slave_4_ID_start, slave_4_ID_stop);
}

bool split_pv::slave_5_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_5_idx, fifo[4],
                         slave_5_InputDelta, slave_5_ID_start, slave_5_ID_stop);
}

bool split_pv::slave_6_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_6_idx, fifo[5],
                         slave_6_InputDelta, slave_6_ID_start, slave_6_ID_stop);
}

bool split_pv::slave_7_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_7_idx, fifo[6],
                         slave_7_InputDelta, slave_7_ID_start, slave_7_ID_stop);
}

bool split_pv::slave_8_callback_write(mb_address_type address, unsigned char* data, unsigned size)
{
    return general_write(address, data, size,
                         slave_8_idx, fifo[7],
                         slave_8_InputDelta, slave_8_ID_start, slave_8_ID_stop);
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
