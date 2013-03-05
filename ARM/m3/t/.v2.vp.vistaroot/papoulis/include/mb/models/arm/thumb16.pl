
insn(thumb, adc(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,1,0,1,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, add(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,1,0,0,Rdn3,Rm3,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn3,Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, add(r(Rdn), Imm),
       bin(0,0,1,1,0,Rdn2,Rdn1,Rdn0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, add(sp, Imm),
       bin(1,0,1,1,0,0,0,0,0,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I6,I5,I4,I3,I2,I1,I0).

insn(thumb, add(r(Rd), pc, Imm),
       bin(1,0,1,0,0,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, add(r(Rd), sp, Imm),
       bin(1,0,1,0,1,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, add(r(Rd), r(Rm), r(Rn)),
       bin(0,0,0,1,1,0,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).

insn(thumb, add(r(Rd), r(Rn), Imm),
       bin(0,0,0,1,1,1,0,I2,I1,I0,Rn2,Rn1,Rn0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Imm, I2,I1,I0).

insn(thumb, and(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,0,0,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, asr(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,1,0,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, asr(r(Rd), r(Rm), Imm),
       bin(0,0,0,1,0,I4,I3,I2,I1,I0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, b(Imm),
       bin(1,1,1,0,0,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec(b(_), branch).

insn(thumb, b(Cond, Imm),
       bin(1,1,0,1,C3,C2,C1,C0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Cond, C3,C2,C1,C0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec(b(_, _), cond_branch).

insn(thumb, bic(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,1,1,1,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, bkpt(Val),
       bin(1,0,1,1,1,1,1,0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, blx(r(Rm)),
       bin(0,1,0,0,0,1,1,1,1,Rm3,Rm2,Rm1,Rm0,0,0,0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0).
insn_spec(blx(_), branch).

insn(thumb, bx(r(Ra)),
       bin(0,1,0,0,0,1,1,1,0,Ra_3,Ra_2,Ra_1,Ra_0,0,0,0)) :-
        decode(Ra, Ra_3,Ra_2,Ra_1,Ra_0).
insn_spec(bx(_), branch).

insn(thumb, cbnz(r(Rn), Addr),
       bin(1,0,1,1,1,0,A5,1,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Addr, A5,A4,A3,A2,A1,A0).
insn_spec(cbnz(_, _), cond_branch).

insn(thumb, cbz(r(Rn), Addr),
       bin(1,0,1,1,0,0,A5,1,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Addr, A5,A4,A3,A2,A1,A0).
insn_spec(cbz(_, _), cond_branch).

insn(thumb, cmn(r(Rm), r(Rn)),
       bin(0,1,0,0,0,0,1,0,1,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).

insn(thumb, cmp(r(Rm), r(Rn)),
       bin(0,1,0,0,0,0,1,0,1,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).

insn(thumb, cmp(r(Rm), r(Rn)),
       bin(0,1,0,0,0,1,0,1,Rn3,Rm3,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, cmp(r(Rn), Imm),
       bin(0,0,1,0,1,Rn2,Rn1,Rn0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, cpsid(Mode),
       bin(1,0,1,1,0,1,1,0,0,1,1,1,0,0,M1,M0)) :-
        decode(Mode, M1,M0).

insn(thumb, cpsie(Mode),
       bin(1,0,1,1,0,1,1,0,0,1,1,0,0,0,M1,M0)) :-
        decode(Mode, M1,M0).

insn(thumb, eor(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,0,0,1,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, it(Fcond, Mask),
       bin(1,0,1,1,1,1,1,1,Fc3,Fc2,Fc1,Fc0,M3,M2,M1,M0)) :-
        decode(Fcond, Fc3,Fc2,Fc1,Fc0),
        decode(Mask, M3,M2,M1,M0),
        Mask > 0.

insn(thumb, ldmia(r(Rn), Regs),
       bin(1,1,0,0,1,Rn2,Rn1,Rn0,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7], [R0,R1,R2,R3,R4,R5,R6,R7], Regs).

insn(thumb, ldrb(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,1,1,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).
insn_spec(ldrb(T, M, N), load([M, N], [T])) :- reg(T).

insn(thumb, ldrb(r(Rt), r(Rn), Addr),
       bin(0,1,1,1,1,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Addr, A4,A3,A2,A1,A0).
insn_spec(ldrb(T, M, A), load([M], [T])) :- number(A).

insn(thumb, ldrh(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,1,0,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).
insn_spec(ldrh(T, M, N), load([M, N], [T])) :- reg(N).

insn(thumb, ldrh(r(Rt), r(Rn), Addr),
       bin(1,0,0,0,1,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Addr, A4,A3,A2,A1,A0).
insn_spec(ldrh(T, M, A), load([M], [T])) :- number(A).

insn(thumb, ldr(r(Rt), Addr),
       bin(0,1,0,0,1,Rt2,Rt1,Rt0,A7,A6,A5,A4,A3,A2,A1,A0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A7,A6,A5,A4,A3,A2,A1,A0).
insn_spec(ldr(T, _), load([], [T])).

insn(thumb, ldr(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,1,0,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).
insn_spec(ldr(T, M, N), load([M, N], [T])) :- reg(N).

insn(thumb, ldr(r(Rt), r(Rn), Addr),
       bin(0,1,1,0,1,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Addr, A4,A3,A2,A1,A0).
insn(thumb, ldr(r(Rt), sp, Addr),
       bin(1,0,0,1,1,Rt2,Rt1,Rt0,A7,A6,A5,A4,A3,A2,A1,A0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A7,A6,A5,A4,A3,A2,A1,A0).
insn_spec(ldr(T, N, A), load([N], [T])) :- number(A).

insn(thumb, ldrsb(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,1,1,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).
insn_spec(ldrsb(T, M, N), load([M, N], [T])).

insn(thumb, ldrsh(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,0,1,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).
insn_spec(ldrsh(T, M, N), load([M, N], [T])).

insn(thumb, lsl(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,0,1,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, lsl(r(Rd), r(Rm), Imm),
       bin(0,0,0,0,0,I4,I3,I2,I1,I0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, lsr(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,0,1,1,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, lsr(r(Rd), r(Rm), Imm),
       bin(0,0,0,0,1,I4,I3,I2,I1,I0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, mov(r(Rd), Imm),
       bin(0,0,1,0,0,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, mov(r(Rd), r(Rm)),
       bin(0,1,0,0,0,1,1,0,Rd3,Rm3,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, mul(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,1,1,0,1,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, mvn(r(Rd), r(Rm)),
       bin(0,1,0,0,0,0,1,1,1,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, neg(r(Rd), r(Rm)),
       bin(0,1,0,0,0,0,1,0,0,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, nop,
       bin(1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0)).

insn(thumb, nop(Val),
       bin(1,0,1,1,1,1,1,1,V3,V2,V1,V0,0,0,0,0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, orr(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,1,1,0,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, pop(Regs),
       bin(1,0,1,1,1,1,0,PC,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        pick([r0,r1,r2,r3,r4,r5,r6,r7,pc], [R0,R1,R2,R3,R4,R5,R6,R7,PC], Regs).

insn(thumb, push(Regs),
       bin(1,0,1,1,0,1,0,LR,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        pick([r0,r1,r2,r3,r4,r5,r6,r7,lr], [R0,R1,R2,R3,R4,R5,R6,R7,LR], Regs).

insn(thumb, rev16(r(Rd), r(Rm)),
       bin(1,0,1,1,1,0,1,0,0,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, rev(r(Rd), r(Rm)),
       bin(1,0,1,1,1,0,1,0,0,0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, revsh(r(Rd), r(Rm)),
       bin(1,0,1,1,1,0,1,0,1,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, ror(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,1,1,1,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, sbc(r(Rdn), r(Rm)),
       bin(0,1,0,0,0,0,0,1,1,0,Rm2,Rm1,Rm0,Rdn2,Rdn1,Rdn0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, setend(S),
       bin(1,0,1,1,0,1,1,0,0,1,0,1,S,0,0,0)).

insn(thumb, sev,
       bin(1,0,1,1,1,1,1,1,0,1,0,0,0,0,0,0)).

insn(thumb, stmia(r(Rn), Regs),
       bin(1,1,0,0,0,Rn2,Rn1,Rn0,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7], [R0,R1,R2,R3,R4,R5,R6,R7], Regs).

insn(thumb, strb(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,0,1,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0).
insn_spec(strb(T, M, N), store([M, N], [T])) :- reg(N).

insn(thumb, strb(r(Rt), r(Rn), Addr),
       bin(0,1,1,1,0,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A4,A3,A2,A1,A0).
insn_spec(strb(T, M, A), store([M], [T])) :- number(A).

insn(thumb, strh(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,0,0,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0).
insn_spec(strh(T, M, N), store([M, N], [T])) :- reg(N).

insn(thumb, strh(r(Rt), r(Rn), Addr),
       bin(1,0,0,0,0,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A4,A3,A2,A1,A0).
insn_spec(strh(T, M, A), store([M], [T])) :- number(A).

insn(thumb, str(r(Rt), r(Rm), r(Rn)),
       bin(0,1,0,1,0,0,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0).
insn_spec(str(T, M, N), store([M, N], [T])) :- reg(N).

insn(thumb, str(r(Rt), r(Rn), Addr),
       bin(0,1,1,0,0,A4,A3,A2,A1,A0,Rn2,Rn1,Rn0,Rt2,Rt1,Rt0)) :-
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A4,A3,A2,A1,A0).
insn(thumb, str(r(Rt), sp, Addr),
       bin(1,0,0,1,0,Rt2,Rt1,Rt0,A7,A6,A5,A4,A3,A2,A1,A0)) :-
        decode(Rt, Rt2,Rt1,Rt0),
        decode(Addr, A7,A6,A5,A4,A3,A2,A1,A0).
insn_spec(str(T, M, A), store([M], [T])) :- number(A).

insn(thumb, sub(r(Rdn), Imm),
       bin(0,0,1,1,1,Rdn2,Rdn1,Rdn0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rdn, Rdn2,Rdn1,Rdn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, sub(sp, Imm),
       bin(1,0,1,1,0,0,0,0,1,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I6,I5,I4,I3,I2,I1,I0).

insn(thumb, sub(r(Rd), r(Rm), r(Rn)),
       bin(0,0,0,1,1,0,1,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).

insn(thumb, sub(r(Rd), r(Rn), Imm),
       bin(0,0,0,1,1,1,1,I2,I1,I0,Rn2,Rn1,Rn0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rn, Rn2,Rn1,Rn0),
        decode(Imm, I2,I1,I0).

insn(thumb, svc(Val),
       bin(1,1,0,1,1,1,1,1,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, sxtb(r(Rd), r(Rm)),
       bin(1,0,1,1,0,0,1,0,0,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, sxth(r(Rd), r(Rm)),
       bin(1,0,1,1,0,0,1,0,0,0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, tst(r(Rm), r(Rn)),
       bin(0,1,0,0,0,0,1,0,0,0,Rm2,Rm1,Rm0,Rn2,Rn1,Rn0)) :-
        decode(Rm, Rm2,Rm1,Rm0),
        decode(Rn, Rn2,Rn1,Rn0).

insn(thumb, uxtb(r(Rd), r(Rm)),
       bin(1,0,1,1,0,0,1,0,1,1,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, uxth(r(Rd), r(Rm)),
       bin(1,0,1,1,0,0,1,0,1,0,Rm2,Rm1,Rm0,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd2,Rd1,Rd0),
        decode(Rm, Rm2,Rm1,Rm0).

insn(thumb, wfe,
       bin(1,0,1,1,1,1,1,1,0,0,1,0,0,0,0,0)).

insn(thumb, wfi,
       bin(1,0,1,1,1,1,1,1,0,0,1,1,0,0,0,0)).

insn(thumb, yield,
       bin(1,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0)).
