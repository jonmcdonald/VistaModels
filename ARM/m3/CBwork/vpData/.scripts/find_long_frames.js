/*****************************************************************************
Copyright © Mentor Graphics Corporation 2011

All Rights Reserved.

THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH 
IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS 
LICENSORS AND IS SUBJECT TO LICENSE TERMS.
*****************************************************************************/

// JavaScript script for Mentor® Embedded Sourcery™ Analyzer

/**
 * Manifest describing this script's purpose and configuration.
 */
SCRIPT_MANIFEST={ 
		type: "agent", 
		name: "Latency Cap", 
		description: "Instances where a latency budget is exceeded", 
		widgetTypes: widgetType.createWidgetType( widgetType.ANALOG ),
		category: "Software",
		dataAcqRequests: []
	};

var params;

function defineParameters( p )
{
//	isTickBased = sa.time.getTimestampConversion() != null ? sa.time.getTimestampConversion().getTickFrequency() == 0 : true;
	params = p;

    tickWfValidator = new com.mentor.embedded.profiler.extension.IEventAnalysisParameters.IParameterValidator(
	{
		isValid : function(value) {
			if (value.getWfType() != 21)
				return "Please specify a 'tick' waveform here.";
			else
				return null;
		}
	});
	params.addParameter( "start_wf_name", "Start tick waveform", IEventAnalysisParameters.ParameterType.Waveform, "", "This waveform contains events that define the starting point of a frame.", tickWfValidator );
	params.addParameter( "stop_wf_name", "Stop tick waveform", IEventAnalysisParameters.ParameterType.Waveform, "", "This waveform contains events that define the ending point of a frame.", tickWfValidator );
    posTimeValidator = new com.mentor.embedded.profiler.extension.IEventAnalysisParameters.IParameterValidator(
	{
		isValid : function(value) {
			if (value.getValue() < 0)
				return "Please enter a positive time value.";
			else
				return null;
		}
	});
	params.addParameter( "max_time", "Max frame duration", IEventAnalysisParameters.ParameterType.Timestamp, "", "All frames longer than this maximum duration are flagged in the output of this agent.", posTimeValidator );
}

function preProcessing()
{
        // block processing until analyses providing the start/stop waveforms have completed (if any)
        start_wf = params.getParameterValue( "start_wf_name" );
        stop_wf = params.getParameterValue( "stop_wf_name" );
        start_wf_analysis = sa.wf.findAnalysis( start_wf );
        stop_wf_analysis = sa.wf.findAnalysis( stop_wf );
        if( start_wf_analysis != null )
            start_wf_analysis.waitForCompletion( null );
        if( stop_wf_analysis != null )
            stop_wf_analysis.waitForCompletion( null );
        
	// parameter
	start_wf = params.getParameterValue( "start_wf_name" );
	stop_wf = params.getParameterValue( "stop_wf_name" );
	max_time_stmp = params.getParameterValue( "max_time" );
	max_time = sa.time.getTimestampConversion().tickToTime( max_time_stmp.getValue());

	// echo parameter to console (for debugging purposes)
	outln("=== start long frame analysis ===");
	outln("start_wf name=" + start_wf.getAbsolutePath());
	outln("stop_wf name=" + stop_wf.getAbsolutePath());
	outln("max_time=" + max_time);

	// check that start and stop waveforms are different
	if(start_wf.equals(stop_wf))
		return sa.util.status(org.eclipse.core.runtime.IStatus.ERROR, "Start and stop waveforms are same. Different waveforms for start and stop tick events must be used.");
	if(max_time <= 0)
		return sa.util.status(org.eclipse.core.runtime.IStatus.ERROR, "Max frame duration is negative or zero. A positive time specification must be given.");

	// find all frames, defined by start and stop waveform
	frame_wf = sa.wf.calculate("wf('"+start_wf.getAbsolutePath()+"') > wf('"+stop_wf.getAbsolutePath()+"')");

	// measure all frame widths
	width_wf = sa.wf.measure("pwidth -new_wf field.pulsewidth field.FirstMiddleX -rising -wf \""+frame_wf.getAbsolutePath()+"\" -new_wf_target win=none"); // -new_wf_target win=active,color_index=0
	if(width_wf==null)
		return sa.util.status(org.eclipse.core.runtime.IStatus.ERROR, "No frames found. The events in start and stop waveforms do not define any frames.");

	// find frames longer than max_time
	long_frame_wf = sa.wf.calculate("band(step(wf('"+width_wf.getAbsolutePath()+"')) > "+max_time+", wf('"+frame_wf.getAbsolutePath()+"'))");

	// the waveforms with the failed frames is the output from this script
	sa.wf.addWaveform(long_frame_wf, "long_frames");

	// output a waveforms with all frames for reference
	// these waveforms will appear as sub-nodes of this script's analysis node
	sa.wf.addWaveform(frame_wf, "all_frames");

	outln("=== done ===");
}
