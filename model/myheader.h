#include<stdio.h>
#include <stdint.h>

#ifdef DEBUG
    #define DEBUG_PRINT(fmt, ...) \
      fprintf(stderr, "[DEBUG] %s:%d:%s(): " fmt "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__) \
#else 
    #define DEBUG_PRINT(fmt, ...) // niente in release
#endif


uint32_t H = 0x3FA1EF23;
size_t C = 0;
char *messaggio = NULL;