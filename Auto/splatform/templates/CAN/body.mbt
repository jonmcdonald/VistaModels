# === generics ===
add_generic NumberPorts 4

# === ports ===
for { set num 0 } { $num < $NumberPorts } { incr num } {
  add_port "RX$num" /TLM/protocols/generic master 8 -bind_mode mandatory
  add_port "TX$num" /TLM/protocols/generic slave 8 -bind_mode mandatory
}

# === parameters ===

# === machine architecture ===
#for { set num 0 } { $num < $NumberPorts } { incr num } {
#  add_sequential_policy "RX$num.write" -cause tp1.write -latency 0 -sync 0 -power 0
#}
