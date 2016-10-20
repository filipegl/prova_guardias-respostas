#!/bin/bash
# coding: utf-8
# Para o funcionamento do script, é necessário que este esteja no mesmo diretório das atividades. 
# E também que não haja nenhum arquivo no diretório deste script chamado "temp.txt" e temp2.txt"
# (Caso existam, serão removidos).
# A funcionalidade adicional é uma lista dos alunos que acertaram e erraram.

function certo_ou_errado(){

	diferenca=$(diff temp.txt EXERCICIO_"$n_exercicio"_$num_teste.out)

	if [ "$diferenca" != "" ]; then
		echo "ERRADO $nome_script" >> temp2.txt
	else
		echo "CERTO $nome_script" >> temp2.txt
	fi
}

chmod u+x EXERCICIO_*.sh
if [ "$#" -eq "2" ]; then
	n_exercicio=$1				# Número do exercício
	aluno=$2					# Nome do Aluno 
	qtd_exercicio=$n_exercicio	# A diferença das duas variáveis mais um ($qtd_exercicios - $n_exercicios + 1) é a quantidade de repetições do while.

elif [ "$#" -eq "1" ]; then
	n_exercicio=$1
	aluno="*"
	qtd_exercicio=$n_exercicio

else
	qtd_exercicio=$(ls -1 EXERCICIO_*.sh | cut -d'_' -f2 | sort | tail -n1) # Quantidade de exercícios disponíveis
	aluno="*"
	n_exercicio=1 	# Este número irá crescendo +1 até chegar no valor de $qtd_exercicios.
fi

if [ -e temp2.txt ]; then
	rm -f temp2.txt
fi

while [ $n_exercicio -le $qtd_exercicio ]; do
	for nome_script in $(ls -1 EXERCICIO_"$n_exercicio"_$aluno.sh | cut -d'.' -f1); do

		num_teste=1 	# Contador dos testes. Vai de 1 até o número de testes disponíveis.

		for teste in $(ls -1 EXERCICIO_"$n_exercicio"_*.in); do

			echo "$nome_script: "
			echo "- SAÍDA PARA ENTRADA $num_teste: "

			./$nome_script.sh < $teste > temp.txt
			cat temp.txt

			echo "
- DIFERENÇA PARA A SAÍDA ESPERADA: "

			diff temp.txt EXERCICIO_"$n_exercicio"_$num_teste.out

			certo_ou_errado

			echo ""
			(( num_teste++ ))
		done
	done
	(( n_exercicio++ ))
done

echo "----------------------------------"
echo -ne "RESUMO: \n\n"
sort temp2.txt | uniq

rm -f temp2.txt
rm -f temp.txt
