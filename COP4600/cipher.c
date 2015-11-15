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
	//Create the array for the cipher of numbers
	for(letter = '0'; letter <= '9'; (int) letter++) {
		digit[letter - '0'] = ((letter - '0' + (nkey % 10) + 10) % 10) + '0';
	}
}


int main(int argc, char** argv) {
    
    char *lower, *upper, *numbers, *combined, letter;
    int i;
    combined =  (char*) malloc(sizeof(char)*1030);
    lower = (char*) malloc(sizeof(char)*27);
    upper = (char*) malloc(sizeof(char)*27);
    numbers = (char*) malloc(sizeof(char)*11);
    letter = '0';
    for(i = 0; i < 1030; i++){            
        combined[i] = letter;

        if((int) letter < 122) {
            (int) letter++;
        }
        else {
            letter = '0';     
        }
    }
    for(i = 0; i < 10; i++) {
        numbers[i] = '0' + i;
    }
    for(letter = 'A'; letter <= 'Z'; (int) letter++) {
        upper[letter - 'A'] = letter;
    }
    for(letter = 'a'; letter <= 'z';(int) letter++) {
        lower[letter - 'a'] = letter;
    }
    upper[26] = '\0';
    lower[26] = '\0';
    numbers[10] = '\0';
    combined[1030] = '\0';
//    printf("\nRunning the cipher on a super long combined string\n");
//    cipher(combined, 1, 2);
//    printf("%s\nThe length of the long combined string is %d", combined, strlen(combined));
//        
    printf("\nRunning the cipher on the alphabet in lowercase\n");
    cipher(lower, 1, 2);
    printf("%s\n", lower);
        
    printf("\nRunning the cipher on the alphabet in uppercase\n");
    cipher(upper, 1, 2);
    printf("%s\n", upper);

        
    printf("\nRunning the cipher on some numbers\n");
    cipher(numbers, 1, 2);
    printf("%s\n", numbers);
    
    free(upper);
    free(lower);
    free(numbers);
    free(combined);
    return 0;
}
 int cipher( char *text, int lkey, int nkey  ) {
	int i, j;
	char c, newChar,*up, *down, *digit, *substring;
        substring = (char*) malloc(sizeof(char)*2);        
        up = (char*) malloc(sizeof(char)*26);
	down = (char*) malloc(sizeof(char)*26);
	digit =  (char*) malloc(sizeof(char)*10);
	createData(up, down, digit, lkey, nkey);
        substring[2] = '\0';
	for(i = 0; i < strlen(text) && i < 1024; i++) {
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
            text[i] = newChar;
	}
	if(strlen(text) > 1025) {
		text[1025] = '\0';
	}
	free(up);
	free(down);
	free(digit);
        
        
        //Pass 2
        //If this is true then we know we have to enter case 1 at least once
        i = 0;
        while(i < strlen(text)) {
            if(i + 3 < strlen(text) &&  strlen(text) > 4) {
                //Case |QUAD| == 4
                substring[0] = text[i];
                substring[1] = text[i+1];
                text[i] = text[i+2];
                text[i+1] = text[i+3];
                text[i+2] = substring[0];
                text[i+3] = substring[1];
                i = i+4;
            }
            else {
                j = strlen(text) - i;
                if (j == 3) {
                    newChar = text[i];
                    text[i] = text[strlen(text)-1];
                    text[strlen(text)-1] = newChar;
                    break;
                }
                else if(j == 2) {
                    newChar = text[i];
                    text[i] = text[strlen(text)-1];
                    text[strlen(text)-1] = newChar;
                    break;
                }
                else {
                    text[i] = text[i];
                    break;
                }
            }
        }
        
}

