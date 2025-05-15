#include <stdio.h>
#include <myheader.h>
int main(){


  printf("sizeof int %d\n", (int)sizeof(int));
  printf("SBOX %d\n", (int)sizeof(SBOX));
  printf("SBOXDIM %d\n", (int)SBOX_DIM);

  return 0;
}