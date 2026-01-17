.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB "ENTER A NUBER: $"
MSG2 DB 10, 13, "THIS IS AN ODD NUMBER. $"
MSG3 DB 10, 13, "THIS IS AN EVEN NUMBER. $"
NUM DB ?
.CODE 
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    
    CALL GET_NUM
    MOV NUM, AL
    
    ; EVEN OR ODD?
    MOV AL, NUM
    TEST AL, 1
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
    
    MOV CX, 0
    MOV BX, 0
    
    INPUT_LOOP:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 13
    JE DONE
    
    CMP AL, "0"
    JL INPUT_LOOP
    
    CMP AL, "9"
    JG INPUT_LOOP
    
    SUB AL, "0"
    MOV CL, AL
    MOV AL, BL
    MOV DL, 10
    MUL DL
    ADD AL, CL
    MOV BL, AL
    JMP INPUT_LOOP
    
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
    
   