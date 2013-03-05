if {[catch {
  summit_source_file $::Basics::bootstrapfilename
} msg]} {
  if {[catch {
    tk_messageBox -type ok -message $msg -title "Vista failed to start executable $::Basics::shortnameofexecutable" -icon error
  }]} {
    if {[catch {
      puts stderr "error: Vista failed to start executable $::Basics::shortnameofexecutable"
    }]} {
      puts "error: Vista failed to start executable"
    }
  }
  exit 1
}
