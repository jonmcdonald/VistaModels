# makes string type
proc .s {str} {
  append kuku $str
}

# makes string type
proc :s {str} {
  append kuku $str
}

# makes boolean type
proc :b {str} {
  bool $str
}

# makes integer type
proc :i {str} {
  int $str
}

# makes list type
proc :l {str} {
  list $str
}
