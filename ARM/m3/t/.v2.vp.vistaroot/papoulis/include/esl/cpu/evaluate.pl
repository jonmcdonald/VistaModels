
/* a common mechanism for evaluation of instruction timing and
   power policies */

/* latency(insn, latency) */
:- multifile(latency(_, _)).

/* bpu_penalty(insn, penalty),
   bpu_penalty(insn, backward_penalty, forward_penalty) */
:- multifile(bpu_penalty(_, _)).
:- multifile(bpu_penalty(_, _, _)).

/* energy(insn, energy) */
:- multifile(energy(_, _)).

/* proceed(insn) */
:- multifile(proceed(_)).

get_latency(Insn, L) :- functor(Insn, Name, Arity), Arity > 0, latency(Name, L), !.
get_latency(Insn, L) :- latency(Insn, L), !.
get_latency(_, 1).

get_bpu_penalty(Insn, Bw, Fw) :- functor(Insn, Name, Arity), Arity > 0, bpu_penalty(Name, Bw, Fw), !.
get_bpu_penalty(Insn, Bw, Fw) :- bpu_penalty(Insn, Bw, Fw).
get_bpu_penalty(Insn, Pn, Pn) :- functor(Insn, Name, Arity), Arity > 0, bpu_penalty(Name, Pn), !.
get_bpu_penalty(Insn, Pn, Pn) :- bpu_penalty(Insn, Pn).
get_bpu_penalty(_, 0, 0).

get_energy(Insn, L) :- functor(Insn, Name, Arity), Arity > 0, energy(Name, L), !.
get_energy(Insn, E) :- energy(Insn, E), !.
get_energy(_, 0).

do_proceed(Insn) :- functor(Insn, Name, Arity), Arity > 0, proceed(Name).
do_proceed(Insn) :- proceed(Insn).

/* Collection of state component predicates. */
:- dynamic(state_component/1).
define_state(Pred) :-
        dynamic(Pred),
        assert(state_component(Pred)).
clear_state :-
        findall(Pred, state_component(Pred), List),
        retract_pred(List).

/* Maintain stored state. */
:- dynamic(stored_state/1).
get_stored_state(L) :-
        (stored_state(L),!);L=[].
set_stored_state(L) :-
        retractall(stored_state(_)),
        assert(stored_state(L)).
apply_stored_state :-
        get_stored_state(L),
        assert_multiple(L),
        retractall(stored_state(_)).
clear_stored_state :-
        set_stored_state([]).
initiate_state(S) :-
        get_stored_state(L),
        set_stored_state([S|L]).

:- dynamic(insn_info/3).

/* Accumulate. */
accumulate(_, []).
accumulate(Addr, [Insn/Bits|Tail]) :-
        get_latency(Insn, Latency),
        get_bpu_penalty(Insn, BwBpuPenalty, FwBpuPenalty),
        get_energy(Insn, Energy),
        assertz(insn_info(Addr, Insn,
                          info(Latency, BwBpuPenalty, FwBpuPenalty, Energy))),
        findall(_, do_proceed(Insn), _),
        clear_state, apply_stored_state,
        NewAddr is Addr + Bits/8, accumulate(NewAddr, Tail).

/* Evaluate. */
evaluate_impl(Arch, Addr, Bytes) :-
        nonvar(Bytes),
        retract_pred(insn_info/3),
        asm(Arch, InsnList, Bytes),
        clear_state, clear_stored_state,
        accumulate(Addr, InsnList).

evaluate(Arch, Addr, Bytes, InsnCount, InfoSummary) :-
        evaluate_impl(Arch, Addr, Bytes),
        findall(Info, insn_info(_, _, Info), InfoList),
        length(InfoList, InsnCount),
        x_sum(InfoList, InfoSummary).

evaluate(Arch, Addr, Bytes, ResultList) :-
        evaluate_impl(Arch, Addr, Bytes),
        findall([Addr1, Insn1, Info1], insn_info(Addr1, Insn1, Info1), ResultList).
