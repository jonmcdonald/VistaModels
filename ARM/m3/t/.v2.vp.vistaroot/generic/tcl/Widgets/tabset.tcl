namespace eval Widgets {
  proc fix_tabset {} {
    catch {
      destroy [::blt::tabset .tabset_dummy]
      bind Tabset <B2-Motion> {
        event generate %W <ButtonRelease-2> -x %x -y %y
      }
    }
  }
}
