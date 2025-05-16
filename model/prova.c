#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

unsigned char crea_M6(unsigned char M);

void print_bin(unsigned char x) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (x >> i) & 1);
    }
}


ssize_t my_getline(char **lineptr, size_t *n, FILE *stream) {
    if (*lineptr == NULL || *n == 0) {
        *n = 128;
        *lineptr = malloc(*n);
        if (*lineptr == NULL) return -1;
    }

    int ch = 0;
    size_t i = 0;

    while ((ch = fgetc(stream)) != EOF && ch != '\n') {
        if (i + 1 >= *n) {
            *n *= 2;
            char *new_ptr = realloc(*lineptr, *n);
            if (!new_ptr) return -1;
            *lineptr = new_ptr;
        }
        (*lineptr)[i++] = ch;
    }

    if (ch == EOF && i == 0) return -1;

    (*lineptr)[i] = '\0';
    return i;
}


void test_crea_M6(unsigned char M, unsigned char expected) {
    unsigned char result = crea_M6(M);
    printf("Input M:    ");
    print_bin(M);
    printf(" (0x%02X)\n", M);

    printf("Output M6:  ");
    print_bin(result);
    printf(" (0x%02X)\n", result);

    printf("Expected:   ");
    print_bin(expected);
    printf(" (0x%02X)\n", expected);

    if (result == expected) {
        printf(" Test OK\n\n");
    } else {
        printf(" Test FALLITO\n\n");
    }
}

uint8_t rotate_lower4(uint8_t byte, int i) {
    uint8_t lower4 = byte & 0x0F;
    uint8_t upper4 = byte & 0xF0;
   
    int k = (i / 2) % 4;  // numero di posizioni di rotazione
 print_bin(byte);
    if (k != 0) {
        lower4 = ((lower4 << k) & 0x0F) | (lower4 >> (4 - k));
    }
    printf("\n");
    print_bin(upper4 | lower4);
    return upper4 | lower4;
}

int main() {
   
    char* messaggio = NULL; 
    size_t dim = 0;
    size_t read;
    read = my_getline(&messaggio,&dim,stdin);

    printf("Messaggio: %s \n Lunghezza: %d\n",messaggio,(int)dim);

    rotate_lower4(0b00001100,4 );

    

    return 0;
}

unsigned char crea_M6(unsigned char M) {
    unsigned char M6 = 0;

    // Bit 7: M[3] ^ M[2]
    M6 |= (( (M >> 3) & 1) ^ ((M >> 2) & 1)) << 5;
    printf("Bit 7:");
    print_bin(M6);
    // Bit 6: M[1]
    M6 |= ((M >> 1) & 1) << 4;
    printf("Bit 6:");
    print_bin(M6);
    
    // Bit 5: M[0]
    M6 |= (M & 1) << 3;
    printf("Bit 5:");
    print_bin(M6);
    
    // Bit 4: M[7]
    M6 |= ((M >> 7) & 1) << 2;
printf("Bit :");
    print_bin(M6);
    
    // Bit 3: M[6]
    M6 |= ((M >> 6) & 1) << 1;
printf("Bit 7:");
    print_bin(M6);
    
    // Bit 2: M[5] ^ M[4]
    M6 |= (((M >> 5) & 1) ^ ((M >> 4) & 1));
printf("Bit 7:");
    print_bin(M6);
    
    // Bit 1 e 0 restano a 0 (default)

    return M6;
}