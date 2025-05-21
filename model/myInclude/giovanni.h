#include<stdio.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef DEBUG
    #define DEBUG_PRINT(fmt, ...) \
      fprintf(stderr, "[DEBUG] %s:%d:%s(): " fmt "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__) 
#else 
    #define DEBUG_PRINT(fmt, ...) // niente in release
#endif


uint8_t H[8] = {0x03,0x0F,0x0A,0x01,0x0E,0x0F,0x02,0x03};
size_t C = 0;
char *messaggio = NULL;
uint32_t Hf=0;