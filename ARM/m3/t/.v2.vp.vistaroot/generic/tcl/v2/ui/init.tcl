summit_begin_package v2:ui

summit_package_require UI
summit_package_require v2:mti
summit_package_require v2:socd
summit_package_require v2:ui:usual

summit_source ApplicationSettings.tcl
summit_source v2_options.tcl
summit_source AdvancedFileDialogCreate.tcl
summit_source mti.tcl
summit_source socd.tcl

summit_end_package
