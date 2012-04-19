/* -*-mode:c++-*- *********************************************************
 *                                                                        *
 *  Algorithmic C (tm) Datatypes                                          *
 *                                                                        *
 *  Software Version: 1.2                                                 *
 *                                                                        *
 *  Release Date    : Wed May 23 20:21:26 PDT 2007                        *
 *  Release Type    : Production                                          *
 *  Release Build   : 1.2.0                                               *
 *                                                                        *
 *  Copyright 1996-2007, Mentor Graphics Corporation,                     *
 *                                                                        *
 *  All Rights Reserved.                                                  *
 *                                                                        *
 **************************************************************************
 *                                                                        *
 *  The most recent version of this package can be downloaded from:       *
 *     http://www.mentor.com/products/c-based_design/ac_datatypes         *
 *                                                                        *
 **************************************************************************
 *                                                                        *
 *  IMPORTANT - THIS SOFTWARE IS COPYRIGHTED AND SUBJECT TO LICENSE       *
 *  RESTRICTIONS                                                          *
 *                                                                        *
 *  THE LICENSE THAT CONTROLS YOUR USE OF THE SOFTWARE IS:                *
 *     ALGORITHMIC C DATATYPES END-USER LICENSE AGREEMENT                 *
 *                                                                        *
 *  THESE COMMENTS ARE NOT THE LICENSE.  PLEASE CONSULT THE FULL LICENSE  *
 *  FOR THE ACTUAL TERMS AND CONDITIONS WHICH IS LOCATED AT THE BOTTOM    *
 *  OF THIS FILE.                                                         *
 *                                                                        *  
 *  CAREFULLY READ THE LICENSE AGREEMENT BEFORE USING THE SOFTWARE.       *
 *                                                                        *  
 *       *** MODIFICATION OF THE SOFTWARE IS NOT AUTHORIZED ***           *
 *                                                                        *
 **************************************************************************
 *                                                                        *
 *  YOUR USE OF THE SOFTWARE INDICATES YOUR COMPLETE AND UNCONDITIONAL    *
 *  ACCEPTANCE OF THE TERMS AND CONDITIONS SET FORTH IN THE LICENSE. IF   *
 *  YOU DO NOT  AGREE TO THE LICENSE TERMS AND CONDITIONS, DO NOT USE THE *
 *  SOFTWARE, REMOVE IT FROM YOUR SYSTEM, AND DESTROY ALL COPIES.         *
 *                                                                        *
 *************************************************************************/

/*
//  Source:         ac_int.h
//  Description:    fast arbitrary-length bit-accurate integral types:
//                    - unsigned integer of length W:  ac_int<W,false>
//                    - signed integer of length W:  ac_int<W,true>
//  Author:         Andres Takach, Ph.D.
//  Notes: 
//   - C++ Runtime: important to use optimization flag (for example -O3) 
//
//   - Compiler support: recent GNU compilers are required for correct 
//     template compilation
//
//   - Most frequent migration issues:
//      - need to cast to common type when using question mark operator:
//          (a < 0) ? -a : a;  // a is ac_int<W,true>
//        change to:
//          (a < 0) ? -a : (ac_int<W+1,true>) a;   
//        or
//          (a < 0) ? (ac_int<W+1,false>) -a : (ac_int<W+1,false>) a;   
//
//      - left shift is not arithmetic ("a<<n" has same bitwidth as "a")
//          ac_int<W+1,false> b = a << 1;  // a is ac_int<W,false>  
//        is not equivalent to b=2*a. In order to get 2*a behavior change to: 
//          ac_int<W+1,false> b = (ac_int<W+1,false>)a << 1; 
//
//      - only static length read/write slices are supported:
//         - read:  x.slc<4>(k) => returns ac_int for 4-bit slice x(4+k-1 DOWNTO k) 
//         - write: x.set_slc(k,y) = writes bits of y to x starting at index k    
*/

#ifndef __AC_INT_H
#define __AC_INT_H

#define AC_VERSION 1
#define AC_VERSION_MINOR 2

#ifndef __cplusplus
#error C++ is required to include this header file
#endif

#if (defined(__GNUC__) && __GNUC__ < 3 && !defined(__EDG__))
#error GCC version 3 or greater is required to include this header file
#endif

#if (defined(_MSC_VER) && _MSC_VER < 1400 && !defined(__EDG__))
#error Microsoft Visual Studio 8 or newer is required to include this header file
#endif

#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( push )
#pragma warning( disable: 4127 4100 4244 4307 4554 )
#endif

// for safety
#if (defined(N) || defined(N2))
#error One or more of the following is defined: N, N2. Definition conflicts with their usage as template parameters. 
#endif

// for safety
#if (defined(W) || defined(I) || defined(S) || defined(W2) || defined(I2) || defined(S2))
#error One or more of the following is defined: W, I, S, W2, I2, S2. Definition conflicts with their usage as template parameters. 
#endif

#ifndef __SYNTHESIS__
#include <assert.h>
#include <iostream>
#include <math.h>
#include <string>

#ifndef __AC_INT_UTILITY_BASE
#define __AC_INT_UTILITY_BASE
#endif

#endif

#ifdef __AC_NAMESPACE
namespace __AC_NAMESPACE {
#endif

#define AC_MAX(a,b) ((a) > (b) ? (a) : (b))
#define AC_MIN(a,b) ((a) < (b) ? (a) : (b))

#if defined(_MSC_VER)
#if !defined(__EDG__) && _MSC_VER < 1400 && !defined(for)
# define for if(0);else for
#endif
typedef unsigned __int64 Ulong;
typedef signed   __int64 Slong;
#else
typedef unsigned long long Ulong;
typedef signed   long long Slong;
#endif

enum ac_base_mode { AC_BIN=2, AC_OCT=8, AC_DEC=10, AC_HEX=16 };
enum ac_special_val {AC_VAL_DC, AC_VAL_0, AC_VAL_MIN, AC_VAL_MAX, AC_VAL_QUANTUM};

#define AC_ASSERT(cond, msg) ac_private::ac_assert(cond, __FILE__, __LINE__, msg) 
namespace ac_private {
#if defined(__SYNTHESIS__) && !defined(AC_IGNORE_BUILTINS)
#pragma builtin
#endif

// PRIVATE FUNCTIONS in namespace: for implementing ac_int/ac_fixed

#ifndef __SYNTHESIS__
inline double mgc_floor(double d) { return floor(d); }
#else
inline double mgc_floor(double d) { return 0.0; }
#endif

  inline void ac_assert(bool condition, const char *file=0, int line=0, const char *msg=0) {
  #ifndef __SYNTHESIS__
    if(!condition) {
      std::cerr << "Assert";
      if(file) 
        std::cerr << " in file " << file << ":" << line;
      if(msg)
        std::cerr << " " << msg;
      std::cerr << std::endl;
      assert(0);
    }
  #endif
  }

  template<int N>
  inline double ldexpr32(double d) {
    double d2 = d;
    if(N < 0) 
      for(int i=0; i < -N; i++)
        d2 /= (Ulong) 1 << 32;
    else
      for(int i=0; i < N; i++)
        d2 *= (Ulong) 1 << 32;  
    return d2;
  }
  template<> inline double ldexpr32<0>(double d) { return d; }
  template<> inline double ldexpr32<1>(double d) { return d * ((Ulong) 1 << 32); }
  template<> inline double ldexpr32<-1>(double d) { return d / ((Ulong) 1 << 32); }
  template<> inline double ldexpr32<2>(double d) { return (d * ((Ulong) 1 << 32)) * ((Ulong) 1 << 32); }
  template<> inline double ldexpr32<-2>(double d) { return (d / ((Ulong) 1 << 32)) / ((Ulong) 1 << 32); }

  template<int N>
  inline double ldexpr(double d) {
    return ldexpr32<N/32>( N < 0 ? d/( (unsigned) 1 << (-N & 31)) : d * ( (unsigned) 1 << (N & 31)));
  }

  template<int N>
  inline void iv_copy(const int *op, int *r) {
    for(int i=0; i < N; i++)
      r[i] = op[i];
  }
  template<> inline void iv_copy<1>(const int *op, int *r) {
    r[0] = op[0];
  }
  template<> inline void iv_copy<2>(const int *op, int *r) {
    r[0] = op[0];
    r[1] = op[1];
  }
  
  template<int N>
  inline bool iv_equal_zero(const int *op){
    for(int i=0; i < N; i++)
      if(op[i])
        return false;
    return true;
  }
  template<> inline bool iv_equal_zero<0>(const int *op) { return true; }
  template<> inline bool iv_equal_zero<1>(const int *op) {
    return !op[0];
  }
  template<> inline bool iv_equal_zero<2>(const int *op) {
    return !(op[0] || op[1]);
  }
  
  template<int N>
  inline bool iv_equal_ones(const int *op){
    for(int i=0; i < N; i++)
      if(~op[i])
        return false;
    return true;
  }
  template<> inline bool iv_equal_ones<0>(const int *op) { return true; }
  template<> inline bool iv_equal_ones<1>(const int *op) {
    return !~op[0];
  }
  template<> inline bool iv_equal_ones<2>(const int *op) {
    return !(~op[0] || ~op[1]);
  }
  
  template<int N1, int N2>
  inline bool iv_equal(const int *op1, const int *op2){
    const int M1 = AC_MAX(N1,N2);
    const int M2 = AC_MIN(N1,N2);
    const int *OP1 = N1 >= N2 ? op1 : op2;
    const int *OP2 = N1 >= N2 ? op2 : op1;
    for(int i=0; i < M2; i++)
      if(OP1[i] != OP2[i])
        return false;
    int ext = OP2[M2-1] < 0 ? ~0 : 0;
    for(int i=M2; i < M1; i++)
      if(OP1[i] != ext)
        return false;
    return true;
  }
  template<> inline bool iv_equal<1,1>(const int *op1, const int *op2) {
    return op1[0] == op2[0];
  }

  template<int B, int N>
  inline bool iv_equal_ones_from(const int *op){
    if(B >= 32*N && op[N-1] >= 0 || (B&31 && ~(op[B/32] >> (B&31))))
      return false; 
    return iv_equal_ones<N-1-B/32>(&op[1+B/32]);
  }
  template<> inline bool  iv_equal_ones_from<0,1>(const int *op){
    return iv_equal_ones<1>(op);
  }
  template<> inline bool  iv_equal_ones_from<0,2>(const int *op){
    return iv_equal_ones<2>(op);
  }

  template<int B, int N>
  inline bool iv_equal_zeros_from(const int *op){
    if(B >= 32*N && op[N-1] < 0 || (B&31 && (op[B/32] >> (B&31))))
      return false; 
    return iv_equal_zero<N-1-B/32>(&op[1+B/32]);
  }
  template<> inline bool  iv_equal_zeros_from<0,1>(const int *op){
    return iv_equal_zero<1>(op);
  }
  template<> inline bool  iv_equal_zeros_from<0,2>(const int *op){
    return iv_equal_zero<2>(op);
  }

  template<int B, int N>
  inline bool iv_equal_ones_to(const int *op){
    if(B >= 32*N && op[N-1] >= 0 || (B&31 && ~(op[B/32] | (~0 << (B&31)))))
      return false; 
    return iv_equal_ones<B/32>(op);
  }
  template<> inline bool  iv_equal_ones_to<0,1>(const int *op){
    return iv_equal_ones<1>(op);
  }
  template<> inline bool  iv_equal_ones_to<0,2>(const int *op){
    return iv_equal_ones<2>(op);
  }

  template<int B, int N>
  inline bool iv_equal_zeros_to(const int *op){
    if(B >= 32*N && op[N-1] < 0 || (B&31 && (op[B/32] & ~(~0 << (B&31)))))
      return false; 
    return iv_equal_zero<B/32>(op);
  }
  template<> inline bool  iv_equal_zeros_to<0,1>(const int *op){
    return iv_equal_zero<1>(op);
  }
  template<> inline bool  iv_equal_zeros_to<0,2>(const int *op){
    return iv_equal_zero<2>(op);
  }
  
  template<int N1, int N2, bool greater>
  inline bool iv_compare(const int *op1, const int *op2){
    const int M1 = AC_MAX(N1,N2);
    const int M2 = AC_MIN(N1,N2);
    const int *OP1 = N1 >= N2 ? op1 : op2;
    const int *OP2 = N1 >= N2 ? op2 : op1;
    const bool b = (N1 >= N2) == greater;
    int ext = OP2[M2-1] < 0 ? ~0 : 0;
    int i2 = M1 > M2 ? ext : OP2[M1-1];
    if(OP1[M1-1] != i2) 
      return b ^ (OP1[M1-1] < i2); 
    for(int i=M1-2; i >= M2; i--) {
      if((unsigned) OP1[i] != (unsigned) ext)
        return b ^ ((unsigned) OP1[i] < (unsigned) ext); 
    }
    for(int i=M2-1; i >= 0; i--) {
      if((unsigned) OP1[i] != (unsigned) OP2[i])
        return b ^ ((unsigned) OP1[i] < (unsigned) OP2[i]); 
    }
    return false;
  }
  template<> inline bool iv_compare<1,1,true>(const int *op1, const int *op2) {
    return op1[0] > op2[0];
  }
  template<> inline bool iv_compare<1,1,false>(const int *op1, const int *op2) {
    return op1[0] < op2[0];
  }
  
  template<int N>
  inline void iv_extend(int *r, int ext) {
    for(int i=0; i < N; i++)
      r[i] = ext;
  } 
  template<> inline void iv_extend<-2>(int *r, int ext) {}
  template<> inline void iv_extend<-1>(int *r, int ext) {}
  template<> inline void iv_extend<0>(int *r, int ext) {}
  template<> inline void iv_extend<1>(int *r, int ext) {
    r[0] = ext;
  } 
  template<> inline void iv_extend<2>(int *r, int ext) {
    r[0] = ext;
    r[1] = ext;
  } 
  
  template<int Nr>
  inline void iv_assign_int64(int *r, Slong l) {
    r[0] = (int) l;
    if(Nr > 1) {
      r[1] = (int) (l >> 32);
      iv_extend<Nr-2>(r+2, (r[1] < 0) ? ~0 : 0);
    }
  } 
  template<> inline void iv_assign_int64<1>(int *r, Slong l) {
    r[0] = (int) l;
  }
  template<> inline void iv_assign_int64<2>(int *r, Slong l) {
    r[0] = (int) l;
    r[1] = (int) (l >> 32);
  }

  template<int Nr>
  inline void iv_assign_uint64(int *r, Ulong l) {
    r[0] = (int) l;
    if(Nr > 1) {
      r[1] = (int) (l >> 32);
      iv_extend<Nr-2>(r+2, 0);
    }
  } 
  template<> inline void iv_assign_uint64<1>(int *r, Ulong l) {
    r[0] = (int) l;
  }
  template<> inline void iv_assign_uint64<2>(int *r, Ulong l) {
    r[0] = (int) l;
    r[1] = (int) (l >> 32);
  }
  
  inline Ulong mult_u_u(int a, int b) {
    return (Ulong) (unsigned) a * (Ulong) (unsigned) b;
  }
  inline Slong mult_u_s(int a, int b) {
    return (Ulong) (unsigned) a * (Slong) (signed) b;
  }
  inline Slong mult_s_u(int a, int b) {
    return (Slong) (signed) a * (Ulong) (unsigned) b;
  }
  inline Slong mult_s_s(int a, int b) {
    return (Slong) (signed) a * (Slong) (signed) b;
  }
  inline void accumulate(Ulong a, Ulong &l1, Slong &l2) {
    l1 += (Ulong) (unsigned) a; 
    l2 += a >> 32;
  }
  inline void accumulate(Slong a, Ulong &l1, Slong &l2) {
    l1 += (Ulong) (unsigned) a; 
    l2 += a >> 32;
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_mult(const int *op1, const int *op2, int *r) {
    if(Nr==1)
      r[0] = op1[0] * op2[0];
    else if(N1==1 && N2==1)
      iv_assign_int64<Nr>(r, ((Slong) op1[0]) * ((Slong) op2[0]));
    else { 
      const int M1 = AC_MAX(N1,N2);
      const int M2 = AC_MIN(N1,N2);
      const int *OP1 = N1 >= N2 ? op1 : op2;
      const int *OP2 = N1 >= N2 ? op2 : op1;
      const int T1 = AC_MIN(M2-1,Nr);
      const int T2 = AC_MIN(M1-1,Nr);
      const int T3 = AC_MIN(M1+M2-2,Nr);
  
      Ulong l1 = 0;
      Slong l2 = 0;
      for(int k=0; k < T1; k++) {
        for(int i=0; i < k+1; i++)
          accumulate(mult_u_u(OP1[k-i], OP2[i]), l1, l2);
        l2 += (Ulong) (unsigned) (l1 >> 32);
        r[k] = (int) l1; 
        l1 = (unsigned) l2;
        l2 >>= 32;
      }
      for(int k=T1; k < T2; k++) {
        accumulate(mult_u_s(OP1[k-M2+1], OP2[M2-1]), l1, l2);
        for(int i=0; i < M2-1; i++)
          accumulate(mult_u_u(OP1[k-i], OP2[i]), l1, l2);
        l2 += (Ulong) (unsigned) (l1 >> 32);
        r[k] = (int) l1; 
        l1 = (unsigned) l2;
        l2 >>= 32;
      }
      for(int k=T2; k < T3; k++) {
        accumulate(mult_u_s(OP1[k-M2+1], OP2[M2-1]), l1, l2);
        for(int i=k-T2+1; i < M2-1; i++)
          accumulate(mult_u_u(OP1[k-i], OP2[i]), l1, l2);
        accumulate(mult_s_u(OP1[M1-1], OP2[k-M1+1]), l1, l2);
        l2 += (Ulong) (unsigned) (l1 >> 32);
        r[k] = (int) l1; 
        l1 = (unsigned) l2;
        l2 >>= 32;
      }
      if(Nr >= M1+M2-1) {
        accumulate(mult_s_s(OP1[M1-1], OP2[M2-1]), l1, l2);
        r[M1+M2-2] = (int) l1; 
        if(Nr >= M1+M2) {
          l2 += (Ulong) (unsigned) (l1 >> 32);
          r[M1+M2-1] = (int) l2;
          iv_extend<Nr-(M1+M2)>(r+M1+M2, (r[M1+M2-1] < 0) ? ~0 : 0);
        }
      }
    }
  }
  template<> inline void iv_mult<1,1,1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] * op2[0];
  }
  template<> inline void iv_mult<1,1,2>(const int *op1, const int *op2, int *r) {
    iv_assign_int64<2>(r, ((Slong) op1[0]) * ((Slong) op2[0]));
  }

  template<int N>
  inline bool iv_uadd_carry(const int *op1, bool carry, int *r) {
    Slong l = carry;
    for(int i=0; i < N; i++) {
      l += (Ulong) (unsigned) op1[i];
      r[i] = (int) l;
      l >>= 32;
    }
    return l != 0;
  }
  template<> inline bool iv_uadd_carry<0>(const int *op1, bool carry, int *r) { return carry; }
  template<> inline bool iv_uadd_carry<1>(const int *op1, bool carry, int *r) {
    Ulong l = carry + (Ulong) (unsigned) op1[0];
    r[0] = (int) l;
    return (l >> 32) & 1;
  }
  
  template<int N>
  inline bool iv_add_int_carry(const int *op1, int op2, bool carry, int *r) {
    if(N==0)
      return carry;
    if(N==1) {
      Ulong l = carry + (Slong) op1[0] + (Slong) op2;
      r[0] = (int) l;
      return (l >> 32) & 1;
    }
    Slong l = carry + (Ulong) (unsigned) op1[0] + (Slong) op2;
    r[0] = (int) l;
    l >>= 32;
    for(int i=1; i < N-1; i++) {
      l += (Ulong) (unsigned) op1[i];
      r[i] = (int) l;
      l >>= 32;
    }
    l += (Slong) op1[N-1];
    r[N-1] = (int) l;
    return (l >> 32) & 1;
  }
  template<> inline bool iv_add_int_carry<0>(const int *op1, int op2, bool carry, int *r) { return carry; }
  template<> inline bool iv_add_int_carry<1>(const int *op1, int op2, bool carry, int *r) {
    Ulong l = carry + (Slong) op1[0] + (Slong) op2;
    r[0] = (int) l;
    return (l >> 32) & 1;
  }
  
  template<int N>
  inline bool iv_uadd_n(const int *op1, const int *op2, int *r) {
    Ulong l = 0;
    for(int i=0; i < N; i++) {
      l += (Ulong)(unsigned) op1[i] + (Ulong)(unsigned) op2[i]; 
      r[i] = (int) l;
      l >>= 32;
    }
    return l & 1;
  }
  template<> inline bool iv_uadd_n<0>(const int *op1, const int *op2, int *r) { return false; }
  template<> inline bool iv_uadd_n<1>(const int *op1, const int *op2, int *r) {
    Ulong l = (Ulong) (unsigned) op1[0] + (Ulong) (unsigned) op2[0];
    r[0] = (int) l; 
    return (l >> 32) & 1;
  }
  template<> inline bool iv_uadd_n<2>(const int *op1, const int *op2, int *r) {
    Ulong l = (Ulong) (unsigned) op1[0] + (Ulong) (unsigned) op2[0];
    r[0] = (int) l; 
    l >>= 32;
    l += (Ulong) (unsigned) op1[1] + (Ulong) (unsigned) op2[1];
    r[1] = (int) l;
    return (l >> 32) & 1;
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_add(const int *op1, const int *op2, int *r) {
    if(Nr==1)
      r[0] = op1[0] + op2[0];
    else {
      const int M1 = AC_MAX(N1,N2);
      const int M2 = AC_MIN(N1,N2);
      const int *OP1 = N1 >= N2 ? op1 : op2;
      const int *OP2 = N1 >= N2 ? op2 : op1;
      const int T1 = AC_MIN(M2-1,Nr);
      const int T2 = AC_MIN(M1,Nr);
  
      bool carry = iv_uadd_n<T1>(OP1, OP2, r);
      carry = iv_add_int_carry<T2-T1>(OP1+T1, OP2[T1], carry, r+T1);
      iv_extend<Nr-T2>(r+T2, carry ? ~0 : 0);
    }
  }
  template<> inline void iv_add<1,1,1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] + op2[0];
  }
  template<> inline void iv_add<1,1,2>(const int *op1, const int *op2, int *r) {
    iv_assign_int64<2>(r, (Slong) op1[0] + (Slong) op2[0]);
  }
  
  template<int N>
  inline bool iv_sub_int_borrow(const int *op1, int op2, bool borrow, int *r) {
    if(N==1) {
      Ulong l = (Slong) op1[0] - (Slong) op2 - borrow;
      r[0] = (int) l;
      return (l >> 32) & 1;
    }
    Slong l = (Ulong) (unsigned) op1[0] - (Slong) op2 - borrow;
    r[0] = (int) l;
    l >>= 32;
    for(int i=1; i < N-1; i++) {
      l += (Ulong) (unsigned) op1[i];
      r[i] = (int) l;
      l >>= 32;
    }
    l += (Slong) op1[N-1];
    r[N-1] = (int) l;
    return (l >> 32) & 1;
  }
  template<> inline bool iv_sub_int_borrow<0>(const int *op1, int op2, bool borrow, int *r) { return borrow; }
  template<> inline bool iv_sub_int_borrow<1>(const int *op1, int op2, bool borrow, int *r) {
    Ulong l = (Slong) op1[0] - (Slong) op2 - borrow;
    r[0] = (int) l;
    return (l >> 32) & 1;
  }
  
  template<int N>
  inline bool iv_sub_int_borrow(int op1, const int *op2, bool borrow, int *r) {
    if(N==1) {
      Ulong l = (Slong) op1 - (Slong) op2[0] - borrow;
      r[0] = (int) l;
      return (l >> 32) & 1;
    }
    Slong l = (Slong) op1 - (Ulong) (unsigned) op2[0] - borrow;
    r[0] = (int) l;
    l >>= 32;
    for(int i=1; i < N-1; i++) {
      l -= (Ulong) (unsigned) op2[i];
      r[i] = (int) l;
      l >>= 32;
    }
    l -= (Slong) op2[N-1];
    r[N-1] = (int) l;
    return (l >> 32) & 1;
  }
  template<> inline bool iv_sub_int_borrow<0>(int op1, const int *op2, bool borrow, int *r) { return borrow; }
  template<> inline bool iv_sub_int_borrow<1>(int op1, const int *op2, bool borrow, int *r) {
    Ulong l = (Slong) op1 - (Slong) op2[0] - borrow;
    r[0] = (int) l;
    return (l >> 32) & 1;
  }
  
  template<int N>
  inline bool iv_usub_n(const int *op1, const int *op2, int *r) {
    Slong l = 0;
    for(int i=0; i < N; i++) {
      l += (Ulong)(unsigned) op1[i] - (Ulong)(unsigned) op2[i]; 
      r[i] = (int) l;
      l >>= 32;
    }
    return l & 1;
  }
  template<> inline bool iv_usub_n<1>(const int *op1, const int *op2, int *r) {
    Ulong l = (Ulong) (unsigned) op1[0] - (Ulong) (unsigned) op2[0];
    r[0] = (int) l; 
    return (l >> 32) & 1;
  }
  template<> inline bool iv_usub_n<2>(const int *op1, const int *op2, int *r) {
    Slong l = (Ulong) (unsigned) op1[0] - (Ulong) (unsigned) op2[0];
    r[0] = (int) l; 
    l >>= 32;
    l += (Ulong) (unsigned) op1[1] - (Ulong) (unsigned) op2[1];
    r[1] = (int) l; 
    return (l >> 32) & 1;
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_sub(const int *op1, const int *op2, int *r) {
    if(Nr==1)
      r[0] = op1[0] - op2[0];
    else {
      const int M1 = AC_MAX(N1,N2);
      const int M2 = AC_MIN(N1,N2);
      const int T1 = AC_MIN(M2-1,Nr);
      const int T2 = AC_MIN(M1,Nr);
      bool borrow = iv_usub_n<T1>(op1, op2, r);
      if(N1 > N2)
        borrow = iv_sub_int_borrow<T2-T1>(op1+T1, op2[T1], borrow, r+T1);
      else
        borrow = iv_sub_int_borrow<T2-T1>(op1[T1], op2+T1, borrow, r+T1);
      iv_extend<Nr-T2>(r+T2, borrow ? ~0 : 0);
    }
  }
  template<> inline void iv_sub<1,1,1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] - op2[0];
  }
  template<> inline void iv_sub<1,1,2>(const int *op1, const int *op2, int *r) {
    iv_assign_int64<2>(r, (Slong) op1[0] - (Slong) op2[0]);
  }

  template<int N>
  inline bool iv_all_bits_same(const int *op, bool bit) {
    int t = bit ? ~0 : 0;
    for(int i=0; i < N; i++)
      if(op[i] != t)
        return false;
    return true;
  }
  template<> inline bool iv_all_bits_same<0>(const int *op, bool bit) { return true; }
  template<> inline bool iv_all_bits_same<1>(const int *op, bool bit) {
    return op[0] == (bit ? ~0 : 0); 
  }

  template<int N1, int N2, int Nr>
  inline void iv_div(const int *op1, const int *op2, int *r) {
    if(N1==1) {
      if(N2==1) {
        if(op1[0] == (1 << 31) && op2[0] == -1) {  // prevent exception most_neg/-1
          r[0] = 1 << 31;
          iv_extend<Nr-1>(r+1, 0);
        } else {
          r[0] = op1[0] / op2[0];
          iv_extend<Nr-1>(r+1, (r[0] < 0) ? ~0 : 0);
        }
      }
      else if(N2==2 || iv_all_bits_same<N2-2>(op2+2, op2[1] < 0))
        iv_assign_int64<Nr>(r, ((Slong) op1[0]) / (((Slong) op2[1]) << 32 | (unsigned) op2[0]) );
      else
        AC_ASSERT(0, "Divisor not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
    } 
    else if(N1==2 || iv_all_bits_same<N1-2>(op1+2, op1[1] < 0)) {
      if(N2==1) {
        if(op1[1] == (1 << 31) && !op1[0] && op2[0] == -1) {  // prevent exception most_neg/-1
          r[0] = 0;
          r[1] = 1 << 31;
          iv_extend<Nr-2>(r+2, 0);
        } else
          iv_assign_int64<Nr>(r, (((Slong) op1[1] << 32) | (unsigned) op1[0]) / ((Slong) op2[0]) );
      }
      else if(N2==2 || iv_all_bits_same<N2-2>(op2+2, op2[1] < 0)) {
        if(op1[1] == (1 << 31) && !op1[0] && op2[1] == -1 && op2[0] == -1) { // prevent exception most_neg/-1
          r[0] = 0;
          r[1] = 1 << 31;
          iv_extend<Nr-2>(r+2, 0);
        } else
          iv_assign_int64<Nr>(r, (((Slong) op1[1] << 32) | (unsigned) op1[0]) / (((Slong) op2[1] << 32) | (unsigned) op2[0]) );
      }
      else
        AC_ASSERT(0, "Divisor not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
    } 
    else
      AC_ASSERT(0, "Dividend not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_rem(const int *op1, const int *op2, int *r) {
    if(N1==1) {
      if(N2==1) {
        if(op2[0] == -1 || op2[0] == 1)   // prevent exception most_neg/-1
          iv_extend<Nr>(r, 0);
        else {
          r[0] = op1[0] % op2[0];
          iv_extend<Nr-1>(r+1, (r[0] < 0) ? ~0 : 0);
        }
      }
      else if(N2==2 || iv_all_bits_same<N2-2>(op2+2, op2[1] < 0))
        iv_assign_int64<Nr>(r, ((Slong) op1[0]) % (((Slong) op2[1]) << 32 | (unsigned) op2[0]) );
      else 
        AC_ASSERT(0, "Divisor not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
    } 
    else if(N1==2 || iv_all_bits_same<N1-2>(op1+2, op1[1] < 0)) {
      if(N2==1) {
        if(op2[0] == -1 || op2[0] == 1)  // prevent exception most_neg/-1
          iv_extend<Nr>(r, 0);
        else
          iv_assign_int64<Nr>(r, (((Slong) op1[1] << 32) | (unsigned) op1[0]) % ((Slong) op2[0]) );
      }
      else if(N2==2 || iv_all_bits_same<N2-2>(op2+2, op2[1] < 0)) {
        if(op2[1] == -1 && op2[0] == -1 || op2[0] == 1 && !op2[1])  // prevent exception most_neg/-1
          iv_extend<Nr>(r, 0);
        else
          iv_assign_int64<Nr>(r, (((Slong) op1[1] << 32) | (unsigned) op1[0]) % (((Slong) op2[1] << 32) | (unsigned) op2[0]) );
      }
      else
        AC_ASSERT(0, "Divisor not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
    } 
    else
      AC_ASSERT(0, "Dividend not representable in signed 64-bits, Division currently not implemented beyond 64-bit threshold");
  }
  
  template<int N>
  inline void iv_bitwise_complement_n(const int *op, int *r) {
    for(int i=0; i < N; i++)
      r[i] = ~op[i];
  }
  template<> inline void iv_bitwise_complement_n<1>(const int *op, int *r) {
    r[0] = ~op[0];
  }
  template<> inline void iv_bitwise_complement_n<2>(const int *op, int *r) {
    r[0] = ~op[0];
    r[1] = ~op[1];
  }
  
  template<int N, int Nr>
  inline void iv_bitwise_complement(const int *op, int *r) {
    const int M = AC_MIN(N,Nr);
    iv_bitwise_complement_n<M>(op, r);
    iv_extend<Nr-M>(r+M, (r[M-1] < 0) ? ~0 : 0);
  }
  
  template<int N>
  inline void iv_bitwise_and_n(const int *op1, const int *op2, int *r) {
    for(int i=0; i < N; i++)
      r[i] = op1[i] & op2[i];
  }
  template<> inline void iv_bitwise_and_n<1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] & op2[0];
  }
  template<> inline void iv_bitwise_and_n<2>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] & op2[0];
    r[1] = op1[1] & op2[1];
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_bitwise_and(const int *op1, const int *op2, int *r) {
    const int M1 = AC_MIN(AC_MAX(N1,N2), Nr);
    const int M2 = AC_MIN(AC_MIN(N1,N2), Nr);
    const int *OP1 = N1 > N2 ? op1 : op2;
    const int *OP2 = N1 > N2 ? op2 : op1;
  
    iv_bitwise_and_n<M2>(op1, op2, r);
    if(OP2[M2-1] < 0)
      iv_copy<M1-M2>(OP1+M2, r+M2);
    else
      iv_extend<M1-M2>(r+M2, 0);
    iv_extend<Nr-M1>(r+M1, (r[M1-1] < 0) ? ~0 : 0);
  }
  
  template<int N>
  inline void iv_bitwise_or_n(const int *op1, const int *op2, int *r) {
    for(int i=0; i < N; i++)
      r[i] = op1[i] | op2[i];
  }
  template<> inline void iv_bitwise_or_n<1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] | op2[0];
  }
  template<> inline void iv_bitwise_or_n<2>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] | op2[0];
    r[1] = op1[1] | op2[1];
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_bitwise_or(const int *op1, const int *op2, int *r) {
    const int M1 = AC_MIN(AC_MAX(N1,N2), Nr);
    const int M2 = AC_MIN(AC_MIN(N1,N2), Nr);
    const int *OP1 = N1 >= N2 ? op1 : op2;
    const int *OP2 = N1 >= N2 ? op2 : op1;
  
    iv_bitwise_or_n<M2>(op1, op2, r);
    if(OP2[M2-1] < 0)
      iv_extend<M1-M2>(r+M2, ~0);
    else
      iv_copy<M1-M2>(OP1+M2, r+M2);
    iv_extend<Nr-M1>(r+M1, (r[M1-1] < 0) ? ~0 : 0);
  }
  
  template<int N>
  inline void iv_bitwise_xor_n(const int *op1, const int *op2, int *r) {
    for(int i=0; i < N; i++)
      r[i] = op1[i] ^ op2[i];
  }
  template<> inline void iv_bitwise_xor_n<1>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] ^ op2[0];
  }
  template<> inline void iv_bitwise_xor_n<2>(const int *op1, const int *op2, int *r) {
    r[0] = op1[0] ^ op2[0];
    r[1] = op1[1] ^ op2[1];
  }
  
  template<int N1, int N2, int Nr>
  inline void iv_bitwise_xor(const int *op1, const int *op2, int *r) {
    const int M1 = AC_MIN(AC_MAX(N1,N2), Nr);
    const int M2 = AC_MIN(AC_MIN(N1,N2), Nr);
    const int *OP1 = N1 >= N2 ? op1 : op2;
    const int *OP2 = N1 >= N2 ? op2 : op1;
  
    iv_bitwise_xor_n<M2>(op1, op2, r);
    if(OP2[M2-1] < 0)
      iv_bitwise_complement_n<M1-M2>(OP1+M2, r+M2);
    else
      iv_copy<M1-M2>(OP1+M2, r+M2);
    iv_extend<Nr-M1>(r+M1, (r[M1-1] < 0) ? ~0 : 0);
  }
  
  template<int N, int Nr>
  inline void iv_shift_l(const int *op1, unsigned op2, int *r) {
    AC_ASSERT(Nr <= N, "iv_shift_l, incorrect usage Nr > N");
    unsigned s31 = op2 & 31;
    unsigned ishift = (op2 >> 5) > Nr ? Nr : (op2 >> 5);
    if(s31 && ishift!=Nr) {
      unsigned lw = 0; 
      for(unsigned i=0; i < Nr; i++) {
        unsigned hw = (i >= ishift) ? op1[i-ishift] : 0;
        r[i] = (hw << s31) | (lw >> (32-s31));
        lw = hw;
      }
    } else {
      for(unsigned i=0; i < Nr ; i++)
        r[i] = (i >= ishift) ? op1[i-ishift] : 0;
    }
  }

  template<int N, int Nr>
  inline void iv_shift_r(const int *op1, unsigned op2, int *r) {
    unsigned s31 = op2 & 31;
    unsigned ishift = (op2 >> 5) > N ? N : (op2 >> 5);
    int ext = op1[N-1] < 0 ? ~0 : 0;
    if(s31 && ishift!=N) {
      unsigned lw = (ishift < N) ? op1[ishift] : ext;
      for(unsigned i=0; i < Nr; i++) {
        unsigned hw = (i+ishift+1 < N) ? op1[i+ishift+1] : ext; 
        r[i] = (lw >> s31) | (hw << (32-s31));
        lw = hw;
      }
    } else {
      for(unsigned i=0; i < Nr ; i++)
        r[i] = (i+ishift < N) ? op1[i+ishift] : ext;
    }
  }
  
  template<int N, int Nr, bool S>
  inline void iv_shift_l2(const int *op1, signed op2, int *r) {
    if(S && op2 < 0)
      iv_shift_r<N,Nr>(op1, -op2, r); 
    else 
      iv_shift_l<N,Nr>(op1, op2, r); 
  }

  template<> inline void iv_shift_l2<1,1,false>(const int *op1, signed op2, int *r) {
    r[0] = (op2 < 32) ? (op1[0] << op2) : 0;
  }
  template<> inline void iv_shift_l2<1,1,true>(const int *op1, signed op2, int *r) {
    r[0] = (op2 >= 0) ? 
      (op2 < 32) ? (op1[0] << op2) : 0 :
      (op2 > -32) ? (op1[0] >> -op2) : (op1[0] >> 31);
  }
  
  template<int N, int Nr, bool S>
  inline void iv_shift_r2(const int *op1, signed op2, int *r) {
    if(S && op2 < 0)
      iv_shift_l<N,Nr>(op1, -op2, r); 
    else 
      iv_shift_r<N,Nr>(op1, op2, r); 
  }

  template<> inline void iv_shift_r2<1,1,false>(const int *op1, signed op2, int *r) {
    r[0] = (op2 < 32) ? (op1[0] >> op2) : (op1[0] >> 31);
  }
  template<> inline void iv_shift_r2<1,1,true>(const int *op1, signed op2, int *r) {
    r[0] = (op2 >= 0) ? 
      (op2 < 32) ? (op1[0] >> op2) : (op1[0] >> 31) :
      (op2 > -32) ? (op1[0] << -op2) : 0;
  }

  template<int N, int Nr, int B>
  inline void iv_const_shift_l(const int *op1, int *r) {
    // B >= 0
    if(!B) {
      const int M1 = AC_MIN(N,Nr);
      iv_copy<M1>(op1, r);
      iv_extend<Nr-M1>(r+M1, r[M1-1] < 0 ? -1 : 0);
    }
    else {
      const unsigned s31 = B & 31;
      const unsigned ishift = (unsigned) (((B >> 5) > Nr) ? Nr : (B >> 5));
      if(s31) {
        for(unsigned i=0; i < AC_MIN(ishift,Nr); i++)
          r[i] = 0;
        unsigned lw = 0;
        const unsigned M1 = AC_MIN(N+ishift,Nr);
        for(unsigned i=ishift; i < M1; i++) {
          unsigned hw = op1[i-ishift];
          r[i] = (hw << s31) | (lw >> ((32-s31)&31));  // &31 is to quiet compilers
          lw = hw;
        }
        if(Nr > M1) {
          r[M1] = (signed) lw >> ((32-s31)&31);  // &31 is to quiet compilers 
          for(unsigned i=M1+1; i < Nr; i++)
            r[i] = r[M1] < 0 ? ~0 : 0; 
        }
      } else {
        for(unsigned i=0; i < Nr ; i++)
          r[i] = (i >= ishift) ? op1[i-ishift] : 0;
      }
    }
  }
  template<> inline void iv_const_shift_l<1,1,0>(const int *op1, int *r) {
    r[0] = op1[0];
  }
  template<> inline void iv_const_shift_l<2,1,0>(const int *op1, int *r) {
    r[0] = op1[0];
  }

  template<int N, int Nr, int B>
  inline void iv_const_shift_r(const int *op1, int *r) {
    if(!B) {
      const int M1 = AC_MIN(N,Nr);
      iv_copy<M1>(op1, r);
      iv_extend<Nr-M1>(r+M1, r[M1-1] < 0 ? -1 : 0);
    }
    else {
      const unsigned s31 = B & 31;
      const unsigned ishift = (unsigned) (((B >> 5) > N) ? N : (B >> 5));
      int ext = op1[N-1] < 0 ? ~0 : 0;
      if(s31 && ishift!=N) {
        unsigned lw = (ishift < N) ? op1[ishift] : ext;
        for(unsigned i=0; i < Nr; i++) {
          unsigned hw = (i+ishift+1 < N) ? op1[i+ishift+1] : ext;
          r[i] = (lw >> s31) | (hw << ((32-s31)&31));  // &31 is to quiet compilers
          lw = hw;
        }
      } else {
        for(unsigned i=0; i < Nr ; i++)
          r[i] = (i+ishift < N) ? op1[i+ishift] : ext;
      }
    }
  }
  template<> inline void iv_const_shift_r<1,1,0>(const int *op1, int *r) {
    r[0] = op1[0];
  }
  template<> inline void iv_const_shift_r<2,1,0>(const int *op1, int *r) {
    r[0] = op1[0];
  }

  template<int N>
  inline void iv_conv_from_fraction(double d, int *r, bool *qb, bool *rbits, bool *o) { 
    bool b = d < 0;
    double d2 = b ? -d : d;
    double dfloor = mgc_floor(d2);
    *o = dfloor != 0.0;
    d2 = d2 - dfloor;
    for(int i=N-1; i >=0; i--) {
      d2 *= (Ulong) 1 << 32;
      unsigned k = (unsigned int) d2;
      r[i] = b ? ~k : k;
      d2 -= k;
    }
    d2 *= 2;
    bool k = ((int) d2) != 0;  // is 0 or 1
    d2 -= k;
    *rbits = d2 != 0.0;
    *qb = (b && *rbits) ^ k;
    if(b && !*rbits && !*qb)
      iv_uadd_carry<N>(r, true, r);
    *o |= b ^ (r[N-1] < 0);
  }

  template<ac_base_mode b>
  inline int to_str(const int *v, int w, bool left_just, char *r) {
    const char digits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    const unsigned char B = b==AC_BIN ? 1 : (b==AC_OCT ? 3 : (b==AC_HEX ? 4 : 0)); 
    int k = (w+B-1)/B;
    int n = (w+31) >> 5;
    int bits = 0; 
    if(b != AC_BIN && left_just) {
      if( (bits = -(w % B)) )
        r[--k] = 0;
    }
    for(int i = 0; i < n; i++) {
      if (b != AC_BIN && bits < 0)
        r[k] += (unsigned char) ((v[i] << (B+bits)) & (b-1)); 
      unsigned int m = (unsigned) v[i] >> -bits;
      for(bits += 32; bits > 0 && k; bits -= B) {
        r[--k] = (char) (m & (b-1)); 
        m >>= B;
      }
    }
    for(int i=0; i < (w+B-1)/B; i++)
      r[i] = digits[(int)r[i]];
    return (w+B-1)/B;
  }
  template<> inline int to_str<AC_DEC>(const int *v, int w, bool left_just, char *r) { 
    int k = 0;
    Ulong l = (unsigned) v[0];
    if(w > 32)
      l |= (Ulong) v[1] << 32; 
    if(left_just) {
      AC_ASSERT(w <= 60, "Conversion to decimal affected by current limitation on division");
      l <<= 60-w;
      while(l) {
        l *= 10; 
        r[k++] = (char) ('0' + (int) (l >> 60));
        l &= (Ulong) ~(Ulong) 0 >> 4;
      }
    } else {
      AC_ASSERT(w <= 64, "Conversion to decimal affected by current limitation on division");
      while(l) {
        r[k++] = (char) ('0' + (int) (l % 10));
        l /= 10;
      }
      for(int i=0; i < k/2; i++) {
        char c = r[i];  
        r[i] = r[k-1-i];  
        r[k-1-i] = c;
      }
    }
    r[k] = 0;
    return k;
  }

  inline int to_string(const int *v, int w, bool sign_mag, ac_base_mode base, bool left_just, char *r) {
    int n = (w+31) >> 5;
    bool neg = !sign_mag && v[n-1] < 0; 
    if(!left_just) {
      while(n-- && v[n] == (neg ? ~0 : 0)) {}  
      w = 32*(n+1);
      if(w) {
        int m = v[n];
        for(int i = 16; i > 0; i >>= 1) {
          if((m >> i) == (neg ? ~0 : 0))
            w -= i;
          else
            m >>= i;
        }
      } 
      w += !sign_mag;
    }
    if(base == AC_DEC)
      return to_str<AC_DEC>(v, w, left_just, r);
    else if (base == AC_HEX)
      return to_str<AC_HEX>(v, w, left_just, r);
    else if (base == AC_OCT)
      return to_str<AC_OCT>(v, w, left_just, r);
    else if (base == AC_BIN)
      return to_str<AC_BIN>(v, w, left_just, r);
    return 0;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //  Integer Vector class: iv 
  //////////////////////////////////////////////////////////////////////////////
  template<int N>
  class iv {
  protected:
    int v[N];
  public:
    template<int N2> friend class iv;
    iv() {}
    template<int N2>
    iv ( const iv<N2> &b ) {
      const int M = AC_MIN(N,N2);
      iv_copy<M>(b.v, v);
      iv_extend<N-M>(v+M, (v[M-1] < 0) ? ~0 : 0);
    }
    iv ( Slong t) {
      iv_assign_int64<N>(v, t);
    }
    iv ( Ulong t) {
      iv_assign_uint64<N>(v, t);
    }
    iv ( int t) {
      v[0] = t;
      iv_extend<N-1>(v+1, (t < 0) ? ~0 : 0);
    }
    iv ( unsigned int t) {
      v[0] = t;
      iv_extend<N-1>(v+1, 0);
    }
    iv ( long t) {
      v[0] = t;
      iv_extend<N-1>(v+1, (t < 0) ? ~0 : 0);
    }
    iv ( unsigned long t) {
      v[0] = t;
      iv_extend<N-1>(v+1, 0);
    }
    iv ( double d ) {
      double d2 = ldexpr32<-N>(d);
      bool qb, rbits, o;
      iv_conv_from_fraction<N>(d2, v, &qb, &rbits, &o);
    }
  
    // Explicit conversion functions to C built-in types -------------
    inline Slong to_int64() const { return N==1 ? v[0] : ((Ulong)v[1] << 32) | (Ulong) (unsigned) v[0]; }
    inline Ulong to_uint64() const { return N==1 ? (Ulong) v[0] : ((Ulong)v[1] << 32) | (Ulong) (unsigned) v[0]; }
    inline double to_double() const {
      double a = v[N-1];
      for(int i=N-2; i >= 0; i--) { 
        a *= (Ulong) 1 << 32;
        a += (unsigned) v[i]; 
      } 
      return a;
    }
    inline void conv_from_fraction(double d, bool *qb, bool *rbits, bool *o) { 
      iv_conv_from_fraction<N>(d, v, qb, rbits, o);
    }
  
    template<int N2, int Nr>
    inline void mult(const iv<N2> &op2, iv<Nr> &r) const { 
      iv_mult<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void add(const iv<N2> &op2, iv<Nr> &r) const {
      iv_add<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void sub(const iv<N2> &op2, iv<Nr> &r) const {
      iv_sub<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void div(const iv<N2> &op2, iv<Nr> &r) const {
      iv_div<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void rem(const iv<N2> &op2, iv<Nr> &r) const {
      iv_rem<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int Nr>
    void shift_l(unsigned op2, iv<Nr> &r) const {
      iv_shift_l<N,Nr>(v, op2, r.v);
    }
    template<int Nr>
    void shift_l2(signed op2, iv<Nr> &r) const {
      iv_shift_l2<N,Nr,true>(v, op2, r.v);
    }
    template<int Nr>
    void shift_r(unsigned op2, iv<Nr> &r) const {
      iv_shift_r<N,Nr>(v, op2, r.v);
    }
    template<int Nr>
    void shift_r2(signed op2, iv<Nr> &r) const {
      iv_shift_r2<N,Nr,true>(v, op2, r.v);
    }
    template<int Nr, int B>
    void const_shift_l(iv<Nr> &r) const {
      iv_const_shift_l<N,Nr,B>(v, r.v);
    }
    template<int Nr, int B>
    void const_shift_r(iv<Nr> &r) const {
      iv_const_shift_r<N,Nr,B>(v, r.v);
    }
    template<int Nr>
    void bitwise_complement(iv<Nr> &r) const {
      iv_bitwise_complement<N,Nr>(v, r.v);
    }
    template<int N2, int Nr>
    void bitwise_and(const iv<N2> &op2, iv<Nr> &r) const {
      iv_bitwise_and<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void bitwise_or(const iv<N2> &op2, iv<Nr> &r) const {
      iv_bitwise_or<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2, int Nr>
    void bitwise_xor(const iv<N2> &op2, iv<Nr> &r) const {
      iv_bitwise_xor<N,N2,Nr>(v, op2.v, r.v);
    }
    template<int N2>
    bool equal(const iv<N2> &op2) const {
      return iv_equal<N,N2>(v, op2.v);
    } 
    template<int N2>
    bool greater_than(const iv<N2> &op2) const {
      return iv_compare<N,N2,true>(v, op2.v);
    }
    template<int N2>
    bool less_than(const iv<N2> &op2) const {
      return iv_compare<N,N2,false>(v, op2.v);
    }
    bool equal_zero() const {
      return iv_equal_zero<N>(v);
    }
    template<int N2>
    void set_slc(unsigned lsb, int WS, const iv<N2> &op2) {
      AC_ASSERT((31+WS)/32 == N2, "Bad usage: WS greater than length of slice"); 
      unsigned msb = lsb+WS-1;
      unsigned lsb_v = lsb >> 5;
      unsigned lsb_b = lsb & 31; 
      unsigned msb_v = msb >> 5;
      unsigned msb_b = msb & 31; 
      if(N2==1) { 
        if(msb_v == lsb_v) 
          v[lsb_v] ^= (v[lsb_v] ^ (op2.v[0] << lsb_b)) & (~(WS==32 ? 0 : ~0<<WS) << lsb_b);
        else {
          v[lsb_v] ^= (v[lsb_v] ^ (op2.v[0] << lsb_b)) & (~0 << lsb_b);
          unsigned m = (((unsigned) op2.v[0] >> 1) >> (31-lsb_b));
          v[msb_v] ^= (v[msb_v] ^ m) & ~((~0<<1)<<msb_b);
        }
      } else {
        v[lsb_v] ^= (v[lsb_v] ^ (op2.v[0] << lsb_b)) & (~0 << lsb_b);
        for(int i = 1; i < N2-1; i++)
          v[lsb_v+i] = (op2.v[i] << lsb_b) | (((unsigned) op2.v[i-1] >> 1) >> (31-lsb_b)); 
        unsigned t = (op2.v[N2-1] << lsb_b) | (((unsigned) op2.v[N2-2] >> 1) >> (31-lsb_b));
        unsigned m;
        if(msb_v-lsb_v == N2) {
          v[msb_v-1] = t; 
          m = (((unsigned) op2.v[N2-1] >> 1) >> (31-lsb_b));
        } 
        else
          m = t;
        v[msb_v] ^= (v[msb_v] ^ m) & ~((~0<<1)<<msb_b);
      }
    }
  };
  
  template<> inline iv<1>::iv(double d) { v[0] = (int) d; }
  template<> inline iv<2>::iv(double d) { 
    Slong l = (Slong) d; 
    v[0] = (int) l;  
    v[1] = (int) (l >> 32); 
  }
  template<> inline Slong iv<1>::to_int64() const { return v[0]; } 
  template<> inline Ulong iv<1>::to_uint64() const { return v[0]; }
  
  template<> inline Slong iv<2>::to_int64() const { 
    return ((Ulong)v[1] << 32) | (Ulong) (unsigned) v[0];
  }
  template<> inline Ulong iv<2>::to_uint64() const {
    return ((Ulong)v[1] << 32) | (Ulong) (unsigned) v[0];
  }
  
  template<> template<> inline void iv<1>::set_slc(unsigned lsb, int WS, const iv<1> &op2) {
    v[0] ^= (v[0] ^ (op2.v[0] << lsb)) & (~(WS==32 ? 0 : ~0<<WS) << lsb);
  }
  template<> template<> inline void iv<2>::set_slc(unsigned lsb, int WS, const iv<1> &op2) {
    Ulong l = to_uint64();
    Ulong l2 = op2.to_uint64();
    l ^= (l ^ (l2 << lsb)) & (~((~(Ulong)0)<<WS) << lsb);  // WS <= 32
    *this = l;
  }
  template<> template<> inline void iv<2>::set_slc(unsigned lsb, int WS, const iv<2> &op2) {
    Ulong l = to_uint64();
    Ulong l2 = op2.to_uint64();
    l ^= (l ^ (l2 << lsb)) & (~(WS==64 ? (Ulong) 0 : ~(Ulong)0<<WS) << lsb);
    *this = l;
  }

  // add automatic conversion to Slong/Ulong depending on S and C
  template<int N, bool S, bool C>
  class iv_conv : public iv<N> {
  protected:
    iv_conv() {}
    template<class T> iv_conv(const T& t) : iv<N>(t) {}
  };

  template<int N>
  class iv_conv<N,false,true> : public iv<N> {
  public:
    operator Ulong () const { return iv<N>::to_uint64(); }
  protected:
    iv_conv() {}
    template<class T> iv_conv(const T& t) : iv<N>(t) {}
  };

  template<int N>
  class iv_conv<N,true,true> : public iv<N> {
  public:
    operator Slong () const { return iv<N>::to_int64(); }
  protected:
    iv_conv() {}
    template<class T> iv_conv(const T& t) : iv<N>(t) {}
  };

} // namespace ac_private


enum ac_q_mode { AC_TRN, AC_RND, AC_TRN_ZERO, AC_RND_ZERO, AC_RND_INF, AC_RND_MIN_INF, AC_RND_CONV };
enum ac_o_mode { AC_WRAP, AC_SAT, AC_SAT_ZERO, AC_SAT_SYM };
template<int W2, int I2, bool S2, ac_q_mode Q2, ac_o_mode O2> class ac_fixed;

//////////////////////////////////////////////////////////////////////////////
//  Arbitrary-Length Integer: ac_int  
//////////////////////////////////////////////////////////////////////////////

template<int W, bool S=true>
class ac_int : public ac_private::iv_conv<(W+31+!S)/32, S, W<=64> 
#ifndef __SYNTHESIS__
__AC_INT_UTILITY_BASE 
#endif
{
#if defined(__SYNTHESIS__) && !defined(AC_IGNORE_BUILTINS)
#pragma builtin
#endif

  enum {N=(W+31+!S)/32};
  typedef ac_private::iv_conv<N, S, W <= 64> ConvBase;
  typedef ac_private::iv<N>                  Base;

  inline void bit_adjust() {
    const unsigned rem = (32-W)&31;
    Base::v[N-1] =  S ? ((Base::v[N-1]  << rem) >> rem) : (rem ? 
                  ((unsigned) Base::v[N-1]  << rem) >> rem : 0); 
  }

  inline bool is_neg() const { return S && Base::v[N-1] < 0; }

public:
  template<int W2, bool S2>
  struct rt {
    enum {
      mult_w = W+W2, 
      mult_s = S||S2,
      plus_w = AC_MAX(W+(S2&&!S),W2+(S&&!S2))+1,
      plus_s = S||S2,
      minus_w = AC_MAX(W+(S2&&!S),W2+(S&&!S2))+1,
      minus_s = true,
      div_w = W+S2,
      div_s = S||S2,
      mod_w = AC_MIN(W,W2+(!S2&&S)), 
      mod_s = S,
      logic_w = AC_MAX(W+(S2&&!S),W2+(S&&!S2)),
      logic_s = S||S2
    };
    typedef ac_int<mult_w, mult_s> mult;
    typedef ac_int<plus_w, plus_s> plus;
    typedef ac_int<minus_w, minus_s> minus;
    typedef ac_int<logic_w, logic_s> logic;
    typedef ac_int<div_w, div_s> div;
    typedef ac_int<mod_w, mod_s> mod;
    typedef ac_int<W, S> arg1;
  };

  template<int W2, bool S2> friend class ac_int;
  template<int W2, int I2, bool S2, ac_q_mode Q2, ac_o_mode O2> friend class ac_fixed;
  ac_int() {}
  template<int W2, bool S2>
  inline ac_int (const ac_int<W2,S2> &op) {
    Base::operator =(op);
    bit_adjust();
  }

  inline ac_int( bool b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( char b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( signed char b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( unsigned char b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( signed short b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( unsigned short b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( signed int b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( unsigned int b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( signed long b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( unsigned long b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( Slong b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( Ulong b ) : ConvBase(b) { bit_adjust(); }
  inline ac_int( double d ) : ConvBase(d) { bit_adjust(); }


#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( push )
#pragma warning( disable: 4700 )
#endif
  template<ac_special_val V>
  inline ac_int &set_val() {
    if(V == AC_VAL_DC) {
      int r;
      Base::operator =(r); 
      bit_adjust();
    }
    else if(V == AC_VAL_0 || V == AC_VAL_MIN || V == AC_VAL_QUANTUM) {
      Base::operator =(0); 
      if(S && V == AC_VAL_MIN) {
        const unsigned int rem = (W-1)&31;
        Base::v[N-1] = (-1 << rem); 
      } else if(V == AC_VAL_QUANTUM)
        Base::v[0] = 1;
    }
    else if(AC_VAL_MAX) {
      Base::operator =(-1); 
      const unsigned int rem = (32-W)&31;
      Base::v[N-1] = ((unsigned) (-1) >> (unsigned) S) >> rem; 
    }
    return *this;
  } 
#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( pop )
#endif

  // Explicit conversion functions to C built-in integral types -------------
  inline int to_int() const { return Base::v[0]; }
  inline unsigned to_uint() const { return Base::v[0]; }
  inline long to_long() const { return Base::v[0]; }
  inline unsigned long to_ulong() const { return Base::v[0]; }
  inline Slong to_int64() const { return Base::to_int64(); } 
  inline Ulong to_uint64() const { return Base::to_uint64(); } 
  inline double to_double() const { return Base::to_double(); } 

  inline int length() const { return W; }
  
#ifndef __SYNTHESIS__
  inline std::string to_string(ac_base_mode base_rep, bool sign_mag = false) const {
    // base_rep == AC_DEC => sign_mag == don't care (always print decimal in sign magnitude) 
    char r[N*32+4] = {0};
    int i = 0;
    if(sign_mag)
      r[i++] = is_neg() ? '-' : '+';
    else if (base_rep == AC_DEC && is_neg())
      r[i++] = '-'; 
    if(base_rep != AC_DEC) {
      r[i++] = '0';
      r[i++] = base_rep == AC_BIN ? 'b' : (base_rep == AC_OCT ? 'o' : 'x');
    }
    if( (base_rep == AC_DEC || sign_mag) && is_neg() ) {
      ac_int<W, false>  mag = operator -();
      i += ac_private::to_string(mag.v, W+1, sign_mag, base_rep, false, r+i); 
    } else
      i+= ac_private::to_string(Base::v, W+!S, sign_mag, base_rep, false, r+i); 
    if(!i) {
      r[0] = '0';
      r[1] = 0;
    }
    return std::string(r);
  }
#endif

  // Arithmetic : Binary ----------------------------------------------------
  template<int W2, bool S2>
  typename rt<W2,S2>::mult operator *( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::mult r;
    Base::mult(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::plus operator +( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::plus r;
    Base::add(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::minus operator -( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::minus r;
    Base::sub(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::div operator /( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::div r;
    Base::div(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::mod operator %( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::mod r;
    Base::rem(op2, r);
    return r;
  }
  // Arithmetic assign  ------------------------------------------------------
  template<int W2, bool S2>
  ac_int &operator *=( const ac_int<W2,S2> &op2) {
    Base r;
    Base::mult(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator +=( const ac_int<W2,S2> &op2) {
    Base r;
    Base::add(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator -=( const ac_int<W2,S2> &op2) {
    Base r;
    Base::sub(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator /=( const ac_int<W2,S2> &op2) {
    Base r;
    Base::div(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator %=( const ac_int<W2,S2> &op2) {
    Base r;
    Base::rem(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  // Arithmetic prefix increment, decrement ----------------------------------
  ac_int &operator ++() {
    operator+=((ac_int<1,false>) 1);
    return *this;
  }
  ac_int &operator --() {
    operator-=((ac_int<1,false>) 1);
    return *this;
  }
  // Arithmetic postfix increment, decrement ---------------------------------
  const ac_int operator ++(int) {
    ac_int t = *this;
    operator+=((ac_int<1,false>) 1);
    return t;
  }
  const ac_int operator --(int) {
    ac_int t = *this;
    operator-=((ac_int<1,false>) 1);
    return t;
  }
  // Arithmetic Unary --------------------------------------------------------
  ac_int operator +() {
    return *this;
  }
  ac_int<W+1,true> operator -() const {
    return ((ac_int<1,false>) 0) - *this;
  }
  // ! ------------------------------------------------------------------------
  bool operator ! () const {
    return Base::equal_zero(); 
  }

  // Bitwise (arithmetic) unary: complement  -----------------------------
  ac_int<W+!S, true> operator ~() const {
    ac_int<W+!S, true> r;
    Base::bitwise_complement(r);
    return r;
  }
  // Bitwise (arithmetic): and, or, xor ----------------------------------
  template<int W2, bool S2>
  typename rt<W2,S2>::logic operator & ( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::logic r;
    Base::bitwise_and(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::logic operator | ( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::logic r;
    Base::bitwise_or(op2, r);
    return r;
  }
  template<int W2, bool S2>
  typename rt<W2,S2>::logic operator ^ ( const ac_int<W2,S2> &op2) const {
    typename rt<W2,S2>::logic r;
    Base::bitwise_xor(op2, r);
    return r;
  }
  // Bitwise assign (not arithmetic): and, or, xor ----------------------------
  template<int W2, bool S2>
  ac_int &operator &= ( const ac_int<W2,S2> &op2 ) {
    Base r;
    Base::bitwise_and(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator |= ( const ac_int<W2,S2> &op2 ) {
    Base r;
    Base::bitwise_or(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2, bool S2>
  ac_int &operator ^= ( const ac_int<W2,S2> &op2 ) {
    Base r;
    Base::bitwise_xor(op2, r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  // Shift (result constrained by left operand) -------------------------------
  template<int W2>
  ac_int operator << ( const ac_int<W2,true> &op2 ) const {
    ac_int r;
    Base::shift_l2(op2.to_int(), r);
    r.bit_adjust();
    return r;
  }
  template<int W2>
  ac_int operator << ( const ac_int<W2,false> &op2 ) const {
    ac_int r;
    Base::shift_l(op2.to_uint(), r);
    r.bit_adjust();
    return r;
  }
  template<int W2>
  ac_int operator >> ( const ac_int<W2,true> &op2 ) const {
    ac_int r;
    Base::shift_r2(op2.to_int(), r);
    r.bit_adjust();
    return r;
  }
  template<int W2>
  ac_int operator >> ( const ac_int<W2,false> &op2 ) const {
    ac_int r;
    Base::shift_r(op2.to_uint(), r);
    r.bit_adjust();
    return r;
  }
  // Shift assign ------------------------------------------------------------
  template<int W2>
  ac_int &operator <<= ( const ac_int<W2,true> &op2 ) {
    Base r;
    Base::shift_l2(op2.to_int(), r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2>
  ac_int &operator <<= ( const ac_int<W2,false> &op2 ) {
    Base r;
    Base::shift_l(op2.to_uint(), r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2>
  ac_int &operator >>= ( const ac_int<W2,true> &op2 ) {
    Base r;
    Base::shift_r2(op2.to_int(), r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  template<int W2>
  ac_int &operator >>= ( const ac_int<W2,false> &op2 ) {
    Base r;
    Base::shift_r(op2.to_uint(), r);
    Base::operator=(r);
    bit_adjust();
    return *this;
  }
  // Relational ---------------------------------------------------------------
  template<int W2, bool S2>
  bool operator == ( const ac_int<W2,S2> &op2) const {
    return Base::equal(op2);
  }
  template<int W2, bool S2>
  bool operator != ( const ac_int<W2,S2> &op2) const {
    return !Base::equal(op2); 
  }
  template<int W2, bool S2>
  bool operator < ( const ac_int<W2,S2> &op2) const {
    return Base::less_than(op2);
  }
  template<int W2, bool S2>
  bool operator >= ( const ac_int<W2,S2> &op2) const {
    return !Base::less_than(op2); 
  }
  template<int W2, bool S2>
  bool operator > ( const ac_int<W2,S2> &op2) const {
    return Base::greater_than(op2);
  }
  template<int W2, bool S2>
  bool operator <= ( const ac_int<W2,S2> &op2) const {
    return !Base::greater_than(op2); 
  }

  // Bit and Slice Select -----------------------------------------------------
  template<int WS, int WX, bool SX>
  inline ac_int<WS,S> slc(const ac_int<WX,SX> &index) const {
    ac_int<WS,S> r;
    AC_ASSERT(index >= 0, "Attempting to read slc with negative indeces");
    ac_int<WX-SX, false> uindex = index;
    Base::shift_r(uindex.to_uint(), r);
    r.bit_adjust();
    return r; 
  }

  template<int WS>
  inline ac_int<WS,S> slc(signed index) const {
    ac_int<WS,S> r;
    AC_ASSERT(index >= 0, "Attempting to read slc with negative indeces");
    unsigned uindex = index & ((unsigned)~0 >> 1);
    Base::shift_r(uindex, r);
    r.bit_adjust();
    return r; 
  }
  template<int WS>
  inline ac_int<WS,S> slc(unsigned uindex) const {
    ac_int<WS,S> r;
    Base::shift_r(uindex, r);
    r.bit_adjust();
    return r; 
  }

  template<int W2, bool S2, int WX, bool SX>
  inline ac_int &set_slc(const ac_int<WX,SX> lsb, const ac_int<W2,S2> &slc) {
    AC_ASSERT(lsb.to_int() + W2 <= W && lsb.to_int() >= 0, "Out of bounds set_slc");
    ac_int<WX-SX, false> ulsb = lsb;
    Base::set_slc(ulsb.to_uint(), W2, (ac_int<W2,true>) slc);
    bit_adjust();   // in case sign bit was assigned 
    return *this;
  }
  template<int W2, bool S2>
  inline ac_int &set_slc(signed lsb, const ac_int<W2,S2> &slc) {
    AC_ASSERT(lsb + W2 <= W && lsb >= 0, "Out of bounds set_slc");
    unsigned ulsb = lsb & ((unsigned)~0 >> 1);
    Base::set_slc(ulsb, W2, (ac_int<W2,true>) slc);
    bit_adjust();   // in case sign bit was assigned 
    return *this;
  }
  template<int W2, bool S2>
  inline ac_int &set_slc(unsigned ulsb, const ac_int<W2,S2> &slc) {
    AC_ASSERT(ulsb + W2 <= W, "Out of bounds set_slc");
    Base::set_slc(ulsb, W2, (ac_int<W2,true>) slc);
    bit_adjust();   // in case sign bit was assigned 
    return *this;
  }

  class ac_bitref {
# if defined(__SYNTHESIS__) && !defined(AC_IGNORE_BUILTINS)
# pragma builtin
# endif
    ac_int &d_bv;
    unsigned d_index;
  public:
    ac_bitref( ac_int *bv, unsigned index=0 ) : d_bv(*bv), d_index(index) {}
    operator bool () const { return (d_index < W) ? (d_bv.v[d_index>>5]>>(d_index&31) & 1) : 0; }

    template<int W2, bool S2>
    operator ac_int<W2,S2> () const { return operator bool (); }

    inline ac_bitref operator = ( int val ) {
      // lsb of int (val&1) is written to bit
      if(d_index < W) {
        int *pval = &d_bv.v[d_index>>5];
        *pval ^= (*pval ^ (val << (d_index&31) )) & 1 << (d_index&31);
        d_bv.bit_adjust();   // in case sign bit was assigned 
      }
      return *this;
    }
    template<int W2, bool S2>
    inline ac_bitref operator = ( const ac_int<W2,S2> &val ) {
      return operator =(val.to_int());
    }
    inline ac_bitref operator = ( const ac_bitref &val ) {
      return operator =((int) (bool) val);
    }
  };

  ac_bitref operator [] ( unsigned int uindex) {
    AC_ASSERT(uindex < W, "Attempting to read bit beyond MSB");
    ac_bitref bvh( this, uindex );
    return bvh;
  } 
  ac_bitref operator [] ( int index) {
    AC_ASSERT(index >= 0, "Attempting to read bit with negative index");
    AC_ASSERT(index < W, "Attempting to read bit beyond MSB");
    unsigned uindex = index & ((unsigned)~0 >> 1);
    ac_bitref bvh( this, uindex );
    return bvh;
  } 
  template<int W2, bool S2>
  ac_bitref operator [] ( const ac_int<W2,S2> &index) {
    AC_ASSERT(index >= 0, "Attempting to read bit with negative index");
    AC_ASSERT(index < W, "Attempting to read bit beyond MSB");
    ac_int<W2-S2,false> uindex = index;
    ac_bitref bvh( this, uindex.to_uint() );
    return bvh;
  } 
  bool operator [] ( unsigned int uindex) const {
    AC_ASSERT(uindex < W, "Attempting to read bit beyond MSB");
    return (uindex < W) ? (Base::v[uindex>>5]>>(uindex&31) & 1) : 0;
  } 
  bool operator [] ( int index) const {
    AC_ASSERT(index >= 0, "Attempting to read bit with negative index");
    AC_ASSERT(index < W, "Attempting to read bit beyond MSB");
    unsigned uindex = index & ((unsigned)~0 >> 1);
    return (uindex < W) ? (Base::v[uindex>>5]>>(uindex&31) & 1) : 0;
  }
  template<int W2, bool S2>
  bool operator [] ( const ac_int<W2,S2> &index) const {
    AC_ASSERT(index >= 0, "Attempting to read bit with negative index");
    AC_ASSERT(index < W, "Attempting to read bit beyond MSB");
    ac_int<W2-S2,false> uindex = index;
    return (uindex < W) ? (Base::v[uindex>>5]>>(uindex&31) & 1) : 0;
  }
};


// Specializations for constructors on integers that bypass bit adjusting
//  and are therefore more efficient
template<> inline ac_int<1,true>::ac_int( bool b ) { v[0] = b ? -1 : 0; }

template<> inline ac_int<1,false>::ac_int( bool b ) { v[0] = b; }
template<> inline ac_int<1,false>::ac_int( signed char b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( unsigned char b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( signed short b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( unsigned short b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( signed int b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( unsigned int b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( signed long b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( unsigned long b ) { v[0] = b&1; }
template<> inline ac_int<1,false>::ac_int( Ulong b ) { v[0] = (int) b&1; }
template<> inline ac_int<1,false>::ac_int( Slong b ) { v[0] = (int) b&1; }

template<> inline ac_int<8,true>::ac_int( bool b ) { v[0] = b; }
template<> inline ac_int<8,false>::ac_int( bool b ) { v[0] = b; }
template<> inline ac_int<8,true>::ac_int( signed char b ) { v[0] = b; }
template<> inline ac_int<8,false>::ac_int( unsigned char b ) { v[0] = b; }
template<> inline ac_int<8,true>::ac_int( unsigned char b ) { v[0] = (signed char) b; }
template<> inline ac_int<8,false>::ac_int( signed char b ) { v[0] = (unsigned char) b; }

template<> inline ac_int<16,true>::ac_int( bool b ) { v[0] = b; }
template<> inline ac_int<16,false>::ac_int( bool b ) { v[0] = b; }
template<> inline ac_int<16,true>::ac_int( signed char b ) { v[0] = b; }
template<> inline ac_int<16,false>::ac_int( unsigned char b ) { v[0] = b; }
template<> inline ac_int<16,true>::ac_int( unsigned char b ) { v[0] = b; }
template<> inline ac_int<16,false>::ac_int( signed char b ) { v[0] = (unsigned short) b; }
template<> inline ac_int<16,true>::ac_int( signed short b ) { v[0] = b; }
template<> inline ac_int<16,false>::ac_int( unsigned short b ) { v[0] = b; }
template<> inline ac_int<16,true>::ac_int( unsigned short b ) { v[0] = (signed short) b; }
template<> inline ac_int<16,false>::ac_int( signed short b ) { v[0] = (unsigned short) b; }

template<> inline ac_int<32,true>::ac_int( signed int b ) { v[0] = b; }
template<> inline ac_int<32,true>::ac_int( unsigned int b ) { v[0] = b; }
template<> inline ac_int<32,false>::ac_int( signed int b ) { v[0] = b; v[1] = 0;}
template<> inline ac_int<32,false>::ac_int( unsigned int b ) { v[0] = b; v[1] = 0;}

template<> inline ac_int<32,true>::ac_int( Slong b ) { v[0] = (int) b; }
template<> inline ac_int<32,true>::ac_int( Ulong b ) { v[0] = (int) b; }
template<> inline ac_int<32,false>::ac_int( Slong b ) { v[0] = (int) b; v[1] = 0;}
template<> inline ac_int<32,false>::ac_int( Ulong b ) { v[0] = (int) b; v[1] = 0;}

template<> inline ac_int<64,true>::ac_int( Slong b ) { v[0] = (int) b; v[1] = (int) (b >> 32); }
template<> inline ac_int<64,true>::ac_int( Ulong b ) { v[0] = (int) b; v[1] = (int) (b >> 32);}
template<> inline ac_int<64,false>::ac_int( Slong b ) { v[0] = (int) b; v[1] = (int) ((Ulong) b >> 32); v[2] = 0; }
template<> inline ac_int<64,false>::ac_int( Ulong b ) { v[0] = (int) b; v[1] = (int) (b >> 32); v[2] = 0; }

// Stream --------------------------------------------------------------------

#ifndef __SYNTHESIS__
template<int W, bool S>
inline std::ostream& operator << (std::ostream &os, const ac_int<W,S> &x) {
  // dec is supported for precisions representable in 64 bit signed 
  os << x.to_string(AC_DEC);
  return os;
}
#endif

// Binary Operators with Integers --------------------------------------------

#define BIN_OP_WITH_INT(BIN_OP, C_TYPE, WI, SI, RTYPE)  \
  template<int W, bool S> \
  inline typename ac_int<WI,SI>::template rt<W,S>::RTYPE operator BIN_OP ( C_TYPE i_op, const ac_int<W,S> &op) {  \
    return ac_int<WI,SI>(i_op).operator BIN_OP (op);  \
  } \
  template<int W, bool S>   \
  inline typename ac_int<W,S>::template rt<WI,SI>::RTYPE operator BIN_OP ( const ac_int<W,S> &op, C_TYPE i_op) {  \
    return op.operator BIN_OP (ac_int<WI,SI>(i_op));  \
  }

#define REL_OP_WITH_INT(REL_OP, C_TYPE, W2, S2)  \
  template<int W, bool S>   \
  inline bool operator REL_OP ( const ac_int<W,S> &op, C_TYPE op2) {  \
    return op.operator REL_OP (ac_int<W2,S2>(op2));  \
  }  \
  template<int W, bool S> \
  inline bool operator REL_OP ( C_TYPE op2, const ac_int<W,S> &op) {  \
    return ac_int<W2,S2>(op2).operator REL_OP (op);  \
  }

#define ASSIGN_OP_WITH_INT(ASSIGN_OP, C_TYPE, W2, S2)  \
  template<int W, bool S>   \
  inline ac_int<W,S> &operator ASSIGN_OP ( ac_int<W,S> &op, C_TYPE op2) {  \
    return op.operator ASSIGN_OP (ac_int<W2,S2>(op2));  \
  }

#define OPS_WITH_INT(C_TYPE, WI, SI) \
  BIN_OP_WITH_INT(*, C_TYPE, WI, SI, mult) \
  BIN_OP_WITH_INT(+, C_TYPE, WI, SI, plus) \
  BIN_OP_WITH_INT(-, C_TYPE, WI, SI, minus) \
  BIN_OP_WITH_INT(/, C_TYPE, WI, SI, div) \
  BIN_OP_WITH_INT(%, C_TYPE, WI, SI, mod) \
  BIN_OP_WITH_INT(>>, C_TYPE, WI, SI, arg1) \
  BIN_OP_WITH_INT(<<, C_TYPE, WI, SI, arg1) \
  BIN_OP_WITH_INT(&, C_TYPE, WI, SI, logic) \
  BIN_OP_WITH_INT(|, C_TYPE, WI, SI, logic) \
  BIN_OP_WITH_INT(^, C_TYPE, WI, SI, logic) \
  \
  REL_OP_WITH_INT(==, C_TYPE, WI, SI) \
  REL_OP_WITH_INT(!=, C_TYPE, WI, SI) \
  REL_OP_WITH_INT(>, C_TYPE, WI, SI) \
  REL_OP_WITH_INT(>=, C_TYPE, WI, SI) \
  REL_OP_WITH_INT(<, C_TYPE, WI, SI) \
  REL_OP_WITH_INT(<=, C_TYPE, WI, SI) \
  \
  ASSIGN_OP_WITH_INT(+=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(-=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(*=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(/=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(%=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(>>=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(<<=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(&=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(|=, C_TYPE, WI, SI) \
  ASSIGN_OP_WITH_INT(^=, C_TYPE, WI, SI)

OPS_WITH_INT(bool, 1, false)
OPS_WITH_INT(char, 8, true)
OPS_WITH_INT(signed char, 8, true)
OPS_WITH_INT(unsigned char, 8, false)
OPS_WITH_INT(short, 16, true)
OPS_WITH_INT(unsigned short, 16, false)
OPS_WITH_INT(int, 32, true)
OPS_WITH_INT(unsigned int, 32, false)
OPS_WITH_INT(long, 32, true)
OPS_WITH_INT(unsigned long, 32, false)
OPS_WITH_INT(Slong, 64, true)
OPS_WITH_INT(Ulong, 64, false)

// Addition of ac_int and  pointer
template<typename T, int W, bool S>
T *operator +(T *ptr, const ac_int<W,S> &op2) {
  return ptr + op2.to_int64(); 
}
template<typename T, int W, bool S>
T *operator +(const ac_int<W,S> &op2, T *ptr) {
  return ptr + op2.to_int64(); 
}
// Subtraction of ac_int from pointer
template<typename T, int W, bool S>
T *operator -(T *ptr, const ac_int<W,S> &op2) {
  return ptr - op2.to_int64(); 
}

namespace ac_intN {
  ///////////////////////////////////////////////////////////////////////////////
  //  Predefined for ease of use
  ///////////////////////////////////////////////////////////////////////////////
  typedef ac_int<1,          true>   int1;
  typedef ac_int<1,          false>  uint1;
  typedef ac_int<2,          true>   int2;
  typedef ac_int<2,          false>  uint2;
  typedef ac_int<3,          true>   int3;
  typedef ac_int<3,          false>  uint3;
  typedef ac_int<4,          true>   int4;
  typedef ac_int<4,          false>  uint4;
  typedef ac_int<5,          true>   int5;
  typedef ac_int<5,          false>  uint5;
  typedef ac_int<6,          true>   int6;
  typedef ac_int<6,          false>  uint6;
  typedef ac_int<7,          true>   int7;
  typedef ac_int<7,          false>  uint7;
  typedef ac_int<8,          true>   int8;
  typedef ac_int<8,          false>  uint8;
  typedef ac_int<9,          true>   int9;
  typedef ac_int<9,          false>  uint9;
  typedef ac_int<10,         true>   int10;
  typedef ac_int<10,         false>  uint10;
  typedef ac_int<11,         true>   int11;
  typedef ac_int<11,         false>  uint11;
  typedef ac_int<12,         true>   int12;
  typedef ac_int<12,         false>  uint12;
  typedef ac_int<13,         true>   int13;
  typedef ac_int<13,         false>  uint13;
  typedef ac_int<14,         true>   int14;
  typedef ac_int<14,         false>  uint14;
  typedef ac_int<15,         true>   int15;
  typedef ac_int<15,         false>  uint15;
  typedef ac_int<16,         true>   int16;
  typedef ac_int<16,         false>  uint16;
  typedef ac_int<17,         true>   int17;
  typedef ac_int<17,         false>  uint17;
  typedef ac_int<18,         true>   int18;
  typedef ac_int<18,         false>  uint18;
  typedef ac_int<19,         true>   int19;
  typedef ac_int<19,         false>  uint19;
  typedef ac_int<20,         true>   int20;
  typedef ac_int<20,         false>  uint20;
  typedef ac_int<21,         true>   int21;
  typedef ac_int<21,         false>  uint21;
  typedef ac_int<22,         true>   int22;
  typedef ac_int<22,         false>  uint22;
  typedef ac_int<23,         true>   int23;
  typedef ac_int<23,         false>  uint23;
  typedef ac_int<24,         true>   int24;
  typedef ac_int<24,         false>  uint24;
  typedef ac_int<25,         true>   int25;
  typedef ac_int<25,         false>  uint25;
  typedef ac_int<26,         true>   int26;
  typedef ac_int<26,         false>  uint26;
  typedef ac_int<27,         true>   int27;
  typedef ac_int<27,         false>  uint27;
  typedef ac_int<28,         true>   int28;
  typedef ac_int<28,         false>  uint28;
  typedef ac_int<29,         true>   int29;
  typedef ac_int<29,         false>  uint29;
  typedef ac_int<30,         true>   int30;
  typedef ac_int<30,         false>  uint30;
  typedef ac_int<31,         true>   int31;
  typedef ac_int<31,         false>  uint31;
  typedef ac_int<32,         true>   int32;
  typedef ac_int<32,         false>  uint32;
  typedef ac_int<33,         true>   int33;
  typedef ac_int<33,         false>  uint33;
  typedef ac_int<34,         true>   int34;
  typedef ac_int<34,         false>  uint34;
  typedef ac_int<35,         true>   int35;
  typedef ac_int<35,         false>  uint35;
  typedef ac_int<36,         true>   int36;
  typedef ac_int<36,         false>  uint36;
  typedef ac_int<37,         true>   int37;
  typedef ac_int<37,         false>  uint37;
  typedef ac_int<38,         true>   int38;
  typedef ac_int<38,         false>  uint38;
  typedef ac_int<39,         true>   int39;
  typedef ac_int<39,         false>  uint39;
  typedef ac_int<40,         true>   int40;
  typedef ac_int<40,         false>  uint40;
  typedef ac_int<41,         true>   int41;
  typedef ac_int<41,         false>  uint41;
  typedef ac_int<42,         true>   int42;
  typedef ac_int<42,         false>  uint42;
  typedef ac_int<43,         true>   int43;
  typedef ac_int<43,         false>  uint43;
  typedef ac_int<44,         true>   int44;
  typedef ac_int<44,         false>  uint44;
  typedef ac_int<45,         true>   int45;
  typedef ac_int<45,         false>  uint45;
  typedef ac_int<46,         true>   int46;
  typedef ac_int<46,         false>  uint46;
  typedef ac_int<47,         true>   int47;
  typedef ac_int<47,         false>  uint47;
  typedef ac_int<48,         true>   int48;
  typedef ac_int<48,         false>  uint48;
  typedef ac_int<49,         true>   int49;
  typedef ac_int<49,         false>  uint49;
  typedef ac_int<50,         true>   int50;
  typedef ac_int<50,         false>  uint50;
  typedef ac_int<51,         true>   int51;
  typedef ac_int<51,         false>  uint51;
  typedef ac_int<52,         true>   int52;
  typedef ac_int<52,         false>  uint52;
  typedef ac_int<53,         true>   int53;
  typedef ac_int<53,         false>  uint53;
  typedef ac_int<54,         true>   int54;
  typedef ac_int<54,         false>  uint54;
  typedef ac_int<55,         true>   int55;
  typedef ac_int<55,         false>  uint55;
  typedef ac_int<56,         true>   int56;
  typedef ac_int<56,         false>  uint56;
  typedef ac_int<57,         true>   int57;
  typedef ac_int<57,         false>  uint57;
  typedef ac_int<58,         true>   int58;
  typedef ac_int<58,         false>  uint58;
  typedef ac_int<59,         true>   int59;
  typedef ac_int<59,         false>  uint59;
  typedef ac_int<60,         true>   int60;
  typedef ac_int<60,         false>  uint60;
  typedef ac_int<61,         true>   int61;
  typedef ac_int<61,         false>  uint61;
  typedef ac_int<62,         true>   int62;
  typedef ac_int<62,         false>  uint62;
  typedef ac_int<63,         true>   int63;
  typedef ac_int<63,         false>  uint63;
}  // namespace ac_intN

#ifndef AC_NOT_USING_INTN
using namespace ac_intN;
#endif

///////////////////////////////////////////////////////////////////////////////

#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( disable: 4700 )
#endif

// Global templatized functions for easy initialization to special values
template<ac_special_val V, int W, bool S>
inline ac_int<W,S> value(ac_int<W,S>) {
  ac_int<W,S> r;
  return r.template set_val<V>();
}
// forward declaration, otherwise GCC errors when calling init_array
template<ac_special_val V, int W, int I, bool S, ac_q_mode Q, ac_o_mode O>
inline ac_fixed<W,I,S,Q,O> value(ac_fixed<W,I,S,Q,O>);

// -- C int types -----------------------------------------------------------------
#define SPECIAL_VAL_FOR_INTS(C_TYPE, WI, SI) \
template<ac_special_val val> inline C_TYPE value(C_TYPE); \
template<> inline C_TYPE value<AC_VAL_0>(C_TYPE) { return (C_TYPE)0; } \
template<> inline C_TYPE value<AC_VAL_DC>(C_TYPE) { C_TYPE x; return x; } \
template<> inline C_TYPE value<AC_VAL_QUANTUM>(C_TYPE) { return (C_TYPE)1; } \
template<> inline C_TYPE value<AC_VAL_MAX>(C_TYPE) { return (C_TYPE)(SI ? ~(((C_TYPE) -1) << (WI-1)) : (C_TYPE) -1); } \
template<> inline C_TYPE value<AC_VAL_MIN>(C_TYPE) { return (C_TYPE)(SI ? (C_TYPE) 1 << (WI-1) : 0); }
                                                                                           
SPECIAL_VAL_FOR_INTS(bool, 1, false)
SPECIAL_VAL_FOR_INTS(char, 8, true)
SPECIAL_VAL_FOR_INTS(signed char, 8, true)
SPECIAL_VAL_FOR_INTS(unsigned char, 8, false)
SPECIAL_VAL_FOR_INTS(short, 16, true)
SPECIAL_VAL_FOR_INTS(unsigned short, 16, false)
SPECIAL_VAL_FOR_INTS(int, 32, true)
SPECIAL_VAL_FOR_INTS(unsigned int, 32, false)
SPECIAL_VAL_FOR_INTS(long, 32, true)
SPECIAL_VAL_FOR_INTS(unsigned long, 32, false)
SPECIAL_VAL_FOR_INTS(Slong, 64, true)
SPECIAL_VAL_FOR_INTS(Ulong, 64, false)

#define INIT_ARRAY_SPECIAL_VAL_FOR_INTS(C_TYPE) \
  template<ac_special_val V> \
  inline bool init_array(C_TYPE *a, int n) { \
    C_TYPE t = value<V>(*a); \
    for(int i=0; i < n; i++) \
      a[i] = t; \
    return true; \
  }

namespace ac {
#if defined(__SYNTHESIS__) && !defined(AC_IGNORE_BUILTINS)
#pragma builtin
  static int place_holder_object_for_pragma; 
#endif
// PUBLIC FUNCTIONS 
// function to initialize (or uninitialize) arrays 
  template<ac_special_val V, int W, bool S>
  inline bool init_array(ac_int<W,S> *a, int n) {
    ac_int<W,S> t = value<V>(*a);
    for(int i=0; i < n; i++)
      a[i] = t;
    return true;
  }

  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(bool);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(char);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(signed char);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(unsigned char);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(signed short);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(unsigned short);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(signed int);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(unsigned int);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(signed long);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(unsigned long);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(signed long long);
  INIT_ARRAY_SPECIAL_VAL_FOR_INTS(unsigned long long);
}

#if (defined(_MSC_VER) && !defined(__EDG__))
#pragma warning( pop )
#endif

#ifdef __AC_NAMESPACE
}
#endif

#endif // __AC_INT_H

/**************************************************************************
 *                                                                        *
 *  ALGORITHMIC C DATATYPES END-USER LICENSE AGREEMENT                    *
 *                                                                        *
 *                                                                        *
 *  IMPORTANT - USE OF SOFTWARE IS SUBJECT TO LICENSE RESTRICTIONS        *
 *  CAREFULLY READ THIS LICENSE AGREEMENT BEFORE USING THE SOFTWARE       *
 *                                                                        *
 *  YOU MAY USE AND DISTRIBUTE UNMODIFIED VERSIONS OF THIS SOFTWARE AS    *
 *  STATED BELOW, YOU MAY NOT MODIFY THE SOFTWARE This license is a       *
 *  legal Agreement between you, the end user, either individually or     *
 *  as an authorized representative of a company acquiring the license,   *
 *  and Mentor Graphics Corporation ("Mentor Graphics"). YOUR USE OF      *
 *  THE SOFTWARE INDICATES YOUR COMPLETE AND UNCONDITIONAL ACCEPTANCE     *
 *  OF THE TERMS AND CONDITIONS SET FORTH IN THIS AGREEMENT. If you do    *
 *  not agree to these terms and conditions, promptly return or, if       *
 *  received electronically, delete the Software and all accompanying     *
 *  items.                                                                *
 *                                                                        *
 *                                                                        *
 *  1. GRANT OF LICENSE. YOU MAY USE AND DISTRIBUTE THE SOFTWARE, BUT     *
 *  YOU MAY NOT MODIFY THE SOFTWARE. The Software you are installing,     *
 *  downloading, or otherwise acquired, under this Agreement, including   *
 *  source code, binary code, updates, modifications, revisions,          *
 *  copies, or documentation pertaining to Algorithmic C Datatypes        *
 *  (collectively the "Software") is a copyrighted work owned by Mentor   *
 *  Graphics. Mentor Graphics grants to you, a nontransferable,           *
 *  nonexclusive, limited copyright license to use and distribute the     *
 *  Software, but you may not modify the Software. Use of the Software    *
 *  consists solely of reproduction, performance, and display.            *
 *                                                                        *
 *  2. RESTRICTIONS; NO MODIFICATION. Modifying the Software is           *
 *  prohibited. Each copy of the Software you create must include all     *
 *  notices and legends embedded in the Software.  Modifying the          *
 *  Software means altering, enhancing, editing, deleting portions or     *
 *  creating derivative works of the Software.  You may append other      *
 *  code to the Software, so long as the Software is not otherwise        *
 *  modified. Mentor Graphics retains all rights not expressly granted    *
 *  by this Agreement. The terms of this Agreement, including without     *
 *  limitation, the licensing and assignment provisions, shall be         *
 *  binding upon your successors in interest and assigns.  The            *
 *  provisions of this section 2 shall survive termination or             *
 *  expiration of this Agreement.                                         *
 *                                                                        *
 *  3. USER COMMENT AND SUGGESTIONS.  You are not obligated to provide    *
 *  Mentor Graphics with comments or suggestions regarding the            *
 *  Software.  However, if you do provide to Mentor Graphics comments     *
 *  or suggestions for the modification, correction, improvement or       *
 *  enhancement of (a) the Software or (b) Mentor Graphics products or    *
 *  processes which may embody the Software ("Comments"), you grant to    *
 *  Mentor a non-exclusive, irrevocable, worldwide, royalty-free          *
 *  license to disclose, display, perform, copy, make, have made, use,    *
 *  sublicense, sell, and otherwise dispose of the Comments, and Mentor   *
 *  Graphics' products embodying such Comments, in any manner which       *
 *  Mentor Graphics chooses, without reference to the source.             *
 *                                                                        *
 *  4. NO WARRANTY. MENTOR GRAPHICS EXPRESSLY DISCLAIMS ALL WARRANTY      *
 *  FOR THE SOFTWARE. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE       *
 *  LAW, THE SOFTWARE AND ANY RELATED DOCUMENTATION IS PROVIDED "AS IS"   *
 *  AND WITH ALL FAULTS AND WITHOUT WARRANTIES OR CONDITIONS OF ANY       *
 *  KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, THE   *
 *  IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR       *
 *  PURPOSE, OR NONINFRINGEMENT. THE ENTIRE RISK ARISING OUT OF USE OR    *
 *  DISTRIBUTION OF THE SOFTWARE REMAINS WITH YOU.                        *
 *                                                                        *
 *  5. LIMITATION OF LIABILITY. IN NO EVENT WILL MENTOR GRAPHICS OR ITS   *
 *  LICENSORS BE LIABLE FOR INDIRECT, SPECIAL, INCIDENTAL, OR             *
 *  CONSEQUENTIAL DAMAGES (INCLUDING LOST PROFITS OR SAVINGS) WHETHER     *
 *  BASED ON CONTRACT, TORT OR ANY OTHER LEGAL THEORY, EVEN IF MENTOR     *
 *  GRAPHICS OR ITS LICENSORS HAVE BEEN ADVISED OF THE POSSIBILITY OF     *
 *  SUCH DAMAGES.                                                         *
 *                                                                        *
 *  6.  LIFE ENDANGERING ACTIVITIES. NEITHER MENTOR GRAPHICS NOR ITS      *
 *  LICENSORS SHALL BE LIABLE FOR ANY DAMAGES RESULTING FROM OR IN        *
 *  CONNECTION WITH THE USE OR DISTRIBUTION OF SOFTWARE IN ANY            *
 *  APPLICATION WHERE THE FAILURE OR INACCURACY OF THE SOFTWARE MIGHT     *
 *  RESULT IN DEATH OR PERSONAL INJURY.                                   *
 *                                                                        *
 *  7.  INDEMNIFICATION.  YOU AGREE TO INDEMNIFY AND HOLD HARMLESS        *
 *  MENTOR GRAPHICS AND ITS LICENSORS FROM ANY CLAIMS, LOSS, COST,        *
 *  DAMAGE, EXPENSE, OR LIABILITY, INCLUDING ATTORNEYS' FEES, ARISING     *
 *  OUT OF OR IN CONNECTION WITH YOUR USE OR DISTRIBUTION OF SOFTWARE.    *
 *                                                                        *
 *  8. TERM AND TERMINATION. This Agreement terminates immediately if     *
 *  you exceed the scope of the license granted or fail to comply with    *
 *  the provisions of this License Agreement.  If you institute patent    *
 *  litigation against Mentor Graphics (including a cross-claim or        *
 *  counterclaim in a lawsuit) alleging that the Software constitutes     *
 *  direct or contributory patent infringement, then any patent           *
 *  licenses granted to you under this License for that Software shall    *
 *  terminate as of the date such litigation is filed. Upon termination   *
 *  or expiration, you agree to cease all use of the Software and         *
 *  delete all copies of the Software.                                    *
 *                                                                        *
 *  9. EXPORT. Software may be subject to regulation by local laws and    *
 *  United States government agencies, which prohibit export or           *
 *  diversion of certain products, information about the products, and    *
 *  direct products of the products to certain countries and certain      *
 *  persons. You agree that you will not export any Software or direct    *
 *  product of Software in any manner without first obtaining all         *
 *  necessary approval from appropriate local and United States           *
 *  government agencies.                                                  *
 *                                                                        *
 *  10. RESTRICTED RIGHTS NOTICE. Software was developed entirely at      *
 *  private expense and is commercial computer software provided with     *
 *  RESTRICTED RIGHTS. Use, duplication or disclosure by the U.S.         *
 *  Government or a U.S. Government subcontractor is subject to the       *
 *  restrictions set forth in the license agreement under which           *
 *  Software was obtained pursuant to DFARS 227.7202-3(a) or as set       *
 *  forth in subparagraphs (c)(1) and (2) of the Commercial Computer      *
 *  Software - Restricted Rights clause at FAR 52.227-19, as              *
 *  applicable. Contractor/manufacturer is Mentor Graphics Corporation,   *
 *  8005 SW Boeckman Road, Wilsonville, Oregon 97070-7777 USA.            *
 *                                                                        *
 *  11. CONTROLLING LAW AND JURISDICTION. THIS AGREEMENT SHALL BE         *
 *  GOVERNED BY AND CONSTRUED UNDER THE LAWS OF THE STATE OF OREGON,      *
 *  USA. All disputes arising out of or in relation to this Agreement     *
 *  shall be submitted to the exclusive jurisdiction of Multnomah         *
 *  County, Oregon. This section shall not restrict Mentor Graphics'      *
 *  right to bring an action against you in the jurisdiction where your   *
 *  place of business is located.  The United Nations Convention on       *
 *  Contracts for the International Sale of Goods does not apply to       *
 *  this Agreement.                                                       *
 *                                                                        *
 *  12. SEVERABILITY. If any provision of this Agreement is held by a     *
 *  court of competent jurisdiction to be void, invalid, unenforceable    *
 *  or illegal, such provision shall be severed from this Agreement and   *
 *  the remaining provisions will remain in full force and effect.        *
 *                                                                        *
 *  13. MISCELLANEOUS.  This Agreement contains the parties' entire       *
 *  understanding relating to its subject matter and supersedes all       *
 *  prior or contemporaneous agreements. This Agreement may only be       *
 *  modified in writing by authorized representatives of the parties.     *
 *  Waiver of terms or excuse of breach must be in writing and shall      *
 *  not constitute subsequent consent, waiver or excuse. The prevailing   *
 *  party in any legal action regarding the subject matter of this        *
 *  Agreement shall be entitled to recover, in addition to other          *
 *  relief, reasonable attorneys' fees and expenses.                      *
 *                                                                        *
 **************************************************************************/
