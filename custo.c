#include <stdlib.h>
#include <stdio.h>


int main(int argc, char* argv[])
{   FILE *arq;

//  printf("Entrou");printf("Entrou");
    if(argc <4)
    { printf("\n Entradas invalidas");
      return 1;
    }

    arq = fopen(argv[1],"r");

    if(arq==NULL)
    { printf("\nERRO arquivo nao foi aberto corretamente\n");
      return 1;
    }

//Loop no arquivo

  int cont=0,aux = 0;
  char string[100];
  int hops = 0;
  int custo0;
int yy;
    while(cont <= 6)
    { fgets(string,100,arq);
      if(cont==0)
      { yy = 11;
        custo0 = (int)string[yy] - 48;
        while(string[yy+1]>= '0' && string[yy+1] <= '9')
        { yy++;
          custo0 = 10*custo0 + (int)string[yy] - 48;
        }
          //printf("\n Custo0 = %d",custo0);
      }
      cont++;
      if(cont == 6)
      { hops = (int)string[20] - 48;

        while(string[21 + aux] != ';')
        {
          hops = 10*hops + (int)string[21+aux] - 48;
          aux ++;
        }
      }
    }
  //  printf("\n %d \n",hops);

    //Vetores dos hops
    int *source,*destination,*radio,*custo;
    source = (int*)calloc(hops,sizeof(int));
    destination = (int*)calloc(hops,sizeof(int));
    radio = (int*)calloc(hops,sizeof(int));
    custo = (int*)calloc(hops,sizeof(int));
    int x;

    cont = hops;
    aux = 0;
    while(cont >= 1)
    { fgets(string,100,arq);
      //printf("%s",string);
      x = 5;
      source[aux] =  (int)string[x] - 48;

      while(string[x+1]>= '0' && string[x+1] <= '9')
      { x++;
        source[aux] = 10*source[aux] + (int)string[x] - 48;
      }

      x = x + 3;
      destination[aux] = (int)string[x] - 48;

      while(string[x+1]>= '0' && string[x+1] <= '9')
      { x++;
        destination[aux] = 10*destination[aux] + (int)string[x] - 48;
      }

      x = x+3;
      radio[aux] = (int)string[x] - 48;

        //printf(" %d %d %d \n",source[aux],destination[aux],radio[aux]);
      aux++;
      cont--;
    }

    fclose(arq);

    //Segundo arquivo
       char stringg[1000];
       int sourcex,destinationx,custox;
        FILE *file;
        file = fopen(argv[2],"r");
        int equal= 0;

        if(file==NULL)
        { printf("\nERRO arquivo nao foi aberto corretamente\n");
          return 1;
        }
        aux = 0;
        int aux1 = 0;
        while(aux1 <= hops && !feof(file))
        {
          fgets(stringg,1000,file);
          //printf("\n %s",stringg);
          aux ++;
          //printf("[0] = %c  %d  aux = %d\n",stringg[0],((int)stringg[0]-48),aux);
          if(aux >= 6)
          {  x = 0;
            sourcex =  (int)stringg[x] - 48;

            while(stringg[x+1]>= '0' && stringg[x+1] <= '9')
            { x++;
              sourcex = 10*sourcex + (int)stringg[x] - 48;
            }

            for(aux1 = 0; aux1 < hops; aux1++)
            { if(sourcex == source[aux1])
              {
                equal = 1;
                break;
              }
            }
            if(equal == 1)
            { //printf("\n Source ==");
              equal = 0;
              x = x + 2;
              destinationx = (int)stringg[x] - 48;

              while(stringg[x+1]>= '0' && stringg[x+1] <= '9')
              { x++;
                destinationx = 10*destinationx + (int)stringg[x] - 48;
              }
              //printf("\ndestinationx = %d",destinationx);
              if(destinationx == destination[aux1])
              {// printf("\nDestinatiox ==");
                //printf("\n %s",stringg);
                if(radio[aux1]==1)
                { //printf("\nRadio 1");
                  x = x + 2;
                  custox = (int)stringg[x] - 48;
                  while(stringg[x+1]>= '0' && stringg[x+1] <= '9')
                  { x++;
                    custox = 10*custox + (int)stringg[x] - 48;
                  }
                  custo[aux1] = custox;

                }
                else
                {//printf("\nRadio 2");

                x = x + 1;
                while(stringg[x+1]>= '0' && stringg[x+1] <= '9')
                { x++;
                }
                x++;
                x++;
                    custox = (int)stringg[x] - 48;

                    while(stringg[x+1]>= '0' && stringg[x+1] <= '9')
                    { x++;
                      custox = 10*custox + (int)stringg[x] - 48;
                    }
                    custo[aux1] = custox;
                }
              //  printf("\n%d\n",custo[aux1]);
                aux1 = 0;
              }
            }
            else
            {
              aux1 = 0;
            }

          }
        }
        fclose(file);


    //Calculo do custo total e do numero de hops:
    int custo1,custoTotal;
    int i;
    custo1 = 0;
      for(i=0;i<hops;i++)
      { //printf("\n %d",custo[i]);
        custo1 += custo[i];
      }
      //printf("\n custo1 = %d",custo1);

     custoTotal = custo1 + custo0;
    /*O que ja foi obtido:
      Hops do caminho 1
      Custo de todos os caminhos
      Custo Total
    */
    //Calculo do numero total de hops

//Arquivo 3

FILE *out;
out = fopen(argv[3],"r");
int j = 0;
int hops0 = 0;
x = 0;
//printf("\n Terceiro arquivo");
yy = 0;
if(out == NULL)
{ printf("\nERRO arquivo nao foi aberto corretamente\n");
  return 1;
}
    while(x==0)
    {
      fgets(stringg,1000,out);
      //printf("\n%s",stringg);
      if(stringg[3] == '3'&& stringg[4]== '1' && stringg[5] == '8' && stringg[6]==' ')
      {  //printf("\n UmRadio");
        j = 1;

      }
      else if(stringg[3] == '3'&& stringg[4]== '9' && stringg[5] == '3' && stringg[6]==' ')
      {
        x = 1;
      }

      if(j==1)
      { yy ++;
        //printf("\n %d",yy);
        hops0 = hops0 + (int)stringg[35] - 48;
      }
      //printf("\n -%c-%c-%c-%c-%c-",stringg[2],stringg[3],stringg[4],stringg[5],stringg[6]);
    }
    fclose(out);
    hops0 = hops0 + 2;
    //printf("\n Hops0 = %d",hops0);
    hops0 = hops0 - hops;
  //  printf("\n %d",hops0);
    //printf("\n");

    // Arquivo 4
    FILE *info;
    info = fopen(argv[4],"w");

  if(info==NULL)
  { printf("ERRO-- O arquivo info nao foi aberto corretamente");
    return 1;
  }
  int hopsT, hopsD,custoD;
  hopsT = hops0 + hops;
  custoD = custo0 - custo1;
  hopsD = hops - hops0;
  if(hopsD<0)
  {
    hopsD = -hopsD;
  }
  fprintf(info,"%d\n%d\n%d %d\n%d %d\n%d\n%d",custoTotal,hopsT,hops,custo1,hops0,custo0,hopsD,custoD);
//printf("%d\n%d\n%d %d\n%d %d\n%d\n%d",custoTotal,hopsT,hops,custo1,hops0,custo0,hopsD,custoD);
  fclose(info);

  return 0;
}
