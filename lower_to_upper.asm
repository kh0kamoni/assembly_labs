.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB "UPPERCASE: $"
MSG2 DB 10, 13, "LOWERCASE: $"
BUFFER DB 100, ?, 100 DUP("$")

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    

    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    MOV AH, 0AH
    LEA DX, BUFFER  
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
              
    MOV CL, [BUFFER + 1] 
    MOV CH, 0 
    
    CMP CL, 0
    JE EXIT
    
    LEA SI, BUFFER + 2            
    
    PRINT_UPPER:
    MOV DL, [SI] 
    
    CMP DL, "a"
    JB NOT_LETTER
    
    CMP DL, "z"
    JA NOT_LETTER
    
    SUB DL, 32
    MOV AH, 02H
    INT 21H 
    
    INC SI
    
    LOOP PRINT_UPPER
    JMP EXIT
    
    NOT_LETTER:
    MOV AH, 02H
    INT 21H 
    
    INC SI 
    
    LOOP PRINT_UPPER
    
    EXIT:
    MOV AH, 4CH
    MOV AL, 0
    INT 21H
    
MAIN ENDP
END MAIN
        
    