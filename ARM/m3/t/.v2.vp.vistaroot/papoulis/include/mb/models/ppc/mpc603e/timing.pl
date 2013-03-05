
% use 0.5 cycles for all branching instructions.
latency(Insn, 0.5) :- unit(Insn, 'BPU').

% very long FPU instructions.
latency(fdivs, 18).
latency(fdiv, 33).
latency(fres, 18).

% first FPU pipeline stage.
latency(fmsub, 2).
latency(fmadd, 2).
latency(fnmadd, 2).
latency(fnmsub, 2).
latency(fmul, 2).

% other FPU instructions.
latency(Insn, 3) :- unit(Insn, 'FPU').

% Integer unit timing.
latency(twi, 2).
latency(mulli, 2.5).
latency(tw, 2).
latency(mulhwu, 4).
latency(mulhw, 3.5).
latency(mulld, 3.5).
latency(mullw, 3.5).
latency(divwu, 20).
latency(divw, 20).

% SRU unit timing.
latency(sc, 3).
latency(rfi, 3).
latency(mtmsr, 2).
latency(mtsr, 2).
latency(mtsrin, 2).
latency(mtspr, 2).
latency(mfsr, 3).
latency(mfsrin, 3).

% LSU unit timing.
latency(stwcx, 8).
latency(dcbt, 2).
latency(dcbtst, 2).
latency(tlbie, 3).
latency(dcbi, 2).
latency(tlbsync, 2).
latency(tlbld, 2).
latency(icbi, 3).
latency(tlbli, 3).
latency(dcbst, 3).
latency(dcbf, 3).
latency(dcbz, 10).

% Multiple load/store. Needs to be checked.
latency(stswx(S, A, B), N) :- N is 1 + B.
latency(stmw(S, A, B), N) :- N is 1 + B.
latency(stswi(S, A, B), N) :- N is 1 + B.
latency(lswx(D, A, B), N) :- N is 2 + B.
latency(lmw(D, A, B), N) :- N is 2 + B.
latency(lswi(D, A, B), N) :- N is 2 + B.

% Other LSU instructions are pipelined up to 2 at once.
latency(Insn, 2) :- unit(Insn, 'LSU').
