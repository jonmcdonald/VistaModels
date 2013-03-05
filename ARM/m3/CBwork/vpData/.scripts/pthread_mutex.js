/*****************************************************************************
Copyright © Mentor Graphics Corporation 2011

All Rights Reserved.

THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH 
IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS 
LICENSORS AND IS SUBJECT TO LICENSE TERMS.
*****************************************************************************/

// JavaScript script for Mentor® Embedded Sourcery™ Analyzer

filenameGraphs = sa.io.getInstanceName() + " - Locking Analysis.swd";
filenameHistograms = sa.io.getInstanceName() + " - Locking Analysis Histogram(s).swd";

/**
 * Manifest describing this script's purpose and configuration.
 */
SCRIPT_MANIFEST={ 
		type: "agent", 
		name: "Lock Wait and Hold Times", 
		description: "How long it took for locking operations to succeed, and how long locks were held", 
		widgetTypes: [ widgetType.createSwdType( filenameGraphs ),
		               widgetType.createSwdType( filenameHistograms ) ],
		category: "Software",
		dataAcqRequests: ustDataReq.UST_LOCKTRACE_EVENTS
	};

var e;
var firstTimestamp;
var wfs;

var params;

function defineParameters( p )
{
    params = p;

    params.addParameter( "statistics", "Add rows for request and locking times", IEventAnalysisParameters.ParameterType.Boolean, true );
}

function preProcessing()
{
    e = sa.wf.getEvent();
    firstTimestamp = 0;
    wfs = [];
}

function processData(events)
{
    if (firstTimestamp == 0)
    {
        firstTimestamp = events[0].getTimestamp().getValue();
    }
    for ( var i = 0; i < events.length; i++)
    {
        event = events[i];
        eventTypeId = event.getType().getTypeId();
        if (eventTypeId.match("^(?:(?:ust\\.)?effprof_lcktrace\\.|ust.met_lcktrace:)pthread_mutex_(lock_acq|lock|unlock)$"))
        {
            mutexAddressField = sa.events.getField(event, "mutex");
            if (mutexAddressField)
            {
                mutexAddress = mutexAddressField.getValue();
                wf = wfs[mutexAddress];
                if (!wf)
                {
                    // A new mutex was found, create a new waveform.
                    // Name for new waveform.
                    name = "mutex=" + mutexAddressField.toString();
                    // Create waveform.
                    wfs[mutexAddress] = wf = sa.wf.newWaveform(name, "y", "state", name);
                    // Define the state codes used above:
                    // 0 = unlocked, 1 = attempt, 2 = locked
                    // Enum #0 draws an "idle" line.
                    wf.getYDatum().addValue(0, "unlocked", "000000");
                    wf.getYDatum().addValue(1, "requested", "80FFFF");
                    wf.getYDatum().addValue(2, "locked", "FF8080");
                    e.setX(firstTimestamp);
                    e.setIntY(0);
                    wf.appendWfEvent(e);
                }
                e.setX(event.getTimestamp().getValue());
                if (eventTypeId.endsWith("pthread_mutex_lock_acq"))
                {
                    e.setIntY(1);
                } else if (eventTypeId.endsWith("pthread_mutex_lock"))
                {
                    e.setIntY(2);
                } else if (eventTypeId.endsWith("pthread_mutex_unlock"))
                {
                    e.setIntY(0);
                }
                wf.appendWfEvent(e);
            }
        }
    }
}

function postProcessing()
{
    var statistics = params.getParameterValue( "statistics" )==true;

    var request_wfs = [];
    var lock_wfs = [];

    var request_hist_wfs = [];
    var lock_hist_wfs = [];

    if (statistics)
    {
        for (address in wfs)
        {
            wf = wfs[address];
            // Leaf name without path and wdb, just the "mutex=..." name
            name = wf.getDisplayName(1);
            // Full path of waveform including wdb name.
            path = wf.getAbsolutePath();

            // Measure width of request state (using pulse width measurement tool)  
            pw_wf = sa.wf.measure("pwidth -new_wf field.pulsewidth field.FirstMiddleX -topline 1.0 -rising -wf \"" + path
                    + "\" -new_wf_target win=none");
            if(pw_wf != null)
            {
                // Convert to spectral type
                spectral_wf = sa.wf.calculate("spectral(wf('" + pw_wf.getAbsolutePath() + "'))");
                // Save for later and add to analysis result
                request_wfs[address] = sa.wf.addWaveform(spectral_wf, name + " - request");

                // Histogram of request state durations
                hist_wf = sa.wf.calculate("histogram(wf('"+request_wfs[address].getAbsolutePath()+"'),10,0,0)");
                // Save for later and add to analysis result
                request_hist_wfs[address] = sa.wf.addWaveform(hist_wf, name + " - request hist");
            } else
                outln("Warning: Not enough data to measure " + name + " request time.");
            
            // Measure width of lock state (using pulse width measurement tool)  
            pw_wf = sa.wf.measure("pwidth -new_wf field.pulsewidth field.FirstMiddleX -topline 2.0 -rising -wf \"" + path
                    + "\" -new_wf_target win=none");
            if(pw_wf != null)
            {
                // Convert to spectral type
                spectral_wf = sa.wf.calculate("spectral(wf('" + pw_wf.getAbsolutePath() + "'))");
                // Save for later and add to analysis result
                lock_wfs[address] = sa.wf.addWaveform(spectral_wf, name + " - lock");
                
                // Histogram of lock state durations
                hist_wf = sa.wf.calculate("histogram(wf('"+lock_wfs[address].getAbsolutePath()+"'),10,0,0)");
                // Save for later and add to analysis result
                lock_hist_wfs[address] = sa.wf.addWaveform(hist_wf, name + " - lock hist");
            } else
                outln("Warning: Not enough data to measure " + name + " lock time.");
        }
    }

    // Name of the view
    swdFileName = filenameGraphs;

    // Create a view file and add commands to display/measure the
    // generated waveforms.
    fileWriter = sa.io.openForWriting(swdFileName, false);
    fileWriter.write("set names width 180\n");

    var measures = "";
    var row = 1;
    fileWriter.write("\n// ===== Create row #" + row + " =====\n");
    fileWriter.write("add blank row -title \"" + sa.io.getInstanceName() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
    row++;

    for (address in wfs)
    {
        wf = wfs[address];
        // wf.getDisplayName(1): Leaf name without path and wdb, just the "mutex=..." name
        // wf.getAbsolutePath(): Full path of waveform including wdb name.
        fileWriter.write("\n// ===== Create row #" + row + " =====\n");
        fileWriter.write("add waveform -alias \"" + wf.getDisplayName(1) + "\" \"" + wf.getAbsolutePath() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
        row++;
        if (statistics)
        {
            request_wf = request_wfs[address];
            lock_wf = lock_wfs[address];
            if(request_wf != null || lock_wf != null)
            {
                fileWriter.write("\n// ===== Create row #" + row + " =====\n");
                n = 1;
                if(request_wf != null)
                {
                    fileWriter.write("add waveform -alias \"" + request_wf.getDisplayName(1) + "\" -color -8323073 \"" + request_wf.getAbsolutePath() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
                    measures += "measure stats -max -mean -min -id #wf:" + row + ".y1." + n++ + "\n";
                }
                if(lock_wf != null)
                {
                    fileWriter.write("add waveform " + (n > 1 ? "-row " + row + " -axis Y1 " : "") + "-alias \"" + lock_wf.getDisplayName(1) + "\" -color -32640 \"" + lock_wf.getAbsolutePath() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
                    measures += "measure stats -max -mean -min -id #wf:" + row + ".y1." + n++ + "\n";
                }
    
                fileWriter.write("set axis properties -row " + row + " -axis Y1 -autorange\n");
                fileWriter.write("set user scale Time 1.0 s -row " + row + " -axis Y1\n");
                row++;
            }
        }
    }
    if (statistics)
    {
        fileWriter.write("\n// ===== Set X-axis data units =====\n");
        fileWriter.write("set user scale Time 1.0 s -axis X\n");

        fileWriter.write("\n// ====== Create the cursors, markers and measurements =====\n");
        fileWriter.write(measures);
    }

    fileWriter.close();
    
    if (statistics)
    {
        // Name of the histogram view
        swdFileName2 = filenameHistograms;

        // Create a view file and add commands to display the histogram(s).
        fileWriter = sa.io.openForWriting(swdFileName2, false);
        fileWriter.write("set names width 200\n");
        
        row = 1;
        fileWriter.write("\n// ===== Create row #" + row + " =====\n");
    	fileWriter.write("add blank row -title \"" + sa.io.getInstanceName() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
    	row++;
        
        // For each mutex ...
        for (address in wfs)
        {
            hist_wf = request_hist_wfs[address];
            if(hist_wf != null)
            {
                fileWriter.write("\n// ===== Create row #" + row + " =====\n");
                fileWriter.write("add waveform -alias \"" + hist_wf.getDisplayName(1) + "\" -color -8323073 \"" + hist_wf.getAbsolutePath() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
                fileWriter.write("set axis properties -row " + row + " -axis Y1 -autorange\n");
                row++;
            }
            hist_wf = lock_hist_wfs[address];
            if(hist_wf != null)
            {
                fileWriter.write("\n// ===== Create row #" + row + " =====\n");
                fileWriter.write("add waveform -alias \"" + hist_wf.getDisplayName(1) + "\" -color -32640 \"" + hist_wf.getAbsolutePath() + "\" -group \"" + sa.io.getInstanceId() + "\"\n");
                fileWriter.write("set axis properties -row " + row + " -axis Y1 -autorange\n");
                row++;
            }
        }
        
        fileWriter.close();

        // Now automagically add the view to the session sheet.
//        sa.io.addToSessionSheet(swdFileName2);
    }

    // Now automagically add the view to the session sheet.
//    sa.io.addToSessionSheet(swdFileName);
}
