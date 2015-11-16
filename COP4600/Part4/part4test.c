#include <sys/syscall.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) {    
    int i;
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
