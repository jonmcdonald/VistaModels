
/* VABS. */

insn(Arch, 'vabs.f32'(Cond, s(D)/o, s(M)/i),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,0,0, D3,D2,D1,D0, 1,0,1,0, 1,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).


/* VADD. */

insn(Arch, 'vadd.f32'(Cond, s(D)/o, s(N), s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,1,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,0,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(N, N3,N2,N1,N0,NX),
	decode(M, M3,M2,M1,M0,MX).

/* VCMP, VCMPE. */

insn(Arch, 'vcmp.f32'(Cond, s(D), s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,1,0,0, D3,D2,D1,D0, 1,0,1,0, E,1,MX,0, M3,M2,M1,M0)) :-
        E = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).

insn(Arch, 'vcmpe.f32'(Cond, s(D), s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,1,0,0, D3,D2,D1,D0, 1,0,1,0, E,1,MX,0, M3,M2,M1,M0)) :-
        E = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).

insn(Arch, 'vcmp.f32'(Cond, s(D)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,1,0,1, D3,D2,D1,D0, 1,0,1,0, E,1,0,0, 0,0,0,0)) :-
        E = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX).

insn(Arch, 'vcmpe.f32'(Cond, s(D)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,1,0,1, D3,D2,D1,D0, 1,0,1,0, E,1,0,0,0,0,0,0)) :-
        E = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX).


/* VCVT{R} (between floating-point and integer). */

/* vcvt_mode/5(Mode, OPC22,OPC21,OPC20,OP) */
vcvt_mode('.s32.f32', 1,0,1, 1).
vcvt_mode('r.s32.f32', 1,0,1, 0).
vcvt_mode('.u32.f32', 1,0,0, 1).
vcvt_mode('r.u32.f32', 1,0,0, 0).
vcvt_mode('.f32.s32', 0,0,0, 1).
vcvt_mode('.f32.u32', 0,0,0, 0).
          
insn(Arch, 'vcvt'(Mode, Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 1,OPC22,OPC21,OPC20, D3,D2,D1,D0, 1,0,1,0, OP,1,MX,0, M3,M2,M1,M0)) :-
        vcvt_mode(Mode, OPC22,OPC21,OPC20, OP),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).


/* VCVT (between floating-point and fixed-point). */

/* vcvt_mode/4(Mode, OP, U, S) */
vcvt_mode('.f32.s16', 0, 0, 0).
vcvt_mode('.f32.u16', 0, 1, 0).
vcvt_mode('.f32.s32', 0, 0, 1).
vcvt_mode('.f32.u32', 0, 1, 1).
vcvt_mode('.s16.f32', 1, 0, 0).
vcvt_mode('.u16.f32', 1, 1, 0).
vcvt_mode('.s32.f32', 1, 0, 1).
vcvt_mode('.u32.f32', 1, 1, 1).

insn(Arch, 'vcvt'(Mode, Cond, s(D)/o, Fbits),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 1,OP,1,U, D3,D2,D1,D0, 1,0,1,0, S,1,I,0, I3, I2, I1, I0)) :-
        vcvt_mode(Mode, OP, U, S),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
        decode(Fbits, I3,I2,I1,I0,I).


/* VCVTB, VCVTT. */

/* vcvt_mode/3(Mode, OP, T) */
vcvt_mode('b.f32.f16', 0, 0).
vcvt_mode('b.f16.f32', 1, 0).
vcvt_mode('t.f32.f16', 0, 1).
vcvt_mode('t.f16.f32', 1, 1).

insn(Arch, 'vcvtb'(Mode, Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,1,OP, D3,D2,D1,D0, 1,0,1,0, T,1,MX,0, M3,M2,M1,M0)) :-
        vcvt_mode(Mode, OP, T),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).

insn(Arch, 'vcvtt'(Mode, Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,1,OP, D3,D2,D1,D0, 1,0,1,0, T,1,MX,0, M3,M2,M1,M0)) :-
        vcvt_mode(Mode, OP, T),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).


/* VDIV. */

insn(Arch, 'vdiv.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,0,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,0,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

/* VFMA, VFMS. */

insn(Arch, 'vfma.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

insn(Arch, 'vfms.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

/* VFNMA, VFNMS. */

insn(Arch, 'vfnma.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

insn(Arch, 'vfnms.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

/* VLDM. */

/* viom_mode(Mode, P, U, W) */
viom_mode('ia', 0, 1, 0).
viom_mode('ia!', 0, 1, 1).
viom_mode('db!', 1, 0, 1).

insn(Arch, 'vldm.32'(Mode, Cond, r(N), s(D)/o, Count),
	bin(C3,C2,C1,C0, 1,1,0,P, U,DX,W,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        viom_mode(Mode, P, U, W),
	decode(N, N3,N2,N1,N0), N \== 13,
        decode(D, D3,D2,D1,D0,DX),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0).

insn(Arch, 'vldm.64'(Mode, Cond, r(N), d(D)/o, Count),
	bin(C3,C2,C1,C0, 1,1,0,P, U,DX,W,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        viom_mode(Mode, P, U, W),
	decode(N, N3,N2,N1,N0), N \== 13,
        decode(D, DX,D3,D2,D1,D0),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0).

/* VLDR. */

vio_offset(+Offset, Offset, 1).
vio_offset(-Offset, Offset, 0).

insn(Arch, 'vldr.32'(Cond, s(D)/o, r(N), Offset),
	bin(C3,C2,C1,C0, 1,1,0,1, U,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0),
	decode(D, D3,D2,D1,D0,DX),
	decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0,0,0),
        vio_offset(Offset, Imm, U).

insn(Arch, 'vldr.64'(Cond, d(D)/o, r(N), Offset),
	bin(C3,C2,C1,C0, 1,1,0,1, U,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0),
	decode(D, DX,D3,D2,D1,D0),
	decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0,0,0),
        vio_offset(Offset, Imm, U).


/* VMLA, VMLS. */

insn(Arch, 'vmla.f32'(Cond, s(D)/o, s(N), s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,0,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(N, N3,N2,N1,N0,NX),
	decode(M, M3,M2,M1,M0,MX).

insn(Arch, 'vmls.f32'(Cond, s(D)/o, s(N), s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,0,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(N, N3,N2,N1,N0,NX),
	decode(M, M3,M2,M1,M0,MX).


/* VMOV (immediate). */

insn(Arch, 'vmov.f32'(Cond, s(D)/o, Imm),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, I7,I6,I5,I4, D3,D2,D1,D0, 1,0,1,0, 0,0,0,0, I3,I2,I1,I0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        decode(D, D3,D2,D1,D0,DX),
	decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0).

/* VMOV (register). */

insn(Arch, 'vmov.f32'(Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,0,0, D3,D2,D1,D0, 1,0,1,0, 0,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).


/* VMOV (ARM core register to scalar). */

insn(Arch, 'vmov.32'(Cond, d(D)/o, r(T), H),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,0,H,0, D3,D2,D1,D0, T3,T2,T1,T0, 1,0,1,1, DX,0,0,1, 0,0,0,0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, DX,D3,D2,D1,D0),
	decode(T, T3,T2,T1,T0).

/* VMOV (scalar to ARM core register). */

insn(Arch, 'vmov.32'(Cond, r(T)/o, d(Dn), H),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,0,H,1, Dn3,Dn2,Dn1,Dn0, T3,T2,T1,T0, 1,0,1,1, NX,0,0,1, 0,0,0,0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(Dn, NX,Dn3,Dn2,Dn1,Dn0),
	decode(T, T3,T2,T1,T0).

/* VMOV (between ARM core register and single-precision register). */

insn(Arch, 'vmov'(Cond, s(N)/o, r(T)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,0,0,OP, N3,N2,N1,N0, T3,T2,T1,T0, 1,0,1,0, NX,0,0,1, 0,0,0,0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0,NX),
	decode(T, T3,T2,T1,T0).

insn(Arch, 'vmov'(Cond, r(T)/o, s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,0,0,OP, N3,N2,N1,N0, T3,T2,T1,T0, 1,0,1,0, NX,0,0,1, 0,0,0,0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0,NX),
	decode(T, T3,T2,T1,T0).


/* VMOV (between two ARM core registers and two single-precision registers). */

insn(Arch, 'vmov'(Cond, s(M)/o, s(M1)/o, r(T), r(T2)),
	bin(C3,C2,C1,C0, 1,1,0,0, 0,1,0,OP, T23,T22,T21,T20, T3,T2,T1,T0, 1,0,1,0, 0,0,MX,1, M3,M2,M1,M0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0),
	decode(T2, T23,T22,T21,T20),
	decode(M, M3,M2,M1,M0,MX),
        succ(M, M1).

insn(Arch, 'vmov'(Cond, r(T)/o, r(T2)/o, s(M), s(M1)),
	bin(C3,C2,C1,C0, 1,1,0,0, 0,1,0,OP, T23,T22,T21,T20, T3,T2,T1,T0, 1,0,1,0, 0,0,MX,1, M3,M2,M1,M0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0),
	decode(T2, T23,T22,T21,T20),
	decode(M, M3,M2,M1,M0,MX),
        succ(M, M1).

/* VMOV (between two ARM core registers and a doubleword register) */

insn(Arch, 'vmov'(Cond, d(Dm)/o, r(T), r(T2)),
	bin(C3,C2,C1,C0, 1,1,0,0, 0,1,0,OP, T23,T22,T21,T20, T3,T2,T1,T0, 1,0,1,1, 0,0,MX,1, Dm3,Dm2,Dm1,Dm0)) :-
        OP = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0),
	decode(T2, T23,T22,T21,T20),
	decode(Dm, MX,Dm3,Dm2,Dm1,Dm0).

insn(Arch, 'vmov'(Cond, r(T)/o, r(T2)/o, d(Dm)),
	bin(C3,C2,C1,C0, 1,1,0,0, 0,1,0,OP, T23,T22,T21,T20, T3,T2,T1,T0, 1,0,1,1, 0,0,MX,1, Dm3,Dm2,Dm1,Dm0)) :-
        OP = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0),
	decode(T2, T23,T22,T21,T20),
	decode(Dm, MX,Dm3,Dm2,Dm1,Dm0).

/* VMRS, VMSR */

insn(Arch, 'vmrs'(Cond, r(T)/o),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,1,1,1, 0,0,0,1, T3,T2,T1,T0, 1,0,1,0, 0,0,0,1, 0,0,0,0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0).

insn(Arch, 'vmsr'(Cond, r(T)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,1,1,0, 0,0,0,1, T3,T2,T1,T0, 1,0,1,0, 0,0,0,1, 0,0,0,0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(T, T3,T2,T1,T0).

/* VMUL. */

insn(Arch, 'vmul.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,1,0, N3,N2,N1,N0, D3,D2,D1,D0,1,0,1,0, NX,0,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).


/* VNEG. */

insn(Arch, 'vneg.f32'(Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,0,1, D3,D2,D1,D0, 1,0,1,0, 0,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).


/* VNMLA, VNMLS, VNMUL. */

insn(Arch, 'vnmla.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        OP = 1,
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

insn(Arch, 'vnmls.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,0,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,OP,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        OP = 0,
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).

insn(Arch, 'vnmul.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,1,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).


/* VPOP, VPUSH. */

insn(Arch, 'vpop.32'(Cond, SRegs/o),
	bin(C3,C2,C1,C0, 1,1,0,0, 1,DX,1,1, 1,1,0,1, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        decode(D, D3,D2,D1,D0,DX),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0),
        collect_regs(s(D), Count, SRegs).

insn(Arch, 'vpop.64'(Cond, DRegs/o),
	bin(C3,C2,C1,C0, 1,1,0,0, 1,DX,1,1, 1,1,0,1, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1, bit(I0),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        decode(D, DX,D3,D2,D1,D0),
        decode(Count, I7,I6,I5,I4,I3,I2,I1), /* count of dregs */
        collect_regs(d(D), Count, DRegs).

insn(Arch, 'vpush.32'(Cond, SRegs),
	bin(C3,C2,C1,C0, 1,1,0,1, 0,DX,1,0, 1,1,0,1, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        decode(D, D3,D2,D1,D0,DX),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0),
        collect_regs(s(D), Count, SRegs).

insn(Arch, 'vpush.64'(Cond, DRegs),
	bin(C3,C2,C1,C0, 1,1,0,1, 0,DX,1,0, 1,1,0,1, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1, bit(I0),
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        decode(D, DX,D3,D2,D1,D0),
        decode(Count, I7,I6,I5,I4,I3,I2,I1), /* count of dregs */
        collect_regs(d(D), Count, DRegs).


/* VSQRT. */

insn(Arch, 'vsqrt.f32'(Cond, s(D)/o, s(M)),
	bin(C3,C2,C1,C0, 1,1,1,0, 1,DX,1,1, 0,0,0,1, D3,D2,D1,D0, 1,0,1,0, 1,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX).

/* VSTM. */

insn(Arch, 'vstm.32'(Mode, Cond, r(N), s(D), Count),
	bin(C3,C2,C1,C0, 1,1,0,P, U,DX,W,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        viom_mode(Mode, P, U, W),
	decode(N, N3,N2,N1,N0),
        decode(D, D3,D2,D1,D0,DX),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0).

insn(Arch, 'vstm.64'(Mode, Cond, r(N), d(D), Count),
	bin(C3,C2,C1,C0, 1,1,0,P, U,DX,W,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
        viom_mode(Mode, P, U, W),
	decode(N, N3,N2,N1,N0),
        decode(D, DX,D3,D2,D1,D0),
        decode(Count, I7,I6,I5,I4,I3,I2,I1,I0).

/* VSTR. */

insn(Arch, 'vstr.32'(Cond, s(D), r(N), Offset),
	bin(C3,C2,C1,C0, 1,1,0,1, U,DX,0,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 0,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0),
	decode(D, D3,D2,D1,D0,DX),
	decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0,0,0),
        vio_offset(Offset, Imm, U).

insn(Arch, 'vstr.64'(Cond, d(D), r(N), Offset),
	bin(C3,C2,C1,C0, 1,1,0,1, U,DX,0,0, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,S, I7,I6,I5,I4,I3,I2,I1,I0)) :-
        S = 1,
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(N, N3,N2,N1,N0),
	decode(D, DX,D3,D2,D1,D0),
	decode(Imm, I7,I6,I5,I4,I3,I2,I1,I0,0,0),
        vio_offset(Offset, Imm, U).

/* VSUB. */

insn(Arch, 'vsub.f32'(Cond, s(D)/o, s(M), s(N)),
	bin(C3,C2,C1,C0, 1,1,1,0, 0,DX,1,1, N3,N2,N1,N0, D3,D2,D1,D0, 1,0,1,0, NX,1,MX,0, M3,M2,M1,M0)) :-
        insn_cond(Arch, Cond, bin(C3,C2,C1,C0)),
	decode(D, D3,D2,D1,D0,DX),
	decode(M, M3,M2,M1,M0,MX),
	decode(N, N3,N2,N1,N0,NX).



/* Insns specs. */

fpu_insn('vabs.f32').
fpu_insn('vadd.f32').
fpu_insn('vcmp.f32').
fpu_insn('vcmpe.f32').
fpu_insn('vcvt').
fpu_insn('vcvt').
fpu_insn('vcvtb').
fpu_insn('vcvtt').
fpu_insn('vdiv.f32').
fpu_insn('vfma.f32').
fpu_insn('vfms.f32').
fpu_insn('vfnma.f32').
fpu_insn('vfnms.f32').
fpu_insn('vldm.32').
fpu_insn('vldm.64').
fpu_insn('vldr.32').
fpu_insn('vldr.64').
fpu_insn('vmla.f32').
fpu_insn('vmls.f32').
fpu_insn('vmov.f32').
fpu_insn('vmov.32').
fpu_insn('vmov').
fpu_insn('vmrs').
fpu_insn('vmsr').
fpu_insn('vmul.f32').
fpu_insn('vneg.f32').
fpu_insn('vnmla.f32').
fpu_insn('vnmls.f32').
fpu_insn('vnmul.f32').
fpu_insn('vpop.32').
fpu_insn('vpop.64').
fpu_insn('vpush.32').
fpu_insn('vpush.64').
fpu_insn('vsqrt.f32').
fpu_insn('vstm.32').
fpu_insn('vstm.64').
fpu_insn('vstr.32').
fpu_insn('vstr.64').
fpu_insn('vsub.f32').
fpu_insn(Term) :- compound(Term), functor(Term, N, _), fpu_insn(N).
