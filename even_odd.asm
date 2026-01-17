.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB "ENTER A NUMBER: $"
MSG2 DB 10, 13, "THIS IS AN ODD NUMBER. $"
MSG3 DB 10, 13, "THIS IS AN EVEN NUMBER. $"
NUM DW ?
.CODE 
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM
    MOV NUM, AX
    
    ; EVEN OR ODD?
    MOV AX, NUM
    TEST AX, 1
    JZ EVEN
    
    ODD:
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    JMP EXIT
    
    EVEN:
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    JMP EXIT
    
    EXIT: 
    MOV AH, 4CH
    MOV AL, 0
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


END MAIN