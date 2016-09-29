#!/bin/bash
# coding: utf-8

if [ $# -lt 3 ]; then 
	read -p "Número de observações: " obs
	if [ "$obs" = '' ] || [ $obs -le 0 ]; then
		exit 1	
	fi
	read -p "Intervalo de tempo em segundos: " seg
	if [ "$seg" = '' ] || [ $seg -le 0 ]; then
		exit 1
	fi
	read -p "Um começo de nome de um usuário" nome
	if [ "$nome" = '' ]; then
		exit 1
	fi
fi
rm temp.txt
for ((n=0; n<$obs; n=n+1)); do
	echo $(ps -aux | grep "^$nome")
	echo $(ps -aux | grep "^$nome") >> temp.txt
	sleep $seg 
if [ -s temp.txt ]; then
#programa
else
exit 2
fi

