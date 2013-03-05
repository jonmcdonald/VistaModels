
:- consult(common).
:- consult(isa32).

unit(Insn, 'BPU') :-
        functor(Insn, Name, _),
        member(Name, [b, bc, bclr, bcctr]).

unit(Insn, 'FPU') :-
        functor(Insn, Name, _),
        member(Name, [fdivs,fsubs,fadds,fsqrts,fres,fmuls,fmsubs,fmadds,fnmsubs,
                      fnmadds,fcmpu,frsp,fctiw,fctiwz,fdiv,fsub,fadd,fsqrt,fsel,
                      fmul,frsqrte,fmsub,fmadd,fnmsub,fnmadd,fcmpo,mtfsb1,fneg,mcrfs,
                      mtfsb0,fmr,mtfsfi,fnabs,fabs,mffs,mtfsf,fctid,fctidz,fcfid]).

unit(Insn, 'INT') :-
        functor(Insn, Name, _),
        member(Name, [twi,mulli,subfic,cmpli,cmpi,addic,addicx,addi,addis,rlwimi,rlwinm,
                      rlwnm,ori,oris,xori,xoris,andi,andis,cmp,tw,subfc,addc,mulhwu,slw,
                      cntlzw,and,cmpl,subf,andc,mulhw,neg,nor,subfe,adde,subfze,addze,subfme,
                      mulld,mullw,add,eqv,xor,orc,or,divwu,nand,divw,srw,sraw,srawi,extsh,extsb]).

unit(Insn, 'LSU') :-
        functor(Insn, Name, _),
        member(Name, [lwarx,ldx,lwzx,ldux,dcbst,lwzux,ldarx,dcbf,lbzx,lbzux,stdx,stwcx,stwx,stdux,
                      stwux,stdcx,stbx,dcbtst,stbux,dcbt,lhzx,tlbie,eciwx,lhzux,lwax,lhax,tlbia,
                      lwaux,lhaux,sthx,slbie,ecowx,sthux,dcbi,lswx,lwbrx,lfsx,srdx,tlbsync,lfsux,
                      lswi,lfdx,lfdux,stswx,stwbrx,stfsx,stfsux,stswi,stfdx,stfdux,lhbrx,sthbrx,tlbld,
                      icbi,stfiwx,tlblid,dcbz,lwz,lwzu,lbz,lbzu,stw,stwu,stb,stbu,lhz,lhzu,lha,lhau,
                      sth,sthu,lmw,stmw,lfs,lfsu,lfd,lfdu,stfs,stfsu,stfd,stfdu,ld,ldu,lwa]).

unit(Insn, 'SRU') :-
        functor(Insn, Name, _),
        member(Name, [sc,mcrf,crnor,rfi,crandc,isync,crxor,crnand,crand,creqv,crorc,cror,mfcr,mfmsr,
                      mtcrf,mtmsr,mtsr,mtsrin,mfspr,mftb,mtspr,mcrxr,mfsr,sync,mfsrin,eieio]).
