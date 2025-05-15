#include "myheader.h"

unsigned char crea_M6(unsigned char M);


int main(int argc, char* argv[]){

    char *messaggio = NULL;
    size_t C = 0;
    size_t len_max;
    printf("Inserisci un messaggio: ");
    ssize_t len = getline(&messaggio, &C, stdin);
    len_max = C;

    DEBUG_PRINT("Lunghezza Messaggio C: \n Lunghezza Messaggio Len ",C, len);
    
    for(int M_byte = 0; M_byte<len_max;M_byte++){

    }
   

    free(messaggio);
    return 0;
}


unsigned char crea_M6(unsigned char M) {
    unsigned char M6 = 0;

    // Bit 7: M[3] ^ M[2]
    M6 |= (( (M >> 3) & 1) ^ ((M >> 2) & 1)) << 7;

    // Bit 6: M[1]
    M6 |= ((M >> 1) & 1) << 6;

    // Bit 5: M[0]
    M6 |= (M & 1) << 5;

    // Bit 4: M[7]
    M6 |= ((M >> 7) & 1) << 4;

    // Bit 3: M[6]
    M6 |= ((M >> 6) & 1) << 3;

    // Bit 2: M[5] ^ M[4]
    M6 |= (((M >> 5) & 1) ^ ((M >> 4) & 1)) << 2;

    // Bit 1 e 0 restano a 0 (default)

    return M6;
}