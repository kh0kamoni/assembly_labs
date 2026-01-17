.MODEL SMALL
.STACK 100H
.DATA
MSG_COUNT DB "HOW MANY NUMBERS? $"
MSG_INPUT DB 10, 13, "ENTER NUMBER: $"
MSG_ASC   DB 10, 13, "ASCENDING: $"
MSG_DESC  DB 10, 13, 10, 13, "DESCENDING: $"
SPACE     DB " $"

ARRAY     DB 20 DUP(?)  
COUNT     DB ?          

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    MOV AH, 09H
    LEA DX, MSG_COUNT
    INT 21H
    
    CALL GET_NUM
    MOV COUNT, AL       
    
    
    MOV CL, COUNT
    MOV CH, 0
    MOV SI, 0           
    
    INPUT_LOOP:
        PUSH CX         
        
        MOV AH, 09H
        LEA DX, MSG_INPUT
        INT 21H
        
        CALL GET_NUM    
        MOV ARRAY[SI], AL 
        
        INC SI          
        POP CX          
    LOOP INPUT_LOOP
    
  
    CALL SORT_ASC
    
    MOV AH, 09H
    LEA DX, MSG_ASC
    INT 21H
    
    CALL PRINT_ARRAY
    
   
    CALL SORT_DESC
    
    MOV AH, 09H
    LEA DX, MSG_DESC
    INT 21H
    
    CALL PRINT_ARRAY
    

    MOV AH, 4CH
    MOV AL, 0
    INT 21H
    
MAIN ENDP


SORT_ASC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV CL, COUNT
    DEC CL          
    
    OUTER_ASC:
        MOV SI, 0
        MOV CH, COUNT
        DEC CH     
        
        INNER_ASC:
            MOV AL, ARRAY[SI]
            MOV BL, ARRAY[SI+1]
            
            CMP AL, BL
            JBE NO_SWAP_ASC  
            
           
            MOV ARRAY[SI], BL
            MOV ARRAY[SI+1], AL
            
        NO_SWAP_ASC:
            INC SI
            DEC CH
            JNZ INNER_ASC
            
        DEC CL
        JNZ OUTER_ASC
        
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SORT_ASC ENDP


SORT_DESC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV CL, COUNT
    DEC CL
    
    OUTER_DESC:
        MOV SI, 0
        MOV CH, COUNT
        DEC CH
        
        INNER_DESC:
            MOV AL, ARRAY[SI]
            MOV BL, ARRAY[SI+1]
            
            CMP AL, BL
            JAE NO_SWAP_DESC
            
  
            MOV ARRAY[SI], BL
            MOV ARRAY[SI+1], AL
            
        NO_SWAP_DESC:
            INC SI
            DEC CH
            JNZ INNER_DESC
            
        DEC CL
        JNZ OUTER_DESC
        
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
SORT_DESC ENDP


PRINT_ARRAY PROC
    PUSH CX
    PUSH SI
    PUSH AX
    PUSH DX
    
    MOV CL, COUNT
    MOV CH, 0
    MOV SI, 0
    
    PRINT_LOOP:
        MOV AL, ARRAY[SI]
        MOV AH, 0
        CALL PRINT
        
        
        MOV AH, 09H
        LEA DX, SPACE
        INT 21H
        
        INC SI
    LOOP PRINT_LOOP
    
    POP DX
    POP AX
    POP SI
    POP CX
    RET
PRINT_ARRAY ENDP

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