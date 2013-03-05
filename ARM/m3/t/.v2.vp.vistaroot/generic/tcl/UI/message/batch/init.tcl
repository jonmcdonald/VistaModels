summit_begin_package UI:message:batch

summit_package_require UI:message
summit_package_require Utilities

proc tk_messageBox {args} {
  set message ""
  ::Utilities::getOption $args -message message
  puts "$message\n"
  return ""
}

summit_end_package
