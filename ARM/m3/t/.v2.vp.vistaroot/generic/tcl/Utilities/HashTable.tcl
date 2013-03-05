namespace eval ::Utilities {

  class HashTable {
    private variable hashtable

    destructor {
      #unset hashtable
    }

    public method add {id item} {
      return [set hashtable($id) $item]
    }

    public method remove {id} {
      if [info exist hashtable($id)] {
        unset hashtable($id)
      }
    }
    
    public method removeAll {} {
      set hashtable {}
    }
    
    public method get {id} {
      if {$id != "" && [info exist hashtable($id)]} {
        return $hashtable($id)
      } else {
        return ""
      }
    }

    public method getIds {} {
      return [array names hashtable]
    }
    
    public method find {item} {
      set names [array names hashtable]
      foreach name $names {
        if {$hashtable($name) == $item} {
          return $name
        }
      }
      return ""
    }
  }
}
