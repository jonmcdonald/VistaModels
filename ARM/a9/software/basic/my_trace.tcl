set current_core "top.cpu.PV.core"

add_default_symbol_file

insert_tracepoint tp1 -at-function-entry my_function -do-raw {
  printf("On host: my_function entry...\n");
}

insert_tracepoint tp2 -at-function-exit my_function -do-raw {
  printf("On host: my_function exiting...\n");
}

insert_tracepoint tp3 -at-source main.c:38 -do-raw {
  printf("On host: main.c:38...\n");
//  printf("x is %d\n", x);
//  x = x + 33;
}

#insert_tracepoint tp4 -at-source main.c:38 -do-print x

insert_tracepoint tp5 -at-label my_function:my_label_2 -do-raw {
  printf("On host: my_label_2...\n");
//  printf("y is %d\n", y);
//  y = y * 2;
}

