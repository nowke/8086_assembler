#!/bin/bash
# Replace intermediate object code with final object code

# Read symbol table from intermediates/SYMTAB.txt
# Replace symbols in output.obj

python src/pass2.py
