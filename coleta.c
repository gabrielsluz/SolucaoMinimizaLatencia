#include <stdlib.h>
#include <stdio.h>


int main(int argc, char* argv[])
{   FILE *arq;

//  printf("Entrou");printf("Entrou");
    if(argc <3)
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
    float  diferencahMedia, diferencacMedia;
    float custo,tamanho,diferencah,diferencac;

    fscanf(arq,"%f%f%d%d%d%d%f%f",&custo,&tamanho,&i,&j,&k,&l,&diferencah,&diferencac);

    fclose(arq);

    FILE *file;

    file = fopen(argv[2],"r");

    if(file==NULL)
    { printf("\nERRO arquivo nao foi aberto corretamente\n");
      return 1;
    }

    fscanf(file,"%d%d%d%d%d%d%f%f%d",&custoTotal,&tamanhoTotal,&diferencacTotal,&diferencahTotal,&custoMedio,&tamanhoMedio,&diferencacMedia,&diferencahMedia,&cont);

    custoTotal = custoTotal + custo;
    cont ++;
    tamanhoTotal = tamanhoTotal + tamanho;
    diferencacTotal += diferencac;
    diferencahTotal += diferencah;
    custoMedio = custoTotal/cont;
    tamanhoMedio = tamanhoTotal/cont;
    diferencahMedia = diferencahTotal/cont;
    diferencacMedia = diferencacTotal/cont;


    fclose(file);

    FILE *out;

    out = fopen(argv[3],"w");

    if(out==NULL)
    { printf("\nERRO arquivo nao foi aberto corretamente\n");
      return 1;
    }

    fprintf(out,"%d %d %d %d %d %d %f %f %d",custoTotal,tamanhoTotal,diferencacTotal,diferencahTotal,custoMedio,tamanhoMedio,diferencacMedia,diferencahMedia,cont);

    fclose(out);


    return 0;
}
