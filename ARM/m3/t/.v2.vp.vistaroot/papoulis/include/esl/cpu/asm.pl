
/* insn(Insn, Decode) */
:- multifile(insn(_, _, _)).

/* insn_spec(Insn, Spec).
   Spec: load(AddrRegs, TargetRegs),
   Spec: store(AddrRegs, TargetRegs) */
:- multifile(insn_spec(_,_)).

insn_spec(Insn, 'load/store'(AddrRegs, _, OutRegs)) :-
        insn_spec(Insn, load(AddrRegs, OutRegs)).

insn_spec(Insn, 'load/store'(AddrRegs, InRegs, _)) :-
        insn_spec(Insn, store(AddrRegs, InRegs)).


/* Obtain instruction length in bits. */
insn_bits(Arch, Insn, Len) :-
        insn(Arch, Insn, Bin),
        functor(Bin, bin, Len).


/* asm/3 definition */
  
asm(Arch, Insns, Bytes) :-
        endianness(Endianness),
        architecture(Arch, Bitness),
        asm(Bitness, Endianness, Arch, Insns, Bytes).


/* asm/5 definition */

asm(_, _, _, [], []).

asm(16, Endianness, Arch, InsnList, [AX, BX|Bytes]) :-
        var(InsnList), InsnList = [Insn/16|Insns],
        swap_bytes(Endianness, bytes(AX, BX), bytes(A, B)),
        decode(A, A7, A6, A5, A4, A3, A2, A1, A0),
        decode(B, B7, B6, B5, B4, B3, B2, B1, B0),
        insn(Arch, Insn,
             bin(A7, A6, A5, A4, A3, A2, A1, A0,
                 B7, B6, B5, B4, B3, B2, B1, B0)), !,
        asm(16, Endianness, Arch, Insns, Bytes).

asm(16, Endianness, Arch, InsnList, [AX, BX, CX, DX|Bytes]) :-
        var(InsnList), InsnList = [Insn/32|Insns],
        swap_bytes(Endianness, bytes(AX, BX), bytes(A, B)),
        swap_bytes(Endianness, bytes(CX, DX), bytes(C, D)),
        decode(A, A7, A6, A5, A4, A3, A2, A1, A0),
        decode(B, B7, B6, B5, B4, B3, B2, B1, B0),
        decode(C, C7, C6, C5, C4, C3, C2, C1, C0),
        decode(D, D7, D6, D5, D4, D3, D2, D1, D0),
        insn(Arch, Insn,
             bin(A7, A6, A5, A4, A3, A2, A1, A0,
                 B7, B6, B5, B4, B3, B2, B1, B0,
                 C7, C6, C5, C4, C3, C2, C1, C0,
                 D7, D6, D5, D4, D3, D2, D1, D0)), !,
        asm(16, Endianness, Arch, Insns, Bytes).

asm(32, Endianness, Arch, InsnList, [AX, BX, CX, DX|Bytes]) :-
        var(InsnList), InsnList = [Insn/32|Insns],
        swap_bytes(Endianness, bytes(AX, BX, CX, DX), bytes(A, B, C, D)),
        decode(A, A7, A6, A5, A4, A3, A2, A1, A0),
        decode(B, B7, B6, B5, B4, B3, B2, B1, B0),
        decode(C, C7, C6, C5, C4, C3, C2, C1, C0),
        decode(D, D7, D6, D5, D4, D3, D2, D1, D0),
        insn(Arch, Insn,
             bin(A7, A6, A5, A4, A3, A2, A1, A0,
                 B7, B6, B5, B4, B3, B2, B1, B0,
                 C7, C6, C5, C4, C3, C2, C1, C0,
                 D7, D6, D5, D4, D3, D2, D1, D0)), !,
        asm(32, Endianness, Arch, Insns, Bytes).
