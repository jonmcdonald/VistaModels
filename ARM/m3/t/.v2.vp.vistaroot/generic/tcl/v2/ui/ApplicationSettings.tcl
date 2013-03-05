set ::env(THIS_PRODUCT_NAME) $::env(V2_PRODUCT_NAME)
set ::env(THIS_PRODUCT_VERSION) $::env(V2_PRODUCT_VERSION)
set ::env(THIS_PRODUCT_NAME_AND_VERSION) "$::env(THIS_PRODUCT_NAME) $::env(THIS_PRODUCT_VERSION)"
set ::env(THIS_PRODUCT_NAME_AND_VERSION_AUX) "System Design and Verification Platform"
if {[::Utilities::isUnix]} {
  set ::env(THIS_PRODUCT_LOGO) "[set ::Basics::INSTALLATION_ROOT]/xpm/splash.xpm"
} else {
  set ::env(THIS_PRODUCT_LOGO) "[set ::Basics::INSTALLATION_ROOT]/gif/splash.gif"
}
set ::env(THIS_PRODUCT_NAME_LOCATION_ON_LOGO) {150 145}
set ::env(THIS_PRODUCT_BUILD_INFO_LOCATION_ON_LOGO) {120 195}
set ::env(THIS_PRODUCT_NAME_LOCATION_ON_LOGO_AUX) {120 170}
set ::env(THIS_PRODUCT_COPYRIGHT_LOCATION_ON_LOGO) {110 260}
set ::env(THIS_PRODUCT_LOGO_COLOR) white
set ::env(THIS_PRODUCT_LOGO_FONT) {Helvetica 16 bold}
set ::env(THIS_PRODUCT_COPYRIGHT_COLOR) red
set ::env(THIS_PRODUCT_COPYRIGHT_FONT) {Helvetica 8}
set ::Application::SHOW_LOGO 0
