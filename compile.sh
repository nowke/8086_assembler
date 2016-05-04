#!/bin/bash

# Compile 8086 assembler code from src/

## Clean working directory
./clean.sh

## Make Director `intermediates` if not exists
mkdir -p intermediates

lex src/tokens.l

## Handle Debug mode
if [ -n "$1" ]; then
	if [[ $1 = '--debug' ]]; then
		yacc -d --verbose --debug src/grammar.y
	fi
else
	yacc -d src/grammar.y
fi

cc lex.yy.c y.tab.c -ll -o NASM

## Remove intermediates
rm -f lex.yy.c y.tab.c y.tab.h
