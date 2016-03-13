# Pass 1

## Sample Program

```
MYARR DB 10h,20h,30h,40h
MYVAR DW 100

MOV AX,DW
LABEL:
ADD AX,EBX ;
;
```

## Grammar

statement --> line statement

line --> variable eol | 
		 instn eol |
		 label colon eol |
		 eol

variable --> label values

values --> DB bytes