.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB "ENTER A NUMBER (0-8): $"
MSG2 DB 10, 13, "FACTORIAL: $"
NUM  DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM    
    MOV NUM, AL
    
    
    MOV AH, 0
    MOV CX, AX      
    MOV AX, 1       
    
    CMP CX, 0       
    JE PRINT_RESULT 
    
    
    FACT_LOOP:
        MUL CX      
        LOOP FACT_LOOP 
        
    
    PRINT_RESULT:
    PUSH AX         
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    POP AX          
    CALL PRINT
    
    
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

END MAIN