#include<stdio.h>
#include<string.h>

/* Symbol Table */
struct symtab {
	char label[50];
	int  location;
	struct symtab *next;
};

typedef struct symtab* SYMTAB;

/* Optable */
struct optab {
	char opcode[10];
	char opval[12];
	struct optab *next;
};

typedef struct optab* OPTAB;

/* Object code */
struct obj {
	char code[20];
	struct obj *next;
};

typedef struct obj* OBJ;

SYMTAB initSymTable() {
	SYMTAB symbol = (SYMTAB) malloc(sizeof(struct symtab));
	symbol->next = NULL;

	return symbol;
}

OBJ initObj() {
	OBJ obj = (OBJ) malloc(sizeof(struct obj));
	obj->next = NULL;
	return obj;
}

SYMTAB insertToSymTable(SYMTAB root, const char* label, int location) {

	SYMTAB symbol = (SYMTAB) malloc(sizeof(struct symtab));
	strcpy(symbol->label, label);
	symbol->location = location;
	symbol->next = NULL;

	if (root == NULL) return symbol;

	SYMTAB temp = root;

	while (temp->next != NULL)
		temp = temp->next;

	temp->next = symbol;

	return root;
}

OBJ insertToObj(OBJ root, const char* code) {
	OBJ newObj = initObj();
	strcpy(newObj->code, code);

	if (root == NULL) return newObj;

	OBJ temp = root;
	while (temp->next != NULL)
		temp = temp->next;
	temp->next = newObj;
	return root;
}

void printSymTable(SYMTAB root) {
	if (root == NULL) return;
	if (root->label == NULL) return;

	SYMTAB temp = root;

	printf("\n Label\t Location\n\n");
	temp = temp->next;
	while (temp != NULL) {
		printf(" %s\t  %04X\n", temp->label, temp->location);
		temp = temp->next;
	}
}

void writeSymTable(SYMTAB root) {
	if (root == NULL) return;
	if (root->label == NULL) return;

	FILE* symFile = fopen("intermediates/SYMTAB.txt", "w");

	SYMTAB temp = root;
	temp = temp->next;

	while (temp != NULL) {
		fprintf(symFile, "%s %04X\n", temp->label, temp->location);
		temp = temp->next;
	}
	fclose(symFile);
}

OPTAB newOpcodeEntry() {
	OPTAB op = (OPTAB) malloc(sizeof(struct optab));
	op->next = NULL;

	return op;
}

OPTAB insertToOptable(OPTAB root, char* opcode, char* opval) {
	OPTAB newEntry = newOpcodeEntry();
	// newEntry->opcode = opcode;
	// newEntry->opval = opval;
	strcpy(newEntry->opcode, opcode);
	strcpy(newEntry->opval, opval);
	newEntry->next = root;
	return newEntry;
}

OPTAB initOptable() {
	char opcode[10]; char opval[12];
	int r;
	OPTAB op = newOpcodeEntry();

	FILE* opcodeFile = fopen("src/opcodes.txt", "r");
	r = fscanf(opcodeFile, "%s %s\n", opcode, opval);
	while (r != EOF) {
		// printf("%s %s\n", opcode, opval);
		op = insertToOptable(op, opcode, opval);

		r = fscanf(opcodeFile, "%s %s\n", opcode, opval);
	}

	fclose(opcodeFile);

	return op;
}

char* getOpcodeval(OPTAB root, char* opcode) {
	OPTAB temp = root;
	while (temp != NULL) {
		if (strcmp(temp->opcode, opcode) == 0) {
			return temp->opval;
		}
		temp = temp->next;
	}
	return NULL;
}

void writeObjectCode(OBJ root) {
	if (root == NULL) return;

	FILE* objFile = fopen("output.obj", "w");

	OBJ temp = root;
	temp = temp->next;

	while (temp != NULL) {
		fprintf(objFile, "%s\n", temp->code);
		temp = temp->next;
	}
	fclose(objFile);
}
