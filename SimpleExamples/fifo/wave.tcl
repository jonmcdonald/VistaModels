#
# TCL script to acquire TLM sockets to Vista waveform viewer
#
catch { unset ports_list }
array unset ports_list
#
# Set waveform name
#
#-------

set wave wave_wave

#-------
#
# list of ports to wave
#
# usage:
#   set ports_list( <path_to_port> )    { "read" and/or "write" } 
# example:
#   set ports_list( top.cpu0.master )    { read write } 
#--------------------------

set ports_list(top.drive.m0)    { x write }
set ports_list(top.sink0.d_in)  { x write }
set ports_list(top.drive.m1)    { write }
set ports_list(top.sink1.d_in)  { write }

#--------------------------
# Process each port
#
wave clear $wave
wave open  $wave

foreach  port  [array names ports_list]  {
    # remove uninteresting port data
    untrace ${port}.last_ReadResponseStatus
    untrace ${port}.last_ReadStatus
    untrace ${port}.last_ReadPhase
    #untrace ${port}.last_ReadSize
    untrace ${port}.last_WriteResponseStatus
    untrace ${port}.last_WriteStatus
    untrace ${port}.last_WritePhase
    #untrace ${port}.last_WriteSize
    if { [lsearch $ports_list($port) read] < 0 } {
        puts "Acquiring: ${port} write data"
        # remove read info
        untrace ${port}.last_ReadAddress
        untrace ${port}.last_ReadData
        untrace ${port}.last_ReadSize
        # add write info
        trace ${port}.last_WriteAddress
        trace ${port}.last_WriteData
        trace ${port}.last_WriteSize
    }
    if { [lsearch $ports_list($port) write] < 0 } {
        puts "Acquiring: ${port} read data"
        # remove write info
        untrace ${port}.last_WriteAddress
        untrace ${port}.last_WriteData
        untrace ${port}.last_WriteSize
        # add read info
        trace ${port}.last_ReadAddress
        trace ${port}.last_ReadData
        trace ${port}.last_ReadSize
    }
    # acquire port data to wave viewer
    acquire -trace ${port}
}


