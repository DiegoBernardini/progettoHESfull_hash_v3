#include "giovanni.h"
#include "diego.h"

/*Dichiarazionie funzioni*/
ssize_t my_getline(char **lineptr, size_t *n, FILE *stream);
uint8_t crea_M6(uint8_t M);
uint8_t funzione_S(uint8_t M6);
void prima_operazione(uint8_t M);
uint8_t rotate_lower4(uint8_t byte, int i);
void print_bin(unsigned char x);
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

    // seconda_operazione();
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

    DEBUG_PRINT("M: %#X\t M6: %#X\n ",M,M6);

    return M6;
}

uint8_t rotate_lower4(uint8_t byte, int i) {
    uint8_t lower4 = byte & 0x0F;
    uint8_t upper4 = byte & 0xF0;
    
    int k = (i / 2) % 4;  // numero di posizioni di rotazione
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
            DEBUG_PRINT("Valore %d di H prima della rotate: %#X\n",i,H[i]);
            uint8_t a = rotate_lower4((H[(i+1)%8]^funzione_S(crea_M6(M))),i);
            H[i] = a;      
             DEBUG_PRINT("Valore %d di H dopo della rotate: %#X\n",i,H[i]);
        }
    }
}

void print_bin(unsigned char x) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (x >> i) & 1);
    }
}

uint8_t restituisci_C_i(int i){
    uint8_t res = (C>>i*8) & 0xFF;
    return res;
}

void seconda_operazione(){

    for(int i = 0; i<8;i++){
       // H[i] = rotate_lower4((H[(i+1)%8]^funzione_S(crea_C6(restituisci_C_i(i)))),i)
    }
    
}

void compatta_H(){
    for(int i = 0;i<8;i++){
        Hf |= (H[i]&0x0F)<<(7-i)*4;
    }
}