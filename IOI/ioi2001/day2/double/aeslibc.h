/* File: aeslibc.h
 * Copyright (c) 2001, IOI
 * Header file for aeslibc.c
 * GNU C/C++ library for task DOUBLE at IOI2001 Competition
 */

#ifndef __AESLIBC_H
#define __AESLIBC_H

#ifdef __cplusplus
extern "C" {
#endif

#define HEXSTRLEN	( 32 )
#define BLOCKLEN	( 16 )

typedef char HexStr [ HEXSTRLEN+1 ]; /* '0'..'9', 'A'..'F', '\0'-terminated */
typedef unsigned char Block [ BLOCKLEN ];  /* 128 bits */

void hexstr2block ( const HexStr hs, /* out-param */ Block b );
void block2hexstr ( const Block b, /* out-param */ HexStr hs );
void encrypt ( const Block p, const Block k, /* out-param */ Block c );
  /* c = E(p,k) */
void decrypt ( const Block c, const Block k, /* out-param */ Block p );
  /* p = D(c,k) */

#ifdef __cplusplus
}
#endif

#endif /* __AESLIBC_H */

/* End of file aeslibc.h */
