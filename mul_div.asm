.MODEL SMALL
.STACK 100H
.DATA
MSG1    DB 10, 13, "ENTER FIRST NUMBER: $"
MSG2    DB 10, 13, "ENTER SECOND NUMBER: $"
MSG_MUL DB 10, 13, "MULTIPLICATION: $"
MSG_DIV DB 10, 13, "DIVISION: $"

NUM1    DB ?
NUM2    DB ?
REM     DB ?

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
    

    MOV AH, 09H
    LEA DX, MSG_MUL
    INT 21H
    
    MOV AL, NUM1
    MOV BL, NUM2
    MUL BL          
    CALL PRINT
    

    MOV AH, 09H
    LEA DX, MSG_DIV
    INT 21H
    
    MOV AL, NUM1
    MOV AH, 0
    MOV BL, NUM2
    
    CMP BL, 0      
    JE EXIT
    
    DIV BL     
    
    MOV REM, AH    
    MOV AH, 0       
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
    

    MOV BL, REM   
    MOV CX, 2       
    
    DECIMAL_LOOP:
    MOV AL, BL      
    MOV AH, 0       
    MOV DL, 10
    MUL DL          
    
    MOV DL, NUM2    
    DIV DL          
    
    MOV BL, AH      
    
    ; Print the Digit
    MOV DL, AL
    ADD DL, "0"
    MOV AH, 02H
    INT 21H
    
    LOOP DECIMAL_LOOP 
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
PRINT_DECIMAL ENDP

END MAIN