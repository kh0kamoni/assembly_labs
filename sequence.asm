.MODEL SMALL
.STACK 100H
.DATA
msg1 db "Enter characters (Enter to stop): $"
msg2 db 10,13,"Sorted: $"
chars db 26 dup('$')
count db 0
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,09H
    LEA DX,msg1
    INT 21H
    
    MOV SI,0
INPUT:
    MOV AH,01H
    INT 21H
    CMP AL,13
    JE ENDINPUT
    MOV chars[SI],AL
    INC SI
    INC count
    CMP SI,26
    JB INPUT
ENDINPUT:
    CMP count,0
    JE EXIT
    
    MOV CH,0
    MOV CL,count
    DEC CX
    JCXZ DISPLAYSORTED
OUTER:
    MOV SI,0
    MOV BL,0
INNER:
    MOV AL,chars[SI]
    MOV DL,chars[SI+1]
    CMP AL,DL
    JBE NOSWAP
    MOV chars[SI],DL
    MOV chars[SI+1],AL
NOSWAP:
    INC SI
    INC BL
    CMP BL,CL
    JB INNER
    LOOP OUTER
    
DISPLAYSORTED:
    MOV AH,09H
    LEA DX,msg2
    INT 21H
    
    MOV AH,09H
    LEA DX,chars
    INT 21H
    
EXIT:
    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN