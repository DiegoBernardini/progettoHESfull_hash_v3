#include "giovanni.h"
#include "myheader.h"


ssize_t my_getline(char **lineptr, size_t *n, FILE *stream);
uint8_t crea_M6(uint8_t M);
void prima_operazione(uint8_t M);
uint8_t rotate_lower4(uint8_t byte, int i);
void print_bin(unsigned char x);
int main(int argc, char* argv[]){
void seconda_operazione();
   
    
    size_t len_max;
    printf("Inserisci un messaggio: ");
    ssize_t len =my_getline(&messaggio, &C, stdin);
    len_max = C;

    DEBUG_PRINT("Lunghezza Messaggio C: \n Lunghezza Messaggio Len ",C, len);
    
    for(int M_byte = 0; M_byte<len_max;M_byte++){
        prima_operazione(messaggio[i]);
    }
   

    free(messaggio);
    return 0;
}


ssize_t my_getline(char **lineptr, size_t *n, FILE *stream) {
    if (*lineptr == NULL || *n == 0) {
        *n = 1;
        *lineptr = malloc(*n);
        if (*lineptr == NULL) return -1;
    }

    int ch = 0;
    size_t i = 0;

    while ((ch = fgetc(stream)) != EOF && ch != '\n') {
        printf("%zu\n",*n);
        if (i+1 >= *n) {
            *n += 1;
            char *new_ptr = realloc(*lineptr, *n);
            if (!new_ptr) return -1;
            *lineptr = new_ptr;
        }
        printf("%zu\n",*n);
        (*lineptr)[i++] = ch;
    }

    if (ch == EOF && i == 0) return -1;

    (*lineptr)[i] = '\0';
    return i;
}

uint8_t crea_M6(uint8_t M) {
    uint8_t M6 = 0;

    // Bit 7: M[3] ^ M[2]
    M6 |= (( (M >> 3) & 1) ^ ((M >> 2) & 1)) << 5;

    // Bit 6: M[1]
    M6 |= ((M >> 1) & 1) << 4;

    // Bit 5: M[0]
    M6 |= (M & 1) << 3;

    // Bit 4: M[7]
    M6 |= ((M >> 7) & 1) << 2;

    // Bit 3: M[6]
    M6 |= ((M >> 6) & 1) << 1;

    // Bit 2: M[5] ^ M[4]
    M6 |= (((M >> 5) & 1) ^ ((M >> 4) & 1));

    return M6;
}

uint8_t rotate_lower4(uint8_t byte, int i) {
    uint8_t lower4 = byte & 0x0F;
    uint8_t upper4 = byte & 0xF0;

    int k = (i / 2) % 4;  // numero di posizioni di rotazione

    if (k != 0) {
        lower4 = ((lower4 << k) & 0x0F) | (lower4 >> (4 - k));
    }
    DEBUG_PRINT("Prova rotazione:",print_bin(upper4|lower4));
    return upper4 | lower4;
}


void prima_operazione(uint8_t M){

    for(int r=0; r<12;r++){
        for(int i=0;i<8;i++){
            uint8_t a = rotate_lower4((H[(i+1)%8]^funzione_S(crea_M6(M))),i);
            H[i] = a;      
        }
    }
}

void print_bin(unsigned char x) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (x >> i) & 1);
    }
}


void seconda_operazione(){
    
}