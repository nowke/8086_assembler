import re

OBJ_FILE = "output.obj"
SYMTAB_FILE = "intermediates/SYMTAB.txt"

def pass2():
    f_sym = open(SYMTAB_FILE, "r")
    f_obj = open(OBJ_FILE, "r")

    # Build symbol table
    symtable = {}
    for symbol in f_sym:
        s = symbol.split()
        symtable[s[0]] = s[1]

    obj_code = f_obj.read()

    matchObj = re.findall(r"\<[a-zA-Z0-9]+\>", obj_code)
    for match in matchObj:
        symbol = match[1:-1]
        obj_code = obj_code.replace(match, symtable[symbol])

    f_sym.close()
    f_obj.close()

    with open(OBJ_FILE, "w") as f:
        f.write(obj_code)

if __name__ == '__main__':
    pass2()
