#include "giovanni.h"
#include "diego.h"

/*Dichiarazione funzioni*/
ssize_t my_getline(char **lineptr, size_t *n, FILE *stream);
uint8_t crea_M6(uint8_t M);
uint8_t funzione_S(uint8_t M6);
void prima_operazione(uint8_t M);
uint8_t rotate_lower4(uint8_t byte, int i);
//void print_bin(unsigned char x);
void seconda_operazione();
uint8_t restituisci_C_i(int i);
void compatta_H();



/*MAIN */
int main(int argc, char* argv[]){

    size_t len_max;
    printf("Inserisci un messaggio: ");
    my_getline(&messaggio, &C, stdin);
    len_max = C;

    DEBUG_PRINT("Lunghezza Messaggio C: %zu",C);
    if(C!=0){
        for(int M_byte = 0; M_byte<len_max;M_byte++){
            DEBUG_PRINT("BYTE ANALIZZATO: %#X",messaggio[M_byte]);
            prima_operazione(messaggio[M_byte]);
        }
    }

    seconda_operazione();
    compatta_H();

    printf("Digest Intero:  %u, Digest Hex : %#X",Hf,Hf);
    free(messaggio);
    return 0;
}

/*Definizione funzioni*/

ssize_t my_getline(char **lineptr, size_t *n, FILE *stream) {  
    if (*lineptr == NULL || *n == 0) {
        *n = 1;
        *lineptr = malloc(*n);
        if (*lineptr == NULL) return -1;
    }

    int ch = 0;
    size_t i = 0;

    while ((ch = fgetc(stream)) != EOF && ch != '\n') {

        if (i+1 >= *n) {
            *n += 1;
            char *new_ptr = realloc(*lineptr, *n);
            if (!new_ptr) return -1;
            *lineptr = new_ptr;
        }

        (*lineptr)[i++] = ch;
    }

    if(ch == '\n') { *n -= 1 ; return -1;}

    if (ch == EOF && i == 0) return -1;

    (*lineptr)[i] = '\0';
    return i;
}

//S-box transformation of DES algorithm that works over a byte
uint8_t funzione_S(uint8_t M6){
    uint8_t riga = 0;
    uint8_t colonna = 0;
    DEBUG_PRINT("M6: %#X \t",M6);
    riga |= (M6>>5 & 1)<<1;
    riga |= (M6 & 1);
    DEBUG_PRINT("Riga S : %#X \t",riga);
    colonna |= (M6 & 0x1E)>>1;
    DEBUG_PRINT("Colonna S : %#X\t",colonna);
    DEBUG_PRINT("Valore S box: %#X\n",SBOX[riga][colonna]);
    return SBOX[riga][colonna];
}

// 𝑀6 = {𝑀[3] ⊕ 𝑀[2], 𝑀[1], 𝑀[0], 𝑀[7], 𝑀[6], 𝑀[5] ⊕ 𝑀[4]}
uint8_t crea_M6(uint8_t M) {
    uint8_t M6 = 0;

    // Bit 5: M[3] ^ M[2]
    M6 |= (( (M >> 3) & 1) ^ ((M >> 2) & 1)) << 5;

    // Bit 4: M[1]
    M6 |= ((M >> 1) & 1) << 4;

    // Bit 3: M[0]
    M6 |= (M & 1) << 3;

    // Bit 2: M[7]
    M6 |= ((M >> 7) & 1) << 2;

    // Bit 1: M[6]
    M6 |= ((M >> 6) & 1) << 1;

    // Bit 0: M[5] ^ M[4]
    M6 |= (((M >> 5) & 1) ^ ((M >> 4) & 1));

    DEBUG_PRINT("M: %#X\t M6: %#X\n ",M,M6);

    return M6;
}

//𝐶6[𝑖] = {𝐶[𝑖][7] ⊕ 𝐶[𝑖][1], 𝐶[𝑖][3], 𝐶[𝑖][2], 𝐶[𝑖][5] ⊕ 𝐶[𝑖][0],𝐶[𝑖][4],𝐶[𝑖][6]}
uint8_t crea_C6(uint8_t C){
  uint8_t C6 = 0;

  // Bit 5: C[7] ^ C[1]
  C6 |= (BIT(C, 7) ^ BIT(C, 1)) << 5;

  // Bit: 4 C[3]
  C6 |= (BIT(C, 3)) << 4;

  // Bit 3: C[2]
  C6 |= (BIT(C, 2)) << 3;

  // Bit 2: C[5] ^ C[0]
  C6 |= (BIT(C, 5) ^ BIT(C, 0)) << 2;

  // Bit 1: C[4]
  C6 |= (BIT(C, 4)) << 1;

  // Bit 0: C[6]
  C6 |= (BIT(C, 6)) << 0;

  return C6;
}

//left circular shift by k bits
uint8_t rotate_lower4(uint8_t byte, int i) {
    DEBUG_PRINT("Byte originale: %#X",byte);
    uint8_t lower4 = byte & 0x0F;
    uint8_t upper4 = byte & 0xF0;

    int k = (i / 2) ;  // numero di posizioni di rotazione
    DEBUG_PRINT("Byte originale: %#X\t Rotazione: %d ",byte,k);
    if (k != 0) {
        lower4 = ((lower4 << k) & 0x0F) | (lower4 >> (4 - k));
    }
    DEBUG_PRINT("Byte ruotato: %#X\n",upper4|lower4);
    return upper4 | lower4;
}


void prima_operazione(uint8_t M){

    for(int r=0; r<12;r++){
        DEBUG_PRINT("Passo %d della prima operazione",r);
        for(int i=0;i<8;i++){
            DEBUG_PRINT("Interazione %d della del passo %d operazione",i,r);
            DEBUG_PRINT("Valore %d di H prima della rotate: %#X\n",i,H[i]);
            DEBUG_PRINT("Valore %d di H+1 prima della rotate: %#X\n",i,H[(i+1)%8]);
            uint8_t a = rotate_lower4((H[(i+1)%8]^funzione_S(crea_M6(M))),i);
            H[i] = a;
            DEBUG_PRINT("Valore %d di H dopo della rotate: %#X\n",i,H[i]);
        }
    }
}
/*
void print_bin(unsigned char x) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (x >> i) & 1);
    }
}
*/

//restituisce il byte i-esimo di C
uint8_t restituisci_C_i(int i){
    uint8_t res = (C>>i*8) & 0xFF;
    return res;
}

void seconda_operazione(){

    for(int i = 0; i<8;i++){
       H[i] = rotate_lower4((H[(i+1)%8]^funzione_S(crea_C6(restituisci_C_i(i)))),i);
    }

}
//compatta i valori del vettore in un unica variabile
void compatta_H(){
    for(int i = 0;i<8;i++){
        Hf |= (H[i]&0x0F)<<(7-i)*4;
    }
}