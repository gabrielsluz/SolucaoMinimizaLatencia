set N; # Nos
set O; # Origem
set D; # Destino
set NotD := N diff D; # Nos que nao sao destino
set NotOD := NotD diff O; # Nos que nao sao origem nem destino

set A within N cross N; # Arestas
set S{i in N} := {j in N: (i,j) in A}; # Saída
set E{i in N} := {j in N: (j,i) in A}; # Entrada

param c1{A}; # Custo
param c2{A};

var x1{A}, binary;
var x2{A}, binary;
var x10{A}, binary;
var x20{A}, binary;

 minimize obj: (sum{(i,j) in A} (c1[i,j] * x10[i,j] + c2[i,j] * x20[i,j]));

# Conservacao do Fluxo
s.t. cons1O2{i in O}: sum{j in E[i]} x2[j,i] = 0;
s.t. cons1NotOD{i in NotOD}: sum{j in S[i]} x1[i,j] - sum{j in E[i]} x2[j,i] = 0;

s.t. cons2O2{i in O}: sum{j in E[i]} x1[j,i] = 0;
s.t. cons2NotOD{i in NotOD}: sum{j in S[i]} x2[i,j] - sum{j in E[i]} x1[j,i] = 0;

#Caminho 2
s.t. cons10O2{i in O}: sum{j in E[i]} x20[j,i] = 0;
s.t. cons10NotOD{i in NotOD}: sum{j in S[i]} x10[i,j] - sum{j in E[i]} x20[j,i] = 0;

s.t. cons20O2{i in O}: sum{j in E[i]} x10[j,i] = 0;
s.t. cons20NotOD{i in NotOD}: sum{j in S[i]} x20[i,j] - sum{j in E[i]} x10[j,i] = 0;


#Apenas um radio
s.t. umradio{i in NotD}: sum{j in E[i]} x1[j,i] + sum{j in E[i]} x2[j,i] + sum{j in E[i]} x10[j,i] + sum{j in E[i]} x20[j,i] <= 1;

#Maior caminho
s.t. maior: (sum{(i,j) in A} (c1[i,j] * x10[i,j] + c2[i,j] * x20[i,j])) - (sum{(i,j) in A} (c1[i,j] * x1[i,j] + c2[i,j] * x2[i,j])) >= 0;

#Paridade
s.t. paridade: sum{(i,j) in A} x1[i,j] + sum{(i,j) in A} x10[i,j] - sum{(i,j) in A} x2[i,j] - sum{(i,j) in A} x20[i,j] = 0;

#no Fonte
s.t. fonte1{i in O}: sum{j in S[i]} x1[i,j] + sum{j in S[i]} x2[i,j] = 1;
s.t. fonte0{i in O}: sum{j in S[i]} x10[i,j] + sum{j in S[i]} x20[i,j] = 1;
s.t. fonte01{i in O}: sum{j in S[i]} x1[i,j] + sum{j in S[i]} x10[i,j] = 1;

#No Destino
s.t. destino{i in D}: sum{j in S[i]} x1[i,j] + sum{j in S[i]} x2[i,j] + sum{j in S[i]} x10[i,j] + sum{j in S[i]} x20[i,j] = 0;
end;
