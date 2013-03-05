
/* The database of CPU registers. */
:- multifile(reg(_)).

/* Defines list of declared registers */
reg_list([]).
reg_list([R|T]) :- reg(R), reg_list(T).

/* Get registers from an instruction definition. */
get_regs1(_, [], []).
get_regs1(Tp, [Reg/TpX|T1], [Reg|T2]) :- reg(Reg), member(TpX, Tp), !, get_regs1(Tp, T1, T2).
get_regs1(Tp, [Reg|T1], [Reg|T2]) :- reg(Reg), member(i, Tp), !, get_regs1(Tp, T1, T2).
get_regs1(Tp, [Regs/TpX|T1], T2) :- reg_list(Regs), member(TpX, Tp), !, get_regs1(Tp, T1, X), append(Regs, X, T2).
get_regs1(Tp, [Regs|T1], T2) :- reg_list(Regs), member(i, Tp), !, get_regs1(Tp, T1, X), append(Regs, X, T2).
get_regs1(Tp, [_|T1], T2) :- get_regs1(Tp, T1, T2).
get_regs(Tp, Insn, OutRegs) :- Insn =.. [_|Args], get_regs1(Tp, Args, OutRegs).

/* Collect registers starting from the specified. Uses reg(X) database.
   Usage: collect_regs(r(3), 2, [r(3), r(4)]). */
collect_regs(FirstReg, Count, Out) :-
        FirstReg =.. [Bank, A],
        int_bounds(A, B, Count),
        findall(Reg, (reg(Reg), Reg =.. [Bank, X], between(A, B, X)), Out).

