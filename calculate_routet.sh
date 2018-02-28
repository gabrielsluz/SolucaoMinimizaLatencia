#!/bin/bash

# if (($# != 2)); then
#   echo "usage: ./calculate_route.sh <origin> <destination>"
#   exit 1
# fi

if [ ! -d data ]
then
  mkdir data
fi

if [ ! -d outputs ]
then
  mkdir outputs
fi

if [ ! -d routes ]
then
  mkdir routes
fi

if [ ! -d Info ]
then
  mkdir Info
fi

for i in 1 2 3 4 5 6 7 8 9 10 16 17 18 19 20 22 23 24 25 26 27 28 29 30 31 32 33 34 35 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 76 77 78 79 80 81 82 83 84 85 91 92 93 94 95 96 97 98 99 100
# for i in 1
do
  for j in 1 2 3 4 5 6 7 8 9 10 16 17 18 19 20 22 23 24 25 26 27 28 29 30 31 32 33 34 35 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 76 77 78 79 80 81 82 83 84 85 91 92 93 94 95 96 97 98 99 100
  # for j in 1
  do
    if ((i != j))
    then
      if [ ! -e data_$i\_$j.dat ]
      then
        python create_data_file.py -i topology -o data/data_$i\_$j.dat -s $i -d $j
      fi
      if [ -e data/data_$i\_$j.dat ] && [ ! -e outputs/output_$i\_$j.txt ]
      then
        glpsol -m NewSolution.mod -d data/data_$i\_$j.dat -o outputs/output_$i\_$j.txt > glpsol_log.txt
      fi
      if [ -e outputs/output_$i\_$j.txt ] && [ ! -e routes/dual_$i\_$j.txt ]
      then
        python create_route_file.py -i outputs/output_$i\_$j.txt -o routes/dual_$i\_$j.txt
      fi
      if [ -e routes/dual_$i\_$j.txt ] && [ ! -e Info/info_$i\_$j.txt ]
      then
       	gcc custo.c -o custo
      fi
      if [ -e routes/dual_$i\_$j.txt ] && [ ! -e Info/info_$i\_$j.txt ]
      then
       	./custo routes/dual_$i\_$j.txt data/data_$i\_$j.dat outputs/output_$i\_$j.txt Info/info_$i\_$j.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc difCusto.c -o difCusto
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./difCusto Info/info_$i\_$j.txt Coleta/difCusto.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc difHops.c -o difHops
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./difHops Info/info_$i\_$j.txt Coleta/difHops.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc custoTotal.c -o custoTotal
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./custoTotal Info/info_$i\_$j.txt Coleta/custoTotal.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc tamanhoTotal.c -o tamanhoTotal
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./tamanhoTotal Info/info_$i\_$j.txt Coleta/tamanhoTotal.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc Caminho1.c -o Caminho1
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./Caminho1 Info/info_$i\_$j.txt Coleta/Caminho1.txt
      fi
	if [ -e routes/dual_$i\_$j.txt ]
      then
       	gcc Caminho2.c -o Caminho2
      fi
      if [ -e routes/dual_$i\_$j.txt ]
      then
       	./Caminho2 Info/info_$i\_$j.txt Coleta/Caminho2.txt
      fi
    fi
    printf "\r $i $j" 
    
  done
done

printf "\n"
