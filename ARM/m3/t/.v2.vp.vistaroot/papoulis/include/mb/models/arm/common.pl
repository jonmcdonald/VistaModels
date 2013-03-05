
/* define architecture and decoder word size */
architecture(arm, 32).
architecture(thumb, 16).

/* GP Register bank. */
reg(r(N)) :- between(0, 15, N).

/* Some registers have a special name. */
reg_name(r(13), sp) :- !.
reg_name(r(14), lr) :- !.
reg_name(r(15), pc) :- !.
reg_name(R, R).

/* Conditions in ARM and THUMB/IT. */
cond(eq, bin(0, 0, 0, 0)).
cond(ne, bin(0, 0, 0, 1)).
cond(cs, bin(0, 0, 1, 0)).
cond(cc, bin(0, 0, 1, 1)).
cond(mi, bin(0, 1, 0, 0)).
cond(pl, bin(0, 1, 0, 1)).
cond(vs, bin(0, 1, 1, 0)).
cond(vc, bin(0, 1, 1, 1)).
cond(hi, bin(1, 0, 0, 0)).
cond(ls, bin(1, 0, 0, 1)).
cond(ge, bin(1, 0, 1, 0)).
cond(lt, bin(1, 0, 1, 1)).
cond(gt, bin(1, 1, 0, 0)).
cond(le, bin(1, 1, 0, 1)).
cond(al, bin(1, 1, 1, 0)).

/* Condition flags. */
cond_flags(eq, zcnv(1, C, N, V)) :- bit(C, N, V).
cond_flags(ne, zcnv(0, C, N, V)) :- bit(C, N, V).
cond_flags(cs, zcnv(Z, 1, N, V)) :- bit(Z, N, V).
cond_flags(cc, zcnv(Z, 0, N, V)) :- bit(Z, N, V).
cond_flags(mi, zcnv(Z, C, 1, V)) :- bit(Z, C, V).
cond_flags(pl, zcnv(Z, C, 0, V)) :- bit(Z, C, V).
cond_flags(vs, zcnv(Z, C, N, 1)) :- bit(Z, C, N).
cond_flags(vc, zcnv(Z, C, N, 0)) :- bit(Z, C, N).
cond_flags(hi, zcnv(0, 1, N, V)) :- bit(N, V).
cond_flags(ls, zcnv(1, 0, N, V)) :- bit(N, V).
cond_flags(ge, zcnv(Z, C, N, V)) :- bit(Z, C, N, V), N == V.
cond_flags(lt, zcnv(Z, C, N, V)) :- bit(Z, C, N, V), N \== V.
cond_flags(gt, zcnv(0, C, N, V)) :- bit(C, N, V), N == V.
cond_flags(le, zcnv(1, C, N, V)) :- bit(C, N, V), N \== V.
cond_flags(al, zcnv(Z, C, N, V)) :- bit(Z, C, N, V).

/* Condition names: Integer and FP semantics. */
cond_names(eq, 'Equal', 'Equal').
cond_names(ne, 'Not equal', 'Not equal or unordered').
cond_names(cs, 'Carry set', 'Greater than, equal or unordered').
cond_names(cc, 'Carry clear', 'Less than').
cond_names(mi, 'Negative', 'Less than').
cond_names(pl, 'Positive or zero', 'Greater than, equal or unordered').
cond_names(vs, 'Overflow', 'Unordered').
cond_names(vc, 'No overflow', 'Not unordered').
cond_names(hi, 'Unsigned higher', 'Greater than or unordered').
cond_names(ls, 'Unsigned lower or equal', 'Less than or equal').
cond_names(ge, 'Signed greater than or equal', 'Greater than or equal').
cond_names(lt, 'Signed less than', 'Less than or unordered').
cond_names(gt, 'Signed greater than', 'Greater than').
cond_names(le, 'Signed less than or equal', 'Less than, equal or unordered').
cond_names(al, 'Always', 'Always').

