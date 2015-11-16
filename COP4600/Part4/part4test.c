#include <sys/syscall.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) {    
//    char *lower, *upper, *numbers, *combined, letter;
    int i;
//    combined =  (char*) malloc(sizeof(char)*1030);
//    lower = (char*) malloc(sizeof(char)*27);
//    upper = (char*) malloc(sizeof(char)*27);
//    numbers = (char*) malloc(sizeof(char)*11);
//    letter = '0';
//    for(i = 0; i < 1030; i++){            
//        combined[i] = letter;
//
//        if((int) letter < 122) {
//            (int) letter++;
//        }
//        else {
//            letter = '0';     
//        }
//    }
//    for(i = 0; i < 10; i++) {
//        numbers[i] = '0' + i;
//    }
//    for(letter = 'A'; letter <= 'Z'; (int) letter++) {
//        upper[letter - 'A'] = letter;
//    }
//    for(letter = 'a'; letter <= 'z';(int) letter++) {
//        lower[letter - 'a'] = letter;
//    }
//    upper[26] = '\0';
//    lower[26] = '\0';
//    numbers[10] = '\0';
//    combined[1030] = '\0';
//    printf("\nRunning the cipher on a super long combined string\n");
//    cipher(combined, 1, 2);
//    printf("%s\nThe length of the long combined string is %d", combined, strlen(combined));
//        
	char upper[27] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	char lower[27] = "abcdefghijklmnopqrstuvwxyz";
	char numbers[11] = "01236789";
    printf("\nRunning the cipher on the alphabet in lowercase\n");
    syscall(SYS_cipher, lower, 2, 3);
    printf("%s\n", lower);
        
    printf("\nRunning the cipher on the alphabet in uppercase\n");
    syscall(SYS_cipher, upper, 1, 2);
    printf("%s\n", upper);

        
    printf("\nRunning the cipher on some numbers\n");
    syscall(SYS_cipher, numbers, 1, 2);
    printf("%s\n", numbers);
    
//    free(upper);
//    free(lower);
//    free(numbers);
//    free(combined);
    return 0;
	}