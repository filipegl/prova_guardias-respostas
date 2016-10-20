#!/bin/bash
# coding: utf-8
# Caso exista um arquivo nomeado "temp.txt" no diretório deste script ele será removido.
# Cada função se refere a um item do exercício.

function soma_CPU()
{
	cpu_soma=0

	for linha in $(awk '{print $3}' temp.txt); do
		cpu_soma=$(echo "$cpu_soma + $linha" | bc)
	done

	echo "
O valor de %CPU total encontrado a cada observação feita foi: $cpu_soma"
}

function soma_MEM()
{
	mem_soma=0

	for linha in $(awk '{print $4}' temp.txt); do
		mem_soma=$(echo "$mem_soma + $linha" | bc)
	done

	echo "
O valor de %MEM total encontrado a cada observação feita foi: $mem_soma"
}

function maiormenor_CPU()
{
	maior_cpu=0
	menor_cpu=99999

	for linha in $(awk '{print $3}' temp.txt); do
		linha=$(echo "$linha * 10" | bc | cut -d'.' -f1)
		if [ $linha -gt $maior_cpu ]; then
			maior_cpu=$linha
		fi
		if [ $linha -lt $menor_cpu ]; then
			menor_cpu=$linha
		fi
	done

	maior_cpu=$(echo "$maior_cpu * 0.1" | bc)
	menor_cpu=$(echo "$menor_cpu * 0.1" | bc)

	echo "
O maior valor de %CPU encontrado foi: $maior_cpu"
	echo "
O menor valor de %CPU encontrado foi: $menor_cpu"
}

function maiormenor_MEM()
{
	maior_mem=0
	menor_mem=99999

	for linha in $(awk '{print $4}' temp.txt); do
		linha=$(echo "$linha * 10" | bc | cut -d'.' -f1)
		if [ $linha -gt $maior_mem ]; then
			maior_mem=$linha
		fi
		if [ $linha -lt $menor_mem ]; then
			menor_mem=$linha
		fi
	done

	maior_mem=$(echo "$maior_mem * 0.1" | bc)
	menor_mem=$(echo "$menor_mem * 0.1" | bc)

	echo "
O maior valor de %MEM encontrado foi: $maior_mem"
	echo "
O menor valor de %MEM encontrado foi: $menor_mem"
}

function maior_tempo_CPU()			#Funcionalidade adicional.
{
	tempo=$(awk '{if ($10 != "TIME") print $10}' temp.txt | sort -g | tail -n1)
	min=$(awk '{if ($10 != "TIME") print $10}' temp.txt | sort -g | tail -n1 | cut -d: -f1)
	seg=$(awk '{if ($10 != "TIME") print $10}' temp.txt | sort -g | tail -n1 | cut -d: -f2)
	processo=$(egrep ""$tempo" [^0-9]" temp.txt | awk '{print $11}' | tail -n1)

	echo -ne "\nProcesso com mais tempo de CPU acumulado(TIME): \n"
	echo "O processo $processo está com o tempo acumulado de $min minuto(s) e $seg segundo(s).
"
}

# Entradas
if [ $# -lt 3 ]; then 

	read -p "Número de observações: " obs
	if [ "$obs" = '' ] || [ $obs -le 0 ]; then
		exit 1	
	fi

	read -p "Intervalo de tempo em segundos: " segundos
	if [ "$segundos" = '' ] || [ $segundos -le 0 ]; then
		exit 1
	fi

	read -p "Um começo de nome de um usuário: " nome
	if [ "$nome" = '' ]; then
		exit 1
	fi
else
	obs=$1
	segundos=$2
	nome=$3
fi
# Fim de entradas

if [ -e temp.txt ]; then
	rm temp.txt
fi

echo ""
for ((contador=0; contador<$obs; contador=contador+1)); do
	ps -aux | grep "^$nome"
	(ps -aux | grep "^$nome") >> temp.txt
	sleep $segundos 
done

if [ -s temp.txt ]; then
	soma_CPU
	soma_MEM
	maiormenor_CPU
	maiormenor_MEM
	maior_tempo_CPU
else
	exit 2
fi

rm -f temp.txt
