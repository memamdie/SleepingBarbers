/*	$OpenBSD: cop4600.c,v 1.00 2003/07/12 01:33:27 dts Exp $	*/

#include <sys/param.h>
#include <sys/acct.h>
#include <sys/systm.h>
#include <sys/ucred.h>
#include <sys/proc.h>
#include <sys/timeb.h>
#include <sys/times.h>
#include <sys/malloc.h>
#include <sys/filedesc.h>
#include <sys/pool.h>
//#include <sys/string.h>

#include <sys/mount.h>
#include <sys/syscallargs.h>

/*========================================================================**
**  Dave's example system calls                                           **
**========================================================================*/

/*
** hello() prints to the tty a hello message and returns the process id
*/

int
sys_hello( struct proc *p, void *v, register_t *retval )
{
  uprintf( "\nHello, process %d!\n", p->p_pid );
  *retval = p->p_pid;

  return (0);
}

/*
** showargs() demonstrates passing arguments to the kernel
*/

#define MAX_STR_LENGTH  1024

int
sys_showargs( struct proc *p, void *v, register_t *retval )
{
  /* The arguments are passed in a structure defined as:
  **
  **  struct sys_showargs_args
  **  {
  **      syscallarg(char *) str;
  **      syscallarg(int)    val;
  **  }
  */

  struct sys_showargs_args *uap = v;

  char kstr[MAX_STR_LENGTH+1]; /* will hold kernal-space copy of uap->str */
  int err = 0;
  int size = 0;

  /* copy the user-space arg string to kernal-space */

  err = copyinstr( SCARG(uap, str), &kstr, MAX_STR_LENGTH, &size );
  if (err == EFAULT)
    return( err );

  uprintf( "The argument string is \"%s\"\n", kstr );
  uprintf( "The argument integer is %d\n", SCARG(uap, val) );
  *retval = 0;

  return (0);
}

/*========================================================================**
**  Michelle's COP4600 2004C system calls                                 **
**========================================================================*/
int sys_cipher( struct proc *p, void *v, register_t *retval ) {
	int i, j, err, size, k_nkey, k_lkey;
	char c, newChar,*up, *down, *digit, *substring, letter, x, offset;

  char ktext[MAX_STR_LENGTH+1]; /* will hold kernel-space copy of uap->str */
  struct sys_cipher_args *uap = v;

  err = 0;
  size = 0;

	k_lkey = SCARG(uap, lkey);
	k_nkey = SCARG(uap, nkey);
  /* copy the user-space arg string to kernel-space */

  err = copyinstr( SCARG(uap, text), &ktext, MAX_STR_LENGTH, &size );
  if (err == EFAULT)
    return(err);


	substring = (char*) malloc(sizeof(char)*2, M_TEMP, M_WAITOK);        
	up = (char*) malloc(sizeof(char)*26, M_TEMP, M_WAITOK);
	down = (char*) malloc(sizeof(char)*26, M_TEMP, M_WAITOK);
	digit =  (char*) malloc(sizeof(char)*10, M_TEMP, M_WAITOK);

	//Create xUpper and offsetUpper
	for(letter = 'A'; letter <= 'Z'; letter++) {
		x = ((letter - 'A' + (k_lkey % 26) + 26) % 26);
		offset = ((k_lkey < 0) && (k_lkey & 0x1)) ? (((x - 'A') & 0x1) ? 'A' : 'a' ) : (((x - 'A') & 0x1) ? 'a' : 'A' );
                up[letter - 'A'] = x + offset;
	}
	//Create xLower and offsetLower
	for(letter = 'a'; letter <= 'z'; letter++) {
		x = ((letter - 'a' + (k_lkey % 26) + 26) % 26);
		offset = ((k_lkey < 0) && (k_lkey & 0x1)) ? (((x - 'a') & 0x1) ? 'a' : 'A' ) : (((x - 'a') & 0x1) ? 'A' : 'a' );
		down[letter - 'a'] = x + offset;
	}
	//Create the array for the cipher of numbers
	for(letter = '0'; letter <= '9'; letter++) {
		digit[letter - '0'] = ((letter - '0' + (k_nkey % 10) + 10) % 10) + '0';
	}
    //Pass 1
	substring[2] = '\0';
	for(i = 0; i < strlen(ktext) && i < 1024; i++) {
            c = ktext[i];
            switch (c) {
                case 'A'...'Z':
                    newChar = up[c-'A'];
                    break;

                case 'a'...'z':
                    newChar = down[c-'a'];
                    break;

                case '0'...'9':
                    newChar = digit[c-'0'];
                    break;

                default:
                    newChar = c;
                    break;
            }
            ktext[i] = newChar;
	}
	if(strlen(ktext) > 1025) {
		ktext[1025] = '\0';
	}
    //free things that we malloc'ed
	free(up, M_TEMP);
	free(down, M_TEMP);
	free(digit, M_TEMP);
	err = copyoutstr( &ktext, SCARG(uap, text), MAX_STR_LENGTH+1, &size );
	//Pass 2
	//If this is true then we know we have to enter case 1 at least once
	i = 0;
	while(i < strlen(ktext)) {
            if(i + 3 < strlen(ktext) &&  strlen(ktext) > 4) {
                //Case |QUAD| == 4
                substring[0] = ktext[i];
                substring[1] = ktext[i+1];
                ktext[i] = ktext[i+2];
                ktext[i+1] = ktext[i+3];
                ktext[i+2] = substring[0];
                ktext[i+3] = substring[1];
                i = i+4;
            }
            else {
                j = strlen(ktext) - i;
                //Case |QUAD| == 3
                if (j == 3) {
                    newChar = ktext[i];
                    ktext[i] = ktext[strlen(ktext)-1];
                    ktext[strlen(ktext)-1] = newChar;
                    break;
                }
                //Case |QUAD| == 2
                else if(j == 2) {
                    newChar = ktext[i];
                    ktext[i] = ktext[strlen(ktext)-1];
                    ktext[strlen(ktext)-1] = newChar;
                    break;
                }
                //Case |QUAD| == 1
                else {
                    ktext[i] = ktext[i];
                    break;
                }
            }
        }
    //free the malloc
	free(substring, M_TEMP);
}
