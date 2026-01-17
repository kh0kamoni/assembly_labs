.MODEL SMALL
.STACK 100H
.DATA
MSG_INPUT DB "ENTER A STRING: $"
MSG_V     DB 10, 13, "VOWELS: $"
MSG_C     DB 10, 13, "CONSONANTS: $"

V_COUNT   DW 0      
C_COUNT   DW 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    MOV AH, 09H
    LEA DX, MSG_INPUT
    INT 21H
    
    
    READ_LOOP:
        MOV AH, 01H
        INT 21H
        
        CMP AL, 13      
        JE DONE_INPUT
        
        
        CMP AL, 'A'
        JL READ_LOOP    
        
        CMP AL, 'z'
        JG READ_LOOP    
        
        CMP AL, 'Z'
        JBE CONVERT_LOWER 
        
        CMP AL, 'a'
        JGE CHECK_VOWEL   
        
        JMP READ_LOOP   
        
    CONVERT_LOWER:
        ADD AL, 32      
        
    CHECK_VOWEL:
        
        CMP AL, 'a'
        JE IS_VOWEL
        CMP AL, 'e'
        JE IS_VOWEL
        CMP AL, 'i'
        JE IS_VOWEL
        CMP AL, 'o'
        JE IS_VOWEL
        CMP AL, 'u'
        JE IS_VOWEL
        
        
        JMP IS_CONSONANT
        
    IS_VOWEL:
        INC V_COUNT
        JMP READ_LOOP
        
    IS_CONSONANT:
        INC C_COUNT
        JMP READ_LOOP
        
    DONE_INPUT:
    
    
    MOV AH, 09H
    LEA DX, MSG_V
    INT 21H
    
    MOV AX, V_COUNT
    CALL PRINT
    
   
    MOV AH, 09H
    LEA DX, MSG_C
    INT 21H
    
    MOV AX, C_COUNT
    CALL PRINT
    
   
    MOV AH, 4CH
    MOV AL, 0
    INT 21H
    
MAIN ENDP


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