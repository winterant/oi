/* File: aestoolc.c
 * Copyright (c) 2001, IOI
 * Example C program for using GNU C/C++ library aeslibc
 * Task DOUBLE at IOI2001 Competition
 */

#include	<stdio.h>
#include	<ctype.h>
#include	<string.h>
#include	"aeslibc.h"

void pad0 ( /* in, out */ HexStr s )
{
  char *p = s; /* to traverse s */
  int len = 0; /* to count # char in s */

  while ( *p ) {
    *p = toupper ( *p );
    ++len;
    ++p;
  }

  while ( len < HEXSTRLEN ) {
    *p = '0';
    ++len;
    ++p;
  }

  *p = '\0';
}

/* const */ char Unmodified[] = "";             /* marks unmodified block */
/* const */ char Modified[]   = " <-- updated"; /* marks modified block */

void interact ( void )
{
  char command, dummy;
  HexStr p, k, c, tmp;
  Block pt, ck, ct;
  char *pStatus, *kStatus, *cStatus;

  *p = '\0';
  *k = '\0';
  *c = '\0';
  pStatus = Unmodified;
  kStatus = Unmodified;
  cStatus = Unmodified;

  do {
    printf ( "\n" );
    pad0 ( p );
    pad0 ( k );
    pad0 ( c );
    printf ( "Plaintext  = %s%s\n", p, pStatus );
    printf ( "Key        = %s%s\n", k, kStatus );
    printf ( "Ciphertext = %s%s\n", c, cStatus );
    printf ( "HexStr index 01234567890123456789012345678901 (% 10)\n" );
    printf ( "Block index   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 (% 10)\n" );
    pStatus = Unmodified;
    kStatus = Unmodified;
    cStatus = Unmodified;
    printf ( "P(laintext, C(iphertext, K(ey, E(ncrypt, D(ecrypt, S(wap, Q(uit? " );
    scanf ( " %c", &command );
    command = toupper ( command );

    do {
      scanf ( "%c", &dummy );
    } while ( dummy != '\n' );

    switch ( command ) {
      case 'P':
        printf ( "Plaintext?   " );
        scanf ( "%32s", p );
        pStatus = Modified;
        break;
      case 'K':
        printf ( "Key?         " );
        scanf ( "%32s", k );
        kStatus = Modified;
        break;
      case 'C':
        printf ( "Ciphertext?  " );
        scanf ( "%32s", c );
        cStatus = Modified;
        break;
      case 'E':
        hexstr2block ( p, pt );
        hexstr2block ( k, ck );
        encrypt ( pt, ck, ct );
        block2hexstr ( ct, c );
        printf ( "Encrypted plaintext with key to ciphertext\n" );
        cStatus = Modified;
        break;
      case 'D':
        hexstr2block ( c, ct );
        hexstr2block ( k, ck );
        decrypt ( ct, ck, pt );
        block2hexstr ( pt, p );
        printf ( "Decrypted ciphertext with key to plaintext\n" );
        pStatus = Modified;
        break;
      case 'S':
        strcpy ( tmp, p );
        strcpy ( p, c );
        strcpy ( c, tmp );
        printf ( "Swapped plaintext and ciphertext\n" );
        pStatus = Modified;
        cStatus = Modified;
        break;
      case 'Q':
        printf ( "End of Interaction with aeslibc\n" );
        break;
      default:
        printf ( "Unknown command '%c'\n", command );
    }

  } while ( command != 'Q' );

}

int main ( )
{
  printf ( "Interactive Tool for Using GNU C/C++ Library aeslibc\n" );
  interact ( );
  return 0;
}

/* End of file aestoolc.c */
