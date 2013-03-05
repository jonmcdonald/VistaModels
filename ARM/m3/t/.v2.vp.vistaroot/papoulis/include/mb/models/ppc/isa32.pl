
insn(ppc32, 'addc'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,0,0,0,0,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'adde'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,1,0,0,0,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'addic'(reg(D), reg(A), SIMM),
       bin(0,0,1,1,0,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'addicx'(reg(D), reg(A), SIMM),
       bin(0,0,1,1,0,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'addi'(reg(D), reg(A), SIMM),
       bin(0,0,1,1,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'addis'(reg(D), reg(A), SIMM),
       bin(0,0,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'addme'(reg(D), reg(A), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,OE,0,1,1,1,0,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'add'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,1,0,0,0,0,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'addze'(reg(D), reg(A), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,OE,0,1,1,0,0,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'andc'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'andi'(S, reg(A), UIMM),
       bin(0,1,1,1,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'andis'(S, reg(A), UIMM),
       bin(0,1,1,1,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'and'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'bc'(BO, BI, BD, AA, LK),
       bin(0,1,0,0,0,0,BO4,BO3,BO2,BO1,BO0,BI4,BI3,BI2,BI1,BI0,BD13,BD12,BD11,BD10,BD9,BD8,BD7,BD6,BD5,BD4,BD3,BD2,BD1,BD0,AA,LK)) :-
        decode(BO, BO4,BO3,BO2,BO1,BO0),
        decode(BI, BI4,BI3,BI2,BI1,BI0),
        decode(BD, BD13,BD12,BD11,BD10,BD9,BD8,BD7,BD6,BD5,BD4,BD3,BD2,BD1,BD0).

insn(ppc32, 'bcctr'(BO, BI, LK),
       bin(0,1,0,0,1,1,BO4,BO3,BO2,BO1,BO0,BI4,BI3,BI2,BI1,BI0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,LK)) :-
        decode(BO, BO4,BO3,BO2,BO1,BO0),
        decode(BI, BI4,BI3,BI2,BI1,BI0).

insn(ppc32, 'bclr'(BO, BI, LK),
       bin(0,1,0,0,1,1,BO4,BO3,BO2,BO1,BO0,BI4,BI3,BI2,BI1,BI0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,LK)) :-
        decode(BO, BO4,BO3,BO2,BO1,BO0),
        decode(BI, BI4,BI3,BI2,BI1,BI0).

insn(ppc32, 'b'(LI, AA, LK),
       bin(0,1,0,0,1,0,LI23,LI22,LI21,LI20,LI19,LI18,LI17,LI16,LI15,LI14,LI13,LI12,LI11,LI10,LI9,LI8,LI7,LI6,LI5,LI4,LI3,LI2,LI1,LI0,AA,LK)) :-
        decode(LI, LI23,LI22,LI21,LI20,LI19,LI18,LI17,LI16,LI15,LI14,LI13,LI12,LI11,LI10,LI9,LI8,LI7,LI6,LI5,LI4,LI3,LI2,LI1,LI0).

insn(ppc32, 'cmp'(CRFD, L, reg(A), reg(B)),
       bin(0,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,L,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'cmpi'(CRFD, L, reg(A), SIMM),
       bin(0,0,1,0,1,1,CRFD2,CRFD1,CRFD0,0,L,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'cmpl'(CRFD, L, reg(A), reg(B)),
       bin(0,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,L,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'cmpli'(CRFD, L, reg(A), UIMM),
       bin(0,0,1,0,1,0,CRFD2,CRFD1,CRFD0,0,L,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'cntlzdx'(S, reg(A), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'cntlzw'(S, reg(A), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'crandc'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,0,1,0,0,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'crand'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,1,0,0,0,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'creqv'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,1,0,0,1,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'crnand'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,0,1,1,1,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'crnor'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,0,0,0,1,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'crorc'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,1,1,0,1,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'cror'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,1,1,1,0,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'crxor'(CRBD, CRBA, CRBB),
       bin(0,1,0,0,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,CRBA4,CRBA3,CRBA2,CRBA1,CRBA0,CRBB4,CRBB3,CRBB2,CRBB1,CRBB0,0,0,1,1,0,0,0,0,0,1,0)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0),
        decode(CRBA, CRBA4,CRBA3,CRBA2,CRBA1,CRBA0),
        decode(CRBB, CRBB4,CRBB3,CRBB2,CRBB1,CRBB0).

insn(ppc32, 'dcbf'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'dcbi'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,1,0,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'dcbst'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'dcbt'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,0,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'dcbtst'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,1,1,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'dcbz'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,1,1,1,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'divdux'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,1,1,1,0,0,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'divdx'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,1,1,1,1,0,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'divw'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,1,1,1,1,0,1,0,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'divwu'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,1,1,1,0,0,1,0,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'eciwx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,1,1,0,1,1,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'ecowx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,0,1,1,0,1,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'eieio',
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,1,0,0)).

insn(ppc32, 'eqv'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,0,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'extsb'(S, reg(A), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,0,0,0,0,0,1,1,1,0,1,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'extsh'(S, reg(A), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,0,0,0,0,0,1,1,1,0,0,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'extsw'(S, reg(A), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,0,0,0,0,0,1,1,1,1,0,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'fabs'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,1,0,0,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fadd'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fadds'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fcfid'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,1,1,0,1,0,0,1,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fcmpo'(CRFD, reg(A), reg(B)),
       bin(1,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fcmpu'(CRFD, reg(A), reg(B)),
       bin(1,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fctid'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,1,1,0,0,1,0,1,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fctidz'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,1,1,0,0,1,0,1,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fctiw'(reg(D), reg(B), X),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,0,1,1,1,0,X)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fctiwz'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,0,1,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fdiv'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fdivs'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fmadd'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fmadds'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fmr'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,1,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fmsub'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fmsubs'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fmul'(reg(D), reg(A), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,C4,C3,C2,C1,C0,1,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fmuls'(reg(D), reg(A), reg(C), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,C4,C3,C2,C1,C0,1,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fnabs'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,1,0,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fneg'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,1,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fnmadd'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fnmadds'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fnmsub'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fnmsubs'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,1,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fres'(reg(D), reg(B), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,1,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'frsp'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,0,1,1,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'frsqrte'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,1,1,0,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fsel'(reg(D), reg(A), reg(B), reg(C), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,C4,C3,C2,C1,C0,1,0,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(C, C4,C3,C2,C1,C0).

insn(ppc32, 'fsqrt'(reg(D), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fsqrts'(reg(D), reg(B), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,1,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fsub'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'fsubs'(reg(D), reg(A), reg(B), RC),
       bin(1,1,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'icbi'(reg(A), reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,1,1,0,1,0,1,1,0,0)) :-
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'isync',
       bin(0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0)).

insn(ppc32, 'lbz'(reg(D), reg(A), DI),
       bin(1,0,0,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lbzu'(reg(D), reg(A), DI),
       bin(1,0,0,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lbzux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lbzx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'ldarx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,1,0,1,0,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'ld'(reg(D), reg(A), DS),
       bin(1,1,1,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DS, DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0).

insn(ppc32, 'ldu'(reg(D), reg(A), DS),
       bin(1,1,1,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0,0,1)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DS, DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0).

insn(ppc32, 'ldux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'ldx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lfd'(reg(D), reg(A), DI),
       bin(1,1,0,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lfdu'(reg(D), reg(A), DI),
       bin(1,1,0,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lfdux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,1,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lfdx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,1,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lfs'(reg(D), reg(A), DI),
       bin(1,1,0,0,0,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lfsu'(reg(D), reg(A), DI),
       bin(1,1,0,0,0,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lfsux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lfsx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lha'(reg(D), reg(A), DI),
       bin(1,0,1,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lhau'(reg(D), reg(A), DI),
       bin(1,0,1,0,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lhaux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,1,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lhax'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,1,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lhbrx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,0,0,0,1,0,1,1,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lhz'(reg(D), reg(A), DI),
       bin(1,0,1,0,0,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lhzu'(reg(D), reg(A), DI),
       bin(1,0,1,0,0,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lhzux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lhzx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lmw'(reg(D), reg(A), DI),
       bin(1,0,1,1,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lswi'(reg(D), reg(A), NB),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,NB4,NB3,NB2,NB1,NB0,1,0,0,1,0,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(NB, NB4,NB3,NB2,NB1,NB0).

insn(ppc32, 'lswx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,0,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwa'(reg(D), reg(A), DS),
       bin(1,1,1,0,1,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DS, DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0).

insn(ppc32, 'lwarx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,0,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwaux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,1,1,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwax'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,1,0,1,0,1,0,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwbrx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,0,1,0,1,1,0,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwz'(reg(D), reg(A), DI),
       bin(1,0,0,0,0,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lwzu'(reg(D), reg(A), DI),
       bin(1,0,0,0,0,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'lwzux'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,1,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'lwzx'(reg(D), reg(A), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,0,1,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mcrf'(CRFD, CRFS),
       bin(0,1,0,0,1,1,CRFD2,CRFD1,CRFD0,0,0,CRFS2,CRFS1,CRFS0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(CRFS, CRFS2,CRFS1,CRFS0).

insn(ppc32, 'mcrfs'(CRFD, CRFS),
       bin(1,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,0,CRFS2,CRFS1,CRFS0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(CRFS, CRFS2,CRFS1,CRFS0).

insn(ppc32, 'mcrxr'(CRFD),
       bin(0,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0).

insn(ppc32, 'mfcr'(reg(D)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0).

insn(ppc32, 'mffs'(reg(D), RC),
       bin(1,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0).

insn(ppc32, 'mfmsr'(reg(D)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0).

insn(ppc32, 'mfspr'(reg(D), SPR),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,SPR9,SPR8,SPR7,SPR6,SPR5,SPR4,SPR3,SPR2,SPR1,SPR0,0,1,0,1,0,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(SPR, SPR9,SPR8,SPR7,SPR6,SPR5,SPR4,SPR3,SPR2,SPR1,SPR0).

insn(ppc32, 'mfsrin'(reg(D), reg(B)),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,0,0,0,0,0,B4,B3,B2,B1,B0,1,0,1,0,0,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mfsr'(reg(D), SR),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,0,SR3,SR2,SR1,SR0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(SR, SR3,SR2,SR1,SR0).

insn(ppc32, 'mftb'(reg(D), TBR),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,TBR9,TBR8,TBR7,TBR6,TBR5,TBR4,TBR3,TBR2,TBR1,TBR0,0,1,0,1,1,1,0,0,1,1,0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(TBR, TBR9,TBR8,TBR7,TBR6,TBR5,TBR4,TBR3,TBR2,TBR1,TBR0).

insn(ppc32, 'mtcrf'(S, CRM),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,0,CRM7,CRM6,CRM5,CRM4,CRM3,CRM2,CRM1,CRM0,0,0,0,1,0,0,1,0,0,0,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(CRM, CRM7,CRM6,CRM5,CRM4,CRM3,CRM2,CRM1,CRM0).

insn(ppc32, 'mtfsb0'(CRBD, RC),
       bin(1,1,1,1,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,RC)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0).

insn(ppc32, 'mtfsb1'(CRBD, RC),
       bin(1,1,1,1,1,1,CRBD4,CRBD3,CRBD2,CRBD1,CRBD0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,RC)) :-
        decode(CRBD, CRBD4,CRBD3,CRBD2,CRBD1,CRBD0).

insn(ppc32, 'mtfsf'(FM, reg(B), RC),
       bin(1,1,1,1,1,1,0,FM7,FM6,FM5,FM4,FM3,FM2,FM1,FM0,0,B4,B3,B2,B1,B0,1,0,1,1,0,0,0,1,1,1,RC)) :-
        decode(FM, FM7,FM6,FM5,FM4,FM3,FM2,FM1,FM0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mtfsfi'(CRFD, IMM, RC),
       bin(1,1,1,1,1,1,CRFD2,CRFD1,CRFD0,0,0,0,0,0,0,0,IMM3,IMM2,IMM1,IMM0,0,0,0,1,0,0,0,0,1,1,0,RC)) :-
        decode(CRFD, CRFD2,CRFD1,CRFD0),
        decode(IMM, IMM3,IMM2,IMM1,IMM0).

insn(ppc32, 'mtmsr'(S),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0).

insn(ppc32, 'mtspr'(S, SPR),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,SPR9,SPR8,SPR7,SPR6,SPR5,SPR4,SPR3,SPR2,SPR1,SPR0,0,1,1,1,0,1,0,0,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(SPR, SPR9,SPR8,SPR7,SPR6,SPR5,SPR4,SPR3,SPR2,SPR1,SPR0).

insn(ppc32, 'mtsrin'(S, reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,0,0,0,0,0,B4,B3,B2,B1,B0,0,0,1,1,1,1,0,0,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mtsr'(S, SR),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,0,SR3,SR2,SR1,SR0,0,0,0,0,0,0,0,1,1,0,1,0,0,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(SR, SR3,SR2,SR1,SR0).

insn(ppc32, 'mulhdux'(reg(D), reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,0,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mulhdx'(reg(D), reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,0,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mulhw'(reg(D), reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,0,1,0,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mulhwu'(reg(D), reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,0,1,0,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mulld'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,1,1,1,0,1,0,0,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'mulli'(reg(D), reg(A), SIMM),
       bin(0,0,0,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'mullw'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,1,1,1,0,1,0,1,1,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'nand'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,1,0,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'neg'(reg(D), reg(A), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,OE,0,0,1,1,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'nor'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,1,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'orc'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,0,0,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'ori'(S, reg(A), UIMM),
       bin(0,1,1,0,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'oris'(S, reg(A), UIMM),
       bin(0,1,1,0,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'or'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,0,1,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'rfi',
       bin(0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0)).

insn(ppc32, 'rldclx'(S, reg(A), reg(B), MB, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,MB4,MB3,MB2,MB1,MB0,0,1,0,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(MB, MB4,MB3,MB2,MB1,MB0).

insn(ppc32, 'rldcrx'(S, reg(A), reg(B), ME, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,ME4,ME3,ME2,ME1,ME0,0,1,0,0,1,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(ME, ME4,ME3,ME2,ME1,ME0).

insn(ppc32, 'rldiclx'(S, reg(A), SH, MB, SHF, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,MB5,MB4,MB3,MB2,MB1,MB0,0,0,0,SHF,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(MB, MB5,MB4,MB3,MB2,MB1,MB0).

insn(ppc32, 'rldicrx'(S, reg(A), SH, ME, SHF, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,ME5,ME4,ME3,ME2,ME1,ME0,0,0,1,SHF,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(ME, ME5,ME4,ME3,ME2,ME1,ME0).

insn(ppc32, 'rldicx'(S, reg(A), SH, MB, SHF, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,MB5,MB4,MB3,MB2,MB1,MB0,0,1,0,SHF,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(MB, MB5,MB4,MB3,MB2,MB1,MB0).

insn(ppc32, 'rldimix'(S, reg(A), SH, MB, SHF, RC),
       bin(0,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,MB5,MB4,MB3,MB2,MB1,MB0,0,1,1,SHF,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(MB, MB5,MB4,MB3,MB2,MB1,MB0).

insn(ppc32, 'rlwimi'(S, reg(A), SH, MB, ME, RC),
       bin(0,1,0,1,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,MB4,MB3,MB2,MB1,MB0,ME4,ME3,ME2,ME1,ME0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(MB, MB4,MB3,MB2,MB1,MB0),
        decode(ME, ME4,ME3,ME2,ME1,ME0).

insn(ppc32, 'rlwinm'(S, reg(A), SH, MB, ME, RC),
       bin(0,1,0,1,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,MB4,MB3,MB2,MB1,MB0,ME4,ME3,ME2,ME1,ME0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0),
        decode(MB, MB4,MB3,MB2,MB1,MB0),
        decode(ME, ME4,ME3,ME2,ME1,ME0).

insn(ppc32, 'rlwnm'(S, reg(A), reg(B), MB, ME, RC),
       bin(0,1,0,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,MB4,MB3,MB2,MB1,MB0,ME4,ME3,ME2,ME1,ME0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0),
        decode(MB, MB4,MB3,MB2,MB1,MB0),
        decode(ME, ME4,ME3,ME2,ME1,ME0).

insn(ppc32, 'sc',
       bin(0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0)).

insn(ppc32, 'slbia',
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,0)).

insn(ppc32, 'slbie'(reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,B4,B3,B2,B1,B0,0,1,1,0,1,1,0,0,1,0,0)) :-
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'sldx'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,1,0,1,1,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'slw'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,1,1,0,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'sradix'(S, reg(A), SH, SHF, RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,1,1,0,0,1,1,1,0,1,SHF,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0).

insn(ppc32, 'sradx'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,0,0,0,1,1,0,1,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'srawi'(S, reg(A), SH, RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,SH4,SH3,SH2,SH1,SH0,1,1,0,0,1,1,1,0,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SH, SH4,SH3,SH2,SH1,SH0).

insn(ppc32, 'sraw'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,0,0,0,1,1,0,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'srdx'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,0,1,1,0,1,1,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'srw'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,0,0,0,1,1,0,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stb'(S, reg(A), DI),
       bin(1,0,0,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stbu'(S, reg(A), DI),
       bin(1,0,0,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stbux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,1,1,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stbx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,1,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stdcx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,1,0,1,0,1,1,0,1)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'std'(S, reg(A), DS),
       bin(1,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DS, DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0).

insn(ppc32, 'stdu'(S, reg(A), DS),
       bin(1,1,1,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0,0,1)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DS, DS13,DS12,DS11,DS10,DS9,DS8,DS7,DS6,DS5,DS4,DS3,DS2,DS1,DS0).

insn(ppc32, 'stdux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,0,1,1,0,1,0,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stdx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,0,0,1,0,1,0,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stfd'(S, reg(A), DI),
       bin(1,1,0,1,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stfdu'(S, reg(A), DI),
       bin(1,1,0,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stfdux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,1,1,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stfdx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,1,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stfiwx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,1,1,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stfs'(S, reg(A), DI),
       bin(1,1,0,1,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stfsu'(S, reg(A), DI),
       bin(1,1,0,1,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stfsux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,0,1,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stfsx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,0,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'sthbrx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,1,1,0,0,1,0,1,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'sth'(S, reg(A), DI),
       bin(1,0,1,1,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'sthu'(S, reg(A), DI),
       bin(1,0,1,1,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'sthux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,0,1,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'sthx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,1,0,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stmw'(S, reg(A), DI),
       bin(1,0,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stswi'(S, reg(A), NB),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,NB4,NB3,NB2,NB1,NB0,1,0,1,1,0,1,0,1,0,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(NB, NB4,NB3,NB2,NB1,NB0).

insn(ppc32, 'stswx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,0,0,1,0,1,0,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stwbrx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,1,0,1,0,0,1,0,1,1,0,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stwcx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,0,0,1,0,1,1,0,1)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stw'(S, reg(A), DI),
       bin(1,0,0,1,0,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stwu'(S, reg(A), DI),
       bin(1,0,0,1,0,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(DI, DI15,DI14,DI13,DI12,DI11,DI10,DI9,DI8,DI7,DI6,DI5,DI4,DI3,DI2,DI1,DI0).

insn(ppc32, 'stwux'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,0,1,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'stwx'(S, reg(A), reg(B)),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,1,0,0,1,0,1,1,1,0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'subfc'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,0,0,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'subfe'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,1,0,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'subfic'(reg(D), reg(A), SIMM),
       bin(0,0,1,0,0,0,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'subfme'(reg(D), reg(A), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,OE,0,1,1,1,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'subf'(reg(D), reg(A), reg(B), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,OE,0,0,0,1,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'subfze'(reg(D), reg(A), OE, RC),
       bin(0,1,1,1,1,1,D4,D3,D2,D1,D0,A4,A3,A2,A1,A0,0,0,0,0,0,OE,0,1,1,0,0,1,0,0,0,RC)) :-
        decode(D, D4,D3,D2,D1,D0),
        decode(A, A4,A3,A2,A1,A0).

insn(ppc32, 'sync',
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,1,0,0)).

insn(ppc32, 'tdi'(TO, reg(A), SIMM),
       bin(0,0,0,0,1,0,TO4,TO3,TO2,TO1,TO0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(TO, TO4,TO3,TO2,TO1,TO0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'td'(TO, reg(A), reg(B)),
       bin(0,1,1,1,1,1,TO4,TO3,TO2,TO1,TO0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,1,0,0,0,1,0,0,0)) :-
        decode(TO, TO4,TO3,TO2,TO1,TO0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'tlbia',
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,1,0,0)).

insn(ppc32, 'tlbie'(reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,B4,B3,B2,B1,B0,0,1,0,0,1,1,0,0,1,0,0)) :-
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'tlbld'(reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,B4,B3,B2,B1,B0,1,1,1,1,0,1,0,0,1,0,0)) :-
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'tlblid'(reg(B)),
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,B4,B3,B2,B1,B0,1,1,1,1,1,1,0,0,1,0,0)) :-
        decode(B, B4,B3,B2,B1,B0).      

insn(ppc32, 'tlbsync',
       bin(0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,1,1,0,0)).

insn(ppc32, 'twi'(TO, reg(A), SIMM),
       bin(0,0,0,0,1,1,TO4,TO3,TO2,TO1,TO0,A4,A3,A2,A1,A0,SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0)) :-
        decode(TO, TO4,TO3,TO2,TO1,TO0),
        decode(A, A4,A3,A2,A1,A0),
        decode(SIMM, SIMM15,SIMM14,SIMM13,SIMM12,SIMM11,SIMM10,SIMM9,SIMM8,SIMM7,SIMM6,SIMM5,SIMM4,SIMM3,SIMM2,SIMM1,SIMM0).

insn(ppc32, 'tw'(TO, reg(A), reg(B)),
       bin(0,1,1,1,1,1,TO4,TO3,TO2,TO1,TO0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,0,0,0,0,0,0,1,0,0,0)) :-
        decode(TO, TO4,TO3,TO2,TO1,TO0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).

insn(ppc32, 'xori'(S, reg(A), UIMM),
       bin(0,1,1,0,1,0,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'xoris'(S, reg(A), UIMM),
       bin(0,1,1,0,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(UIMM, UIMM15,UIMM14,UIMM13,UIMM12,UIMM11,UIMM10,UIMM9,UIMM8,UIMM7,UIMM6,UIMM5,UIMM4,UIMM3,UIMM2,UIMM1,UIMM0).

insn(ppc32, 'xor'(S, reg(A), reg(B), RC),
       bin(0,1,1,1,1,1,S4,S3,S2,S1,S0,A4,A3,A2,A1,A0,B4,B3,B2,B1,B0,0,1,0,0,1,1,1,1,0,0,RC)) :-
        decode(S, S4,S3,S2,S1,S0),
        decode(A, A4,A3,A2,A1,A0),
        decode(B, B4,B3,B2,B1,B0).
