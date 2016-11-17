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
		const SVXTime		svxRate( SVXTime( 0.001 ) );
		const SVXTime		executionTime( 3.0 );

		const std::string	svxChannelName("DEFAULT_CHANNEL");
		const std::string	svxSignalName("SVX_SIGNAL_PWMO");

		const int			portNumber = 4445;

		SVXComponentTarget target( executionTime, true, "" );

		SVXComponentConnectionSocketsConnector connector( target, portNumber, "localhost", string("") );

		SVXComponentSignalGeneratorBoolean		bool_test
			(
			target, 
			svxSignalName, 
			svxChannelName, 
			false, 
			SVXTemporalSpec( SVXTimeWindow(svxRate), false, true ), 
			""
			);

		cout << "startup connector" << endl;
		target.startup( SVXTime::infiniteTime /* do not timeout */ );
		cout << "done" << endl;
		{
			bool value = true;
			while( !target.isEndTime() )
			{
				cout << "time = " << target.nowTime().seconds() << endl;
				cout << "sending value " << value << endl;
				bool_test.setValue(value);
				value = !value;
				cout << "executing... " << svxRate.seconds() << endl;
				target.execute( svxRate.seconds() );
				cout << "waiting..." << endl;
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
