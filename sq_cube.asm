.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 10, 13, "ENTER A NUMBER: $"
MSG2 DB 10, 13, "SQUARED: $"
MSG3 DB 10, 13, "CUBED: $"
NUM DW ?
SQ DW ?
CUBED DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM
    MOV NUM, AX
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    CALL SQUARE_NUMBER
    
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    CALL CUBE_NUMBER 
    
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

SQUARE_NUMBER PROC
    MOV AX, NUM
    MOV BX, AX
    MUL BX 
    MOV SQ, AX
    CALL PRINT
    RET
SQUARE_NUMBER ENDP

CUBE_NUMBER PROC
    MOV AX, NUM
    MOV BX, AX
    MUL BX
    MUL BX
    MOV CUBED, AX
    CALL PRINT
    RET
CUBE_NUMBER ENDP

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