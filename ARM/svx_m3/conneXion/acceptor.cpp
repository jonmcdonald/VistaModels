/* Copyright 2009 Mentor Graphics Corporation

All Rights Reserved.

THIS WORK CONTAINS TRADE SECRET
AND PROPRIETARY INFORMATION WHICH IS THE
PROPERTY OF MENTOR GRAPHICS
CORPORATION OR ITS LICENSORS AND IS
SUBJECT TO LICENSE TERMS. 
*/
/*****************************************************************************/
#include "svx/base/targets/svx.h"
#include <iostream>
/*****************************************************************************/
using namespace std;
/*****************************************************************************/

int 
main( int argc, char *argv[] ) 
{
	try
	{
//		const SVXTime		svxRate( SVXTime( 0.001 ) );
		const SVXTime		svxRate( SVXTime( 0.000001 ) );
		const SVXTime		executionTime( 5.0 );

		const std::string	svxChannelName("DEFAULT_CHANNEL");
		const std::string	svxSignalName("SVX_SIGNAL_PWMO");

		const int			portNumber = 4445;

		SVXComponentTarget target( executionTime, false, "" );

		SVXComponentConnectionSocketsAcceptor acceptor( target, portNumber, "" );

		SVXComponentChannel channel( target, svxChannelName, "" );

		SVXComponentSignalConsumerBoolean signalConsumer
			(
			target, 
			svxSignalName, 
			svxChannelName, 
			false, 
			SVXTemporalSpec( SVXTimeWindow(svxRate), false, true ), 
			""
			);
		cout << "startup acceptor" << endl;
		target.startup( SVXTime::infiniteTime /* do not timeout */ );
		{
			cout << "done startup" << endl;
			bool previous = false;
			while( !target.isEndTime() )
			{
				bool value = signalConsumer.value();
				if(value != previous) {
					cout << "time = " << target.nowTime().seconds() << endl;
					cout << "received value " << value << endl;
					previous = value;
				}
				target.execute( svxRate.seconds() );
				target.wait();
			}
		}
		target.shutdown();
		cout << "finished... press enter to quit." << endl;
		cin.get();
	}
	catch( SVXStatus& errorStatus )
	{
		cerr	<< "SVX Exception #" 
			<< errorStatus.status() 
			<< ": " 
			<< errorStatus.statusString() 
			<< endl; 
	}
}

/******************************* end-of-file *********************************/
