#!/bin/bash
# coding: uft-8
# O arquivo "access_log" precisa estar no mesmo diretório deste script.
# Caso exista um arquivo nomeado "temp.txt" no diretório deste script ele será removido.

# 4)
egrep "^(local|remote) - -" access_log > temp.txt
mv temp.txt access_log

# 5)
# a)
qtd_local=$(egrep '^local' access_log | wc -l)
echo "a) Quantas requisições locais foram feitas? $qtd_local"

# b) 
qtd_remote=$(egrep '^remote' access_log | wc -l)
echo "b) Quantas requisições remotas foram feitas? $qtd_remote"

# c)
soma_local=0
horas=$(egrep '^local' access_log | cut -d: -f2)

for num in $horas; do
	soma_local=$(expr $num + $soma_local)
done

media_local=$(echo "$soma_local / $qtd_local" | bc)

echo "c) Em média, qual a hora em que as requisições locais são feitas? $media_local hora(s)"

# d)
soma_remote=0
horas=$(egrep '^remote' access_log | cut -d: -f2)

for num in $horas; do
	soma_remote=$(expr $num + $soma_remote)
done

media_remote=$(echo "$soma_remote / $qtd_remote" | bc)

echo "d) Em média, qual a hora em que as requisições remotas são feitas? $media_remote hora(s)"

# 6)

# Funcionalidades:
echo "-------
Extras: 
-------"

# 1 Diferença de requisições remotas e locais
if [ $qtd_local -gt $qtd_remote ]; then
	sub=$(expr $qtd_local - $qtd_remote)
	echo "Existem $sub requisições locais a mais que requisições remotas.
"
elif [ $qtd_remote -gt $qtd_local ]; then
	sub=$(expr $qtd_remote - $qtd_local)
	echo "Existem $sub requisições remotas a mais que requisições locais.
"
else
	echo "O número de requisições locais é igual ao número de requisições remotas.
"
fi

# 2 Média dos tamanhos 
total=0

for tam in $(awk '{print $NF}' access_log | egrep "^[0-9]{1,}$"); do
		total=$(expr $total + $tam)
done

linhas=$(expr $qtd_local + $qtd_remote)
media=$(echo "scale=2 ; $total / $linhas" | bc)
echo "A média dos tamanhos das requisições é $media.
"

# 3 Dia em que mais/menos ocorreu requisição
maior_dia=$(cut -d"[" -f2 access_log | cut -d":" -f1 | sort -g | uniq -c | sort -g | tail -n1 | awk '{print $2}')

vezes_maior_dia=$(cut -d"[" -f2 access_log | cut -d":" -f1 | sort -g | uniq -c | sort -g | tail -n1 | awk '{print $1}')

menor_dia=$(cut -d"[" -f2 access_log | cut -d":" -f1 | sort -g | uniq -c | sort -g | head -n1 | awk '{print $2}')

vezes_menor_dia=$(cut -d"[" -f2 access_log | cut -d":" -f1 | sort -g | uniq -c | sort -g | head -n1 | awk '{print $1}')

echo "O dia $maior_dia foi o dia em que mais requisições foram feitas, sendo $vezes_maior_dia requisições.
"
echo "O dia $menor_dia foi o dia em que menos requisições foram feitas, sendo $vezes_menor_dia requisições.
"

# 4 Hora do dia que mais ocorreu requisição
maior_hora=$(cut -d: -f2 access_log | sort -g | uniq -c | sort -g | awk '{print $2}' | tail -n1)

echo "O horário do dia mais acessado é às $maior_hora horas.
"
