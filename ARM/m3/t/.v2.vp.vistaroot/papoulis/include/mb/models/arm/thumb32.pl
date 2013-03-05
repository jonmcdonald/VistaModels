
insn(thumb, 'adcs.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'adcs.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'adc.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'adc.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'adds.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'adds.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'add.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'add.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'addw.w'(r(Rd), r(Rn), Imm),
       bin(1,1,1,1,0,I11,1,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'ands.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'ands.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'and.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'and.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'asrs.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'asr.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'bfc.w'(r(Rd), Msb, Imm),
       bin(1,1,1,1,0,0,1,1,0,1,1,0,1,1,1,1,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,M4,M3,M2,M1,M0)) :-
        decode(Msb, M4,M3,M2,M1,M0),
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'bfi.w'(r(Rd), r(Rn), Msb, Imm),
       bin(1,1,1,1,0,0,1,1,0,1,1,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,M4,M3,M2,M1,M0)) :-
        decode(Msb, M4,M3,M2,M1,M0),
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'bics.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,0,1,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'bics.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,0,1,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'bic.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,0,1,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'bic.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,0,1,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'bl.w'(S, Imm),
       bin(1,1,1,1,0,S,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,1,1,I22,1,I21,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I22,I21,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('bl.w'(_, _), branch).

insn(thumb, 'blx.w'(S, Cond, Imm),
       bin(1,1,1,1,0,S,C3,C2,C1,C0,I16,I15,I14,I13,I12,I11,1,1,I18,0,I17,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Cond, C3,C2,C1,C0),
        decode(Imm, I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn(thumb, 'blx.w'(_, _, _), cond_branch).

insn(thumb, 'b.w'(S, Cond, Imm),
       bin(1,1,1,1,0,S,C3,C2,C1,C0,I16,I15,I14,I13,I12,I11,1,0,I18,0,I17,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Cond, C3,C2,C1,C0),
        decode(Imm, I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn(thumb, 'b.w'(_, _, _), cond_branch).

insn(thumb, 'b.w'(S, Imm),
       bin(1,1,1,1,0,S,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,1,0,I22,1,I21,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I22,I21,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn(thumb, 'b.w'(_, _), branch).

insn(thumb, 'bxj.w'(r(Rn)),
       bin(1,1,1,1,0,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('bxj.w'(_), branch).

insn(thumb, 'clrex.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,0,1,0,1,1,1,1)).

insn(thumb, 'clz.w'(r(Rd), r(Rm)),
       bin(1,1,1,1,1,0,1,0,1,0,1,1,Rm3,Rm2,Rm1,Rm0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, 'cmn.w'(r(Rm), r(Rn), Imm, Sh),
       bin(1,1,1,0,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,1,1,1,1,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'cmn.w'(r(Rn), Imm),
       bin(1,1,1,1,0,I11,0,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,1,1,1,1,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'cmp.w'(r(Rm), r(Rn), Imm, Sh),
       bin(1,1,1,0,1,0,1,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,1,1,1,1,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'cmp.w'(r(Rn), Imm),
       bin(1,1,1,1,0,I11,0,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,1,1,1,1,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'cpsid.w'(Arg, Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,1,1,1,V2,V1,V0,A4,A3,A2,A1,A0)) :-
        decode(Arg, A4,A3,A2,A1,A0),
        decode(Val, V2,V1,V0).

insn(thumb, 'cpsid.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,1,1,0,V2,V1,V0,0,0,0,0,0)) :-
        decode(Val, V2,V1,V0).

insn(thumb, 'cpsie.w'(Arg, Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,1,0,1,V2,V1,V0,A4,A3,A2,A1,A0)) :-
        decode(Arg, A4,A3,A2,A1,A0),
        decode(Val, V2,V1,V0).

insn(thumb, 'cpsie.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,1,0,0,V2,V1,V0,0,0,0,0,0)) :-
        decode(Val, V2,V1,V0).

insn(thumb, 'cps.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'dbg.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'dmb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,0,1,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'dsb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,0,0,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'eors.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'eors.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'eor.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'eor.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'isb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,0,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'ldmdb.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'ldmdb!.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,1,0,0,1,1,Rn3,Rn2,Rn1,Rn0, PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'ldmia.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'ldmia!.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,0,1,1,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'ldrd.w'(r(Rt), r(Rf), r(Rn), U),
       bin(1,1,1,0,1,0,0,1,1,1,U,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,0,0,0,0,0,0,0,0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('ldrd.w'(T, F, N, _), load([N], [T, F])).

insn(thumb, 'ldrd.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,0,U,1,1,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'ldrd.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,1,U,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('ldrd.w'(T, F, N, _, _), load([N], [T, F])).

insn(thumb, 'ldrd!.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,1,U,1,1,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('ldrd!.w'(T, F, N, _, _), load([N], [T, F])).

insn(thumb, 'ldrexb.w'(r(Rt), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,0,1,0,1,1,1,1,1)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('ldrexb.w'(T, N), load([N], [T])).

insn(thumb, 'ldrexd.w'(r(Rt), r(Rm), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rm3,Rm2,Rm1,Rm0,0,1,1,1,1,1,1,1)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('ldrexd.w'(T, M, N), load([M, N], [T])).

insn(thumb, 'ldrexh.w'(r(Rt), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,0,1,0,0,1,1,1,1)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('ldrexh.w'(T, N), load([N], [T])).

insn(thumb, 'ldrex.w'(r(Rt), r(Rn)),
       bin(1,1,1,0,1,0,0,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,0,0,0,0,0,0,0,0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).
insn_spec('ldrex.w'(T, N), load([N], [T])).

insn(thumb, 'ldrex.w'(r(Rt), r(Rn), Imm),
       bin(1,1,1,0,1,0,0,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('ldrex.w'(T, N, _), load([N], [T])).

insn(thumb, 'ldr.w'(r(Rt), r(Rn), Mode, Imm),
       bin(1,1,1,1,1,0,0,M3,M2,M1,M0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Mode, M3,M2,M1,M0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('ldr.w'(T, N, _, _), load([N], [T])).

insn(thumb, 'ldrwt.w'(r(Rt), r(Rn), M, Imm, Sh),
       bin(1,1,1,1,1,0,0,M,0,S1,S0,1,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).
insn_spec('ldrwt.w'(T, N, _, _, _), load([N], [T])).

insn(thumb, 'lsls.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'lsl.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'lsrs.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'lsr.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'mla.w'(r(Rd), r(Ra), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,Ra3,Ra2,Ra1,Ra0,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Ra, Ra3,Ra2,Ra1,Ra0), Ra < 15,
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'mls.w'(r(Rd), r(Ra), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,Ra3,Ra2,Ra1,Ra0,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Ra, Ra3,Ra2,Ra1,Ra0),
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'movs.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,0,0,0,1,0,1,1,1,1,1,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'movt.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,1,0,1,1,0,0,I15,I14,I13,I12,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'mov.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,0,0,0,1,0,0,1,1,1,1,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'mov.w'(r(Rd), r(Rm), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,0,1,0,0,1,1,1,1,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'mov.w'(r(Rd), r(Rm), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,0,1,0,0,1,1,1,1,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'movw.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,1,0,0,1,0,0,I15,I14,I13,I12,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'mrs.w'(r(Rd), Val),
       bin(1,1,1,1,0,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'msr.w'(r(Rn), Val),
       bin(1,1,1,1,0,0,1,1,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,0,0,0,V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'mul.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'mvns.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,0,0,0,1,1,1,1,1,1,1,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'mvns.w'(r(Rd), r(Rm), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,0,1,1,1,1,1,1,1,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'mvns.w'(r(Rd), r(Rm), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,0,1,1,1,1,1,1,1,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'mvn.w'(r(Rd), Imm),
       bin(1,1,1,1,0,I11,0,0,0,1,1,0,1,1,1,1,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'nop.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)).

insn(thumb, 'nop.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'orns.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,1,1,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'orns.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,1,1,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'orn.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,1,1,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'orn.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,1,1,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'orrs.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'orrs.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'orr.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'orr.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'pkhbt.w'(r(Rd), r(Rn), Width, Imm),
       bin(1,1,1,0,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,0,W3,W2,W1,W0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Width, W3,W2,W1,W0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'pkhtb.w'(r(Rd), r(Rn), Width, Imm),
       bin(1,1,1,0,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,1,0,W3,W2,W1,W0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Width, W3,W2,W1,W0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'pld.w'(r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,0,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,0,0,0,0,0,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'pli.w'(r(Rn), Val),
       bin(1,1,1,1,1,0,0,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,1,1,0,0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'pli.w'(r(Rn), Val),
       bin(1,1,1,1,1,0,0,1,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'pli.w'(U, Val),
       bin(1,1,1,1,1,0,0,1,U,0,0,1,1,1,1,1,1,1,1,1,V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'qadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qaddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qadd.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qdadd.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qdsub.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,1,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qsub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qsub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qsubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'qsub.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rbit.w'(r(Rd), r(Rm)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rm3,Rm2,Rm1,Rm0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, 'rev16.w'(r(Rd), r(Rm)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rm3,Rm2,Rm1,Rm0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, 'revsh.w'(r(Rd), r(Rm)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rm3,Rm2,Rm1,Rm0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,1,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, 'rev.w'(r(Rd), r(Rm)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rm3,Rm2,Rm1,Rm0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0).

insn(thumb, 'rfedb.w'(r(Rn)),
       bin(1,1,1,0,1,0,0,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rfedb!.w'(r(Rn)),
       bin(1,1,1,0,1,0,0,0,0,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rfeia.w'(r(Rn)),
       bin(1,1,1,0,1,0,0,1,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rfeia!.w'(r(Rn)),
       bin(1,1,1,0,1,0,0,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rors.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,1,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'ror.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,0,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'rsbs.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,1,1,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'rsbs.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,1,1,0,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'rsb.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'rsb.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'sadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'sadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'saddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'sbcs.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,1,1,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'sbcs.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,1,1,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'sbc.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,0,1,1,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'sbc.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,0,1,1,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'sbfx.w'(r(Rd), r(Rn), Width, Imm),
       bin(1,1,1,1,0,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,W4,W3,W2,W1,W0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Width, W4,W3,W2,W1,W0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'sdiv.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,1,1,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'sel.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'sev.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0)).

insn(thumb, 'shadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'shadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'shaddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'shsub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'shsub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'shsubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smc.w'(Imm, Val),
       bin(1,1,1,1,0,1,1,1,1,1,1,1,V3,V2,V1,V0,1,0,0,0,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0),
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'smlad.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smladx.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlald.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,1,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlaldx.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,1,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlal.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlal.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn), F),
       bin(1,1,1,1,1,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,1,0,F_1,F_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(F, F_1,F_0),
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlawb.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smla.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn), F),
       bin(1,1,1,1,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,F_1,F_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(F, F_1,F_0),
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlawt.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlsd.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlsdx.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlsld.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,0,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,1,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smlsldx.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,0,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,1,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmlar.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmla.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmlsr.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmls.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmulr.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smmul.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smuad.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smuadx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smulbb.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smulbt.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smull.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,0,0,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smultb.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smultt.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smulwb.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smulwt.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smusd.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'smusdx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'srsdb.w'(r(Rn), Val),
       bin(1,1,1,0,1,0,0,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V4,V3,V2,V1,V0).

insn(thumb, 'srsdb!.w'(r(Rn), Val),
       bin(1,1,1,0,1,0,0,0,0,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V4,V3,V2,V1,V0).

insn(thumb, 'srsia.w'(r(Rn), Val),
       bin(1,1,1,0,1,0,0,1,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V4,V3,V2,V1,V0).

insn(thumb, 'srsia!.w'(r(Rn), Val),
       bin(1,1,1,0,1,0,0,1,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,0,0,0,0,0,0,0,0,0,V4,V3,V2,V1,V0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V4,V3,V2,V1,V0).

insn(thumb, 'ssat16.w'(r(Rd), r(Rn), Imm),
       bin(1,1,1,1,0,0,1,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,0,0,0,0,Rd3,Rd2,Rd1,Rd0,0,0,0,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'ssat.w'(r(Rd), r(Rn), Sat, Imm, Sh),
       bin(1,1,1,1,0,0,1,1,0,0,Sh,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,St4,St3,St2,St1,St0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sat, St4,St3,St2,St1,St0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'ssub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'ssub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'ssubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'stmdb.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,1,0,0,0,0,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'stmdb!.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,1,0,0,1,0,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'stmia.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'stmia!.w'(Regs, r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,PC,LR,0,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1,R0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        pick([r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr,pc],
             [R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,LR,PC], Regs).

insn(thumb, 'strd.w'(r(Rt), r(Rf), r(Rn), U),
       bin(1,1,1,0,1,0,0,1,1,1,U,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,0,0,0,0,0,0,0,0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0).
insn_spec('strd.w'(T, F, N, _), store([N], [T, F])).

insn(thumb, 'strd.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,0,U,1,1,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'strd.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,1,U,1,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('strd.w'(T, F, N, _, _), store([N], [T, F])).

insn(thumb, 'strd!.w'(r(Rt), r(Rf), r(Rn), U, Imm),
       bin(1,1,1,0,1,0,0,1,U,1,1,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rf3,Rf2,Rf1,Rf0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Rf, Rf3,Rf2,Rf1,Rf0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('strd!.w'(T, F, N, _, _), store([N], [T, F])).

insn(thumb, 'strexb.w'(r(Rt), r(Rd), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,0,1,0,0,Rd3,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0).
insn_spec('strexb.w'(T, D, N), store([N], [T, D])).

insn(thumb, 'strexd.w'(r(Rt), r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rm3,Rm2,Rm1,Rm0,Rd3,Rd2,Rd1,Rd0,0,1,1,1,Rt3,Rt2,Rt1,Rt0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0).
insn_spec('strexd.w'(T, D, M, N), store([M, N], [T, D])).

insn(thumb, 'strexh.w'(r(Rt), r(Rd), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,1,0,1,0,1,Rd3,Rd2,Rd1,Rd0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0).
insn_spec('strexh.w'(T, D, N), store([N], [T, D])).

insn(thumb, 'strex.w'(r(Rt), r(Rd), r(Rn)),
       bin(1,1,1,0,1,0,0,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rd3,Rd2,Rd1,Rd0,0,0,0,0,0,0,0,0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0).
insn_spec('strex.w'(T, D, N), store([N], [T, D])).

insn(thumb, 'strex.w'(r(Rt), r(Rd), r(Rn), Val),
       bin(1,1,1,0,1,0,0,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).
insn_spec('strex.w'(T, D, N, _), store([N], [T, D])).

insn(thumb, 'str.w'(r(Rt), r(Rn), Mode, Imm),
       bin(1,1,1,1,1,0,0,0,M2,M1,M0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Mode, M2,M1,M0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('str.w'(T, N, _, _), store([N], [T])).

insn(thumb, 'strwt.w'(r(Rt), r(Rn), Imm, Sh),
       bin(1,1,1,1,1,0,0,0,0,Sh,0,0,Rn3,Rn2,Rn1,Rn0,Rt3,Rt2,Rt1,Rt0,1,1,1,0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Rt, Rt3,Rt2,Rt1,Rt0),
        decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('strwt.w'(T, N, _, _), store([N], [T])).

insn(thumb, 'subs.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'subs.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'subs.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,1,0,1,1,1,1,0,1,0,0,0,1,1,1,1,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'sub.w'(r(Rd), r(Rm), r(Rn), Tp, Imm),
       bin(1,1,1,0,1,0,1,1,1,0,1,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,Tp_1,Tp_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Tp, Tp_1,Tp_0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'sub.w'(r(Rd), r(Rn), Val),
       bin(1,1,1,1,0,V11,0,1,1,0,1,0,Rn3,Rn2,Rn1,Rn0,0,V10,V9,V8,Rd3,Rd2,Rd1,Rd0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'subw.w'(r(Rd), r(Rn), Imm),
       bin(1,1,1,1,0,I11,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,Rd3,Rd2,Rd1,Rd0,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'sxtab16.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'sxtab.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'sxtah.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'sxtb16.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'sxtb.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'sxth.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'tbb.w'(r(Rm), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,0,0,0,0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'tbh.w'(r(Rm), r(Rn)),
       bin(1,1,1,0,1,0,0,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,0,0,0,0,0,0,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'teq.w'(r(Rm), r(Rn), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,1,1,1,1,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'teq.w'(r(Rn), Imm),
       bin(1,1,1,1,0,I11,0,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,1,1,1,1,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'tst.w'(r(Rm), r(Rn), Imm, Sh),
       bin(1,1,1,0,1,0,1,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,1,1,1,1,I1,I0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0),
        decode(Sh, S1,S0).

insn(thumb, 'tst.w'(r(Rn), Imm),
       bin(1,1,1,1,0,I11,0,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,0,I10,I9,I8,1,1,1,1,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).

insn(thumb, 'uadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uaddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'ubfx.w'(r(Rd), r(Rn), Width, Imm),
       bin(1,1,1,1,0,0,1,1,1,1,0,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,W4,W3,W2,W1,W0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Width, W4,W3,W2,W1,W0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'udiv.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,1,1,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhaddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhsub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhsub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uhsubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'umaal.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,1,1,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'umlal.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,1,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'umull.w'(r(Rdhi), r(Rdlo), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,1,0,1,0,Rn3,Rn2,Rn1,Rn0,Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0,Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rdhi, Rdhi_3,Rdhi_2,Rdhi_1,Rdhi_0),
        decode(Rdlo, Rdlo_3,Rdlo_2,Rdlo_1,Rdlo_0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqadd16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqadd8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqaddsubx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,0,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqsub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqsub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uqsubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,1,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'usad8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'usada8.w'(r(Rd), r(Ra), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,1,0,1,1,1,Rn3,Rn2,Rn1,Rn0,Ra3,Ra2,Ra1,Ra0,Rd3,Rd2,Rd1,Rd0,0,0,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Ra, Ra3,Ra2,Ra1,Ra0),
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'usat16.w'(r(Rd), r(Rn), Imm),
       bin(1,1,1,1,0,0,1,1,1,0,1,0,Rn3,Rn2,Rn1,Rn0,0,0,0,0,Rd3,Rd2,Rd1,Rd0,0,0,0,I4,I3,I2,I1,I0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'usat.w'(r(Rd), r(Rn), Sat, Imm, Sh),
       bin(1,1,1,1,0,0,1,1,1,0,Sh,0,Rn3,Rn2,Rn1,Rn0,0,I4,I3,I2,Rd3,Rd2,Rd1,Rd0,I1,I0,0,St4,St3,St2,St1,St0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sat, St4,St3,St2,St1,St0),
        decode(Imm, I4,I3,I2,I1,I0).

insn(thumb, 'usub16.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'usub8.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,0,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'usubaddx.w'(r(Rd), r(Rm), r(Rn)),
       bin(1,1,1,1,1,0,1,0,1,1,1,0,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,0,1,0,0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0).

insn(thumb, 'uxtab16.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,0,1,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'uxtab.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,1,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'uxtah.w'(r(Rd), r(Rm), r(Rn), Sh),
       bin(1,1,1,1,1,0,1,0,0,0,0,1,Rn3,Rn2,Rn1,Rn0,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,S1,S0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rn, Rn3,Rn2,Rn1,Rn0),
        decode(Sh, S1,S0).

insn(thumb, 'uxtb16.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,0,1,1,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'uxtb.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'uxth.w'(r(Rd), r(Rm), Rot),
       bin(1,1,1,1,1,0,1,0,0,0,0,1,1,1,1,1,1,1,1,1,Rd3,Rd2,Rd1,Rd0,1,0,Rot_1,Rot_0,Rm3,Rm2,Rm1,Rm0)) :-
        decode(Rd, Rd3,Rd2,Rd1,Rd0),
        decode(Rm, Rm3,Rm2,Rm1,Rm0),
        decode(Rot, Rot_1,Rot_0).

insn(thumb, 'wfe.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0)).

insn(thumb, 'wfi.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1)).

insn(thumb, 'yield.w',
       bin(1,1,1,1,0,0,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1)).
