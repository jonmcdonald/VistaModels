
:- include(v7m).
:- include(vfp-sp).

/* FP Register banks. */
reg(s(N)) :- between(0, 31, N).
reg(d(N)) :- between(0, 15, N).

/* Convert to single regs list. */
single_regs([], []).
single_regs([s(X)|T], [s(X)|T1]) :- single_regs(T, T1).
single_regs([d(X)|T], [s(X1), s(X2)|T1]) :- X1 is X * 2, X2 is X1 + 1, single_regs(T, T1).

/* Only 'al' condition is allowed in thumb. */
insn_cond(thumb, al, B) :- cond(al, B).

