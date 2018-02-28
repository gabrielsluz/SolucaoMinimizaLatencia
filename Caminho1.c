#include <stdlib.h>
#include <stdio.h>


int main(int argc, char* argv[])
{   FILE *arq;
  if(argc <2)
  { printf("\n Entradas invalidas");
    return 1;
  }

  arq = fopen(argv[1],"r");

  if(arq==NULL)
  { printf("\nERRO arquivo nao foi aberto corretamente\n");
    return 1;
  }
  int i,j,k,l,cont;
  int custoTotal, tamanhoTotal, diferencahTotal,diferencacTotal;
  int custoMedio, tamanhoMedio;
  int  diferencahMedia, diferencacMedia;
  int custo,tamanho,diferencah,diferencac;

  fscanf(arq,"%d%d%d%d%d%d%d%d",&custo,&tamanho,&i,&j,&k,&l,&diferencah,&diferencac);

  fclose(arq);

  FILE *out;
  out = fopen(argv[2],"a");

  if(out==NULL)
  { printf("\nERRO arquivo nao foi aberto corretamente\n");
    return 1;
  }

  fprintf(out, "%d\n",j);

  fclose(out);


  return 0;
}
