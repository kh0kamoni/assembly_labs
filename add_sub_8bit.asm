.MODEL SMALL
.STACK 100H

.DATA
MSG1    DB "FIRST NUMBER: $"
MSG2    DB 10,13,"SECOND NUMBER: $"
MSG3    DB 10,13,"SUM: $"
MSG4    DB 10,13,"DIFF: $"
MINUSS  DB 10,13,"DIFF: -$"

NUM1    DW ?
NUM2    DW ?

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

  
    MOV AX, NUM1
    ADD AX, NUM2
    
    PUSH AX
    
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    POP AX
    CALL PRINT

  
    MOV AX, NUM1
    CMP AX, NUM2
    JL NEGATIVE

   
    SUB AX, NUM2
    PUSH AX
    
    MOV AH, 09H
    LEA DX, MSG4
    INT 21H

    POP AX
    CALL PRINT
    JMP EXIT

NEGATIVE:
   
    MOV AX, NUM2
    SUB AX, NUM1
    PUSH AX
    
    MOV AH, 09H
    LEA DX, MINUSS
    INT 21H

    POP AX
    CALL PRINT

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