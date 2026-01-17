.MODEL SMALL
.STACK 100H
.DATA
MSG1    DB 10, 13, "ENTER FIRST NUMBER: $"
MSG2    DB 10, 13, "ENTER SECOND NUMBER: $"
MSG_MUL DB 10, 13, "MULTIPLICATION: $"
MSG_DIV DB 10, 13, "DIVISION: $"

NUM1    DW ?
NUM2    DW ?
REM     DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM
    MOV NUM1, AX
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    CALL GET_NUM
    MOV NUM2, AX
    
    ; MULTIPLICATION
    MOV AH, 09H
    LEA DX, MSG_MUL
    INT 21H
    
    MOV AX, NUM1
    MOV BX, NUM2
    MUL BX
    CALL PRINT
    
    ; DIVISION
    MOV AH, 09H
    LEA DX, MSG_DIV
    INT 21H
    
    MOV AX, NUM1
    MOV BX, NUM2
    
    CMP BX, 0
    JE EXIT
    
    MOV DX, 0
    DIV BX
    
    MOV REM, DX
    CALL PRINT
    
    CALL PRINT_DECIMAL
    
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

PRINT_DECIMAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AH, 02H
    MOV DL, "."
    INT 21H
    
    MOV AX, REM
    MOV CX, 2
    
    DECIMAL_LOOP:
    MOV DX, 10
    MUL DX
    
    MOV BX, NUM2
    MOV DX, 0
    DIV BX
    
    PUSH DX
    
    MOV DL, AL
    ADD DL, "0"
    MOV AH, 02H
    INT 21H
    
    POP AX
    
    LOOP DECIMAL_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
PRINT_DECIMAL ENDP

END MAIN