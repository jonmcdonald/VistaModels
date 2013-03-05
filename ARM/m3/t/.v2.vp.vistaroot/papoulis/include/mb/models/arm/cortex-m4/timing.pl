
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

latency('sdiv.w', 7).
latency('udiv.w', 7).

latency('cpsid', 1.5).
latency('cpsid.w', 1.5).
latency('cpsie', 1.5).
latency('cpsie.w', 1.5).
latency('mrs.w', 1.5).
latency('msr.w', 1.5).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Floating point.

:- define_state(fpu_regs_lock/1).

proceed(Insn) :-
        fpu_insn(Insn),
        get_regs([o], Insn, OutputRegs),
        single_regs(OutputRegs, SingleRegs),
        initiate_state(fpu_regs_lock(SingleRegs)).

sync_regs_lock(Insn, 1) :-
        fpu_regs_lock(Regs),
        get_regs([i], Insn, InputRegs),
        single_regs(InputRegs, SingleRegs),
        intersects(Regs, SingleRegs), !.
sync_regs_lock(_, 0).

%% We're currently not modeling the FPU/ALU pipelining with
%% vsqrt/vdiv instructions. TODO. Current issues:
%%   IO timing is unknown at static time
%%   Actual cycle count is not visible with this API
%%   FPU stall must be passed beyond end of current block.
fpu_latency('vsqrt.f32', 14).
fpu_latency('vdiv.f32', 10).

fpu_latency('vmla.f32', 3).
fpu_latency('vmls.f32', 3).
fpu_latency('vnmla.f32', 3).
fpu_latency('vnmls.f32', 3).
fpu_latency('vfma.f32', 3).
fpu_latency('vfms.f32', 3).
fpu_latency('vfnma.f32', 3).
fpu_latency('vfnms.f32', 3).
fpu_latency('vmov', 2).

fpu_latency(Insn, N) :- compound(Insn), functor(Insn, Name, _),
        (fpu_latency(Name, N) ; N = 1).

latency(Insn, L) :- fpu_insn(Insn),
        fpu_latency(Insn, L1),
        sync_regs_lock(Insn, L2),
        L is L1 + L2.
