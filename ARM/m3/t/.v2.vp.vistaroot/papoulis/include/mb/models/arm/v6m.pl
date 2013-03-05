
:- include(common).

:- include(thumb16).

insn(thumb, 'mrs.w'(r(D), Val),
       bin(1,1,1,1,0,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0,D3,D2,D1,D0,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(D, D3,D2,D1,D0),
        decode(Val, V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'msr.w'(r(N), Val),
       bin(1,1,1,1,0,0,1,1,1,0,0,0,N3,N2,N1,N0,1,0,0,0,V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0)) :-
        decode(N, N3,N2,N1,N0),
        decode(Val, V11,V10,V9,V8,V7,V6,V5,V4,V3,V2,V1,V0).

insn(thumb, 'bl.w'(S, Imm),
       bin(1,1,1,1,0,S,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,1,1,I22,1,I21,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0)) :-
        decode(Imm, I22,I21,I20,I19,I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1,I0).
insn_spec('bl.w'(_, _), branch).

insn(thumb, 'isb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,0,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'dmb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,0,1,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).

insn(thumb, 'dsb.w'(Val),
       bin(1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,0,0,V3,V2,V1,V0)) :-
        decode(Val, V3,V2,V1,V0).
