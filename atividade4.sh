#!/bin/bash
# coding: utf-8
# Caso exista um arquivo nomeado "temp.txt" no diretório deste script ele será removido.

strace -To temp.txt $* 

#Syscalls de maior tempo

tempo1=$(cut -d"<" -f2 temp.txt | cut -d">" -f1 | grep "^[0-9]" | sort | tail -n1)
tempo2=$(cut -d"<" -f2 temp.txt | cut -d">" -f1 | grep "^[0-9]" | sort | tail -n2 | head -n1)
tempo3=$(cut -d"<" -f2 temp.txt | cut -d">" -f1 | grep "^[0-9]" | sort | tail -n3 | head -n1)

echo -ne "\nSyscall de maior tempo($tempo1): \n"
for syscall1 in $(egrep ""$tempo1">$" temp.txt | cut -d"(" -f1 | sort | uniq); do
	echo "	$syscall1"
done

echo "Syscall de segundo maior tempo($tempo2): "
for syscall2 in $(egrep ""$tempo2">$" temp.txt | cut -d"(" -f1 | sort | uniq); do
	echo "	$syscall2"
done

echo "Syscall de terceiro maior tempo($tempo3): "
for syscall3 in $(egrep ""$tempo3">$" temp.txt | cut -d"(" -f1 | sort | uniq); do
	echo "	$syscall3"
done

#Syscall com mais erros

erro_sys=$(grep "= -" temp.txt | cut -d"(" -f1 | sort | uniq -c | sort -g | tail -n1 | awk '{print $2}')
qtd_erro_sys=$(grep "= -" temp.txt | cut -d"(" -f1 | sort | uniq -c | sort -g | tail -n1 | awk '{print $1}')

echo -ne "\nSyscall com mais erros: \n"
echo "A syscall $erro_sys contém $qtd_erro_sys erros. "

#Syscall mais chamada

chamada_sys=$(cut -d"(" -f1 temp.txt | sort | uniq -c | sort -g | awk '{print $2}' | tail -n1)
qtd_chamada_sys=$(cut -d"(" -f1 temp.txt | sort | uniq -c | sort -g | awk '{print $1}' | tail -n1)

echo -ne "\nSyscall mais chamada: \n"
echo "A syscall $chamada_sys possui $qtd_chamada_sys chamadas.
"

rm -f temp.txt
