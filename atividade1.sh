# coding: uft-8
#!/bin/bash
#OBS: O arquivo "access_log" precisa estar no mesmo diretório deste script.
# ------------------------------------------------------------------------------------------
#4)
grep -e " - - " access_log > temp.txt
mv temp.txt access_log

#5)
#a) ----------------------------------------------------------------------------------------
linhas1=$(grep -e 'local' access_log | wc -l)
echo "a) Quantas requisições locais foram feitas? $linhas1"

#b) ----------------------------------------------------------------------------------------
linhas2=$(grep -e 'remote' access_log | wc -l)
echo "b) Quantas requisições remotas foram feitas? $linhas2"

#c) ----------------------------------------------------------------------------------------
grep -e 'local' access_log > temp.txt
soma1=0

for num in $(cut -d: -f2 temp.txt); do
	soma1=$(expr $num + $soma1)
done

media1=$(expr $soma1 / $linhas1)

echo "c) Em média, qual a hora em que as requisições locais são feitas? $media1 horas"

#d) ----------------------------------------------------------------------------------------
grep -e 'remote' access_log > temp.txt
soma2=0

for num in $(cut -d: -f2 temp.txt); do
	soma2=$(expr $num + $soma2)
done

media2=$(expr $soma2 / $linhas2)

echo "d) Em média, qual a hora em que as requisições remotas são feitas? $media2 horas"

#-------------------------------------------------------------------------------------------
#6)
#funcionalidades
echo "-------
Extras: 
-------"
#1 -----------------------------------------------------------------------------------------
if [ $linhas1 -gt $linhas2 ]; then
	sub=$(expr $linhas1 - $linhas2)
	echo "Existem $sub requisições locais a mais que requisições remotas.
"
elif [ $linhas2 -gt $linhas1 ]; then
	sub=$(expr $linhas2 - $linhas1)
	echo "Existem $sub requisições remotas a mais que requisições locais.
"
else
	echo "O número de requisições locais é igual ao número de requisições remotas.
"
fi

#2 média dos tamanhos -----------------------------------------------------------------------
soma=0
linhas=0
for tam in $(awk '{if ($NF != "-") print $NF}' access_log); do
		soma=$(expr $soma + $tam)
done
linhas=$(awk '{if ($NF != "-") print $NF}' access_log | wc -l)
media=$(expr $soma / $linhas)
echo "A média dos tamanhos das requisições é aproximadamente $media.
"

#3 data do dia que mais ocorreu requisição --------------------------------------------------
maior=0
for dia in {1..31}; do
	qtd=$(grep -e "$dia/" access_log | wc -l)
	if [ $qtd -gt $maior ]; then
		maior=$qtd
		maiordia=$dia
	fi
done
echo "O dia $maiordia (idependente do mês) foi o dia que mais requisições foram feitas.
"

#4 hora do dia que mais ocorreu requisição ---------------------------------------------------
maior=0
for hora in {0..23}; do
	qtd=$(grep "$hora:[0-6][0-9]:" access_log | wc -l)
	if [ $qtd -gt $maior ]; then
		maior=$qtd
		maiorhr=$hora
	fi
done
echo "O horário do dia mais acessado (idependente da data) foi à(s) $maiorhr hora(s).
"


