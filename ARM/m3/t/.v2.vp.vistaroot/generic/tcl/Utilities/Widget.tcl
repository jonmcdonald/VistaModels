namespace eval ::Utilities {

  proc MakeEntryReadOnly {entry} {
    bind $entry <KeyPress> {
      if {[lsearch {Right Left Home End} %K] == "-1"} {
        bell
        break;
      }
    }
  }

};#namespace
