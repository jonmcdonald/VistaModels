
%% Define branch predictor penalty.
%% Here we set 2 cycles for backward and 2 cycles for forward
%% not predicted conditional branches.
bpu_penalty(Insn, 2, 2) :-
         insn_spec(Insn, cond_branch).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Near store/load instruction can fold their address and
%% data phases, when the address of the second instruction
%% is not computed from result of the first.

:- define_state(io_pipe/1).

proceed(Insn) :-
        insn_spec(Insn, 'load/store'(_, _, OutRegs)),
        initiate_state(io_pipe(OutRegs)).

latency(Insn, 0) :-
        io_pipe(OutRegs),
        insn_spec(Insn, 'load/store'(AddrRegs, _, _)),
        intersection(OutRegs, AddrRegs, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 'it' instruction is completely folded with 16 thumb
%% environments.

:- define_state(halfword/0).

proceed(Insn) :-
        insn_bits(thumb, Insn, 16),
        initiate_state(halfword).

latency('it', 0) :-
        halfword.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define some (partly statistical) latencies for various long
%% instructions.

latency('mla.w', 2).
latency('smla.w', 2).
latency('smmla.w', 2).

latency('mls.w', 2).
latency('smmls.w', 2).

latency('smull.w', 4).
latency('umull.w', 4).

latency('smlal.w', 5).
latency('umlal.w', 5).

latency('sdiv.w', 3).
latency('udiv.w', 3).

latency('cpsid', 1.5).
latency('cpsid.w', 1.5).
latency('cpsie', 1.5).
latency('cpsie.w', 1.5).
latency('mrs.w', 1.5).
latency('msr.w', 1.5).

