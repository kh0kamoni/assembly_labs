.MODEL SMALL
.STACK 100H
.DATA
NUM DW ?
PRIMEE DB 10, 13, "THIS IS A PRIME NUMBER.$"
COMPOSITE DB 10, 13, "THIS IS A COMPOSITE NUMBER.$"
PROMPT DB 10, 13, "ENTER A NUMBER: $"

.CODE 
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H  
    LEA DX, PROMPT
    INT 21H
    
    CALL GET_NUM
    MOV NUM, AX
    
PRIME_CHECK:
    MOV AX, NUM
    CMP AX, 0
    JE NOT_PRIME
    CMP AX, 1
    JE NOT_PRIME
    CMP AX, 2
    JE IS_PRIME

    MOV CX, 2

DIV_LOOP:
    MOV AX, NUM
    MOV DX, 0
    DIV CX
    CMP DX, 0
    JE NOT_PRIME
    
    INC CX
    MOV AX, CX
    CMP AX, NUM
    JL DIV_LOOP
    
IS_PRIME:
    MOV AH, 09H
    LEA DX, PRIMEE
    INT 21H 
    JMP EXIT
    
NOT_PRIME:
    MOV AH, 09H
    LEA DX, COMPOSITE
    INT 21H   
    
EXIT:
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

GET_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, 0
    
    READ:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 13
    JE DONE
    
    CMP AL, "0"
    JL READ
    
    CMP AL, "9"
    JG READ
    
    SUB AL, "0"
    
    MOV CL, AL
    MOV CH, 0
    
    MOV AX, BX
    MOV DX, 10
    MUL DX
    ADD AX, CX
    MOV BX, AX
    JMP READ 
    
    DONE:
    MOV AX, BX
    
    POP DX
    POP CX
    POP BX
    
    RET
GET_NUM ENDP

PRINT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0
    MOV BX, 10
    
    PUSH_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX
    
    INC CX
    CMP AX, 0
    JNE PUSH_LOOP
    
    POP_LOOP:
    POP DX
    ADD DL, "0"
    MOV AH, 02H
    INT 21H
    
    LOOP POP_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
PRINT ENDP

END MAIN