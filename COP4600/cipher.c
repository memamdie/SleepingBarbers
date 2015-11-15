/* 
 * File:   main.c
 * Author: memamdie
 *
 * Created on November 14, 2015, 6:49 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STR_LENGTH 1024
/*
 * 
 */

void createData(char *up, char *down, char *digit, int lkey, int nkey) {
	int i;
	char letter, x, offset;
	//Create xUpper and offsetUpper
	for(letter = 'A'; letter <= 'Z'; (int) letter++) {
		x = ((letter - 'A' + (lkey % 26) + 26) % 26);
		offset = ((lkey < 0) && (lkey & 0x1)) ? (((x - 'A') & 0x1) ? 'A' : 'a' ) : (((x - 'A') & 0x1) ? 'a' : 'A' );
                up[letter - 'A'] = x + offset;
	}
	//Create xLower and offsetLower
	for(letter = 'a'; letter <= 'z'; (int) letter++) {
		x = ((letter - 'a' + (lkey % 26) + 26) % 26);
		offset = ((lkey < 0) && (lkey & 0x1)) ? (((x - 'a') & 0x1) ? 'a' : 'A' ) : (((x - 'a') & 0x1) ? 'A' : 'a' );
		down[letter - 'a'] = x + offset;
	}
	for(letter = '0'; letter <= '9'; (int) letter++) {
		digit[letter - '0'] = ((letter - '0' + (nkey % 10) + 10) % 10) + '0';
	}
}


int main(int argc, char** argv) {
    char* lower = "abcdefghijklmnopqrstuvwxyz";
    char* upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    char* numbers = "0123456789";
	printf("\nRunning the cipher on the alphabet in lowercase\n");
	cipher(lower, 1, 2);
	printf("\nRunning the cipher on the alphabet in uppercase\n");
	cipher(upper, 1, 2);
        printf("\nRunning the cipher on some numbers\n");
        cipher(numbers, 1, 2);
        printf("%s", numbers);

    return 0;
}
 int cipher( char *text, int lkey, int nkey  ) {
	int i;
	char c, newChar,*up, *down, *digit;
        up = (char*) malloc(sizeof(char)*26);
	down = (char*) malloc(sizeof(char)*26);
	digit =  (char*) malloc(sizeof(char)*26);
	createData(up, down, digit, lkey, nkey);
	for(i = 0; i < strlen(text); i++) {
            c = text[i];
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
            printf("This is the value that you get, %c\n", newChar);
            //text[i] = newChar;
	}
}