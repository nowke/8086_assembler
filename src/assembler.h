#include<stdio.h>
#include<string.h>

/* Symbol Table */
struct symtab {
	char label[50];
	int  location;
	struct symtab *next;
};

typedef struct symtab* SYMTAB;


SYMTAB initSymTable() {
	SYMTAB symbol = (SYMTAB) malloc(sizeof(struct symtab));
	symbol->next = NULL;

	return symbol;
}

SYMTAB insertToSymTable(SYMTAB root, char* label, int location) {
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