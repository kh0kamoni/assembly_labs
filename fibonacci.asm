.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 10, 13, "ENTER HOW MANY FIBONACCI NUMBERS TO GENERATE: $"
    MSG2 DB 10, 13, "FIBONACCI SERIES: $"
    NEWLINE DB 10, 13, "$"
    SPACE DB " $"
    COUNT DW ?
    FIRST DW 0
    SECOND DW 1
    NEXT DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    CALL GET_NUM
    MOV COUNT, AX
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    CMP COUNT, 0
    JE EXIT_PROGRAM
    
    MOV AX, FIRST
    CALL PRINT
    
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    
    CMP COUNT, 1
    JE EXIT_PROGRAM
    
    MOV AX, SECOND
    CALL PRINT
    
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    
    MOV CX, COUNT
    SUB CX, 2
    CMP CX, 0
    JLE EXIT_PROGRAM
    
FIBONACCI_LOOP:
    MOV AX, FIRST
    ADD AX, SECOND
    MOV NEXT, AX
    
    CALL PRINT
    
    PUSH AX
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    POP AX
    
    MOV AX, SECOND
    MOV FIRST, AX
    MOV AX, NEXT
    MOV SECOND, AX
    
    LOOP FIBONACCI_LOOP
    
EXIT_PROGRAM:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
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