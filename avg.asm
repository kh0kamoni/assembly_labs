.MODEL SMALL
.DATA
MSG1 DB "FIRST NUMBER: $"
MSG2 DB 10, 13, "SECOND NUMBER: $"
NUM1 DB ?
NUM2 DB ?
AVG DB ?
REM DB ?
MSG3 DB 10, 13, "AVERAGE: $"
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM
    MOV NUM1, AL
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    CALL GET_NUM
    MOV NUM2, AL
    
    MOV AL, NUM1
    MOV AH, 0
    ADD AL, NUM2
    MOV BL, 2
    DIV BL
    MOV AVG, AL
    MOV REM, AH
    
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    MOV AL, AVG
    CALL PRINT
    

    CALL PRINT_REM

    
    MOV AH, 4CH
    MOV AL, 0
    INT 21H
    
MAIN ENDP

GET_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, 0
    MOV CX, 0
    
    INPUT:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 13
    JE DONE
    
    CMP AL, "0"
    JL INPUT
    
    CMP AL, "9"
    JG INPUT
    
    SUB AL, "0"
    MOV CL, AL
    MOV AL, BL
    MOV DL, 10
    MUL DL
    ADD AL, CL
    MOV BL, AL
    JMP INPUT
    
    DONE:
    MOV AL, BL
    
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
    MOV BL, 10
    
    PUSH_LOOP:
    MOV AH, 0
    DIV BL
    PUSH AX
    
    INC CX
    CMP AL, 0
    JNE PUSH_LOOP
    
    POP_LOOP:
    POP DX
    MOV DL, DH
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


PRINT_REM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    

    MOV AH, 02H
    MOV DL, "."
    INT 21H
    

    MOV AL, REM     
    MOV AH, 0       
    MOV BL, 10      
    MUL BL          
    
    MOV BL, 2       
    DIV BL         
    

    MOV DL, AL
    ADD DL, "0"    
    MOV AH, 02H
    INT 21H
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
PRINT_REM ENDP

END MAIN