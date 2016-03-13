#!/bin/bash

NASM_FILE=./NASM

# Check for executable file
if [ -e "$NASM_FILE" ]; then
	echo "2 Pass assembler 8086 --> TESTING"
	echo ""
else
	echo "File <NASM> not found!"
	exit 1
fi

# Test all files in tests/ directory

for asmfile in tests/*.asm; do
	echo "Testing <$asmfile>"
	echo "=================="
	echo ""

	./NASM $asmfile
	echo ""
done