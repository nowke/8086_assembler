# 8086 Assembler
A simple Two-Pass assembler for Intel 8086 architecture

## Important Files
* ***[src/tokens.l](src/tokens.l)*** --> List of all tokens
* ***[src/grammar.y](src/grammar.y)*** --> Grammars for parsing
* ***[src/opcodes.txt](src/opcodes.txt)*** --> List of opcodes for instructions
* ***[src/assembler.h](src/assembler.h)*** --> Helper functions

## How to run?
### Compile
```bash
$ ./compile.sh
```
It will generate an executable file : `NASM`

### Run against sample program
```bash
$ ./NASM tests/prog1.asm
```
Generates an object file `output.obj`
