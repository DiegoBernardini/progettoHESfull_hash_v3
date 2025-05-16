#include <stdio.h>
#include <myheader.h>
int main(){

unsigned char crea_M6(unsigned char M);
void prima_operazione(unsigned char M);

printf("sizeof int %d\n", (int)sizeof(int));
printf("SBOX %d\n", (int)sizeof(SBOX));
printf("SBOXDIM %d\n", (int)SBOX_DIM);





    size_t len_max;
    printf("Inserisci un messaggio: ");
    ssize_t len = getline(&messaggio, &C, stdin);
    len_max = C;

    DEBUG_PRINT("Lunghezza Messaggio C: \n Lunghezza Messaggio Len ",C, len);

    for(int M_byte = 0; M_byte<len_max;M_byte++){
        prima_operazione(messaggio[i]);
    }


    free(messaggio);
    return 0;
}


unsigned char crea_M6(unsigned char M) {
    unsigned char M6 = 0;

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


void prima_operazione(unsigned char M){

    for(int r=0; r<12;r++){
        for(int i=0;i<8;i++){

        }
    }
}