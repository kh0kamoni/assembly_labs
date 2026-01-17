.MODEL SMALL
.STACK 100H
.DATA 

STRING1         DB 10, 13, "ENTER STRING 1: $"
STRING2         DB 10, 13, "ENTER STRING 2: $"
REVERSED        DB 10, 13, "REVERSED STRING 1: $" 
EQ              DB 10, 13, "TWO STRINGS ARE EQUAL$"
NEQ             DB 10, 13, "TWO STRINGS ARE NOT EQUAL$" 
LENGTH_PROMPT   DB 10, 13, "STRING1 LENGTH: $"

; --- FIX: Correct Buffer Structure for INT 21H / 0AH ---
; Byte 1: Max Length (100)
; Byte 2: Actual Length (Filled by input)
; Bytes 3+: The String
BUFFER1         DB 100, ?, 100 DUP("$")  
BUFFER2         DB 100, ?, 100 DUP("$")
REV_BUFFER      DB 100 DUP("$")

.CODE 
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; --- Input String 1 ---
    MOV AH, 09H
    LEA DX, STRING1
    INT 21H
    
    MOV AH, 0AH
    LEA DX, BUFFER1
    INT 21H
    
    ; --- Input String 2 ---
    MOV AH, 09H
    LEA DX, STRING2
    INT 21H
    
    MOV AH, 0AH
    LEA DX, BUFFER2
    INT 21H    
    
    ; ==========================================
    ; FIX: FULL STRING COMPARISON LOGIC
    ; ==========================================
    
    ; 1. COMPARE LENGTHS
    MOV AL, [BUFFER1 + 1]   ; Length of String 1
    MOV BL, [BUFFER2 + 1]   ; Length of String 2
    CMP AL, BL
    JNE NOT_EQUAL           ; If lengths differ, they are not equal
    
    ; 2. COMPARE CHARACTERS
    MOV CL, AL              ; Load length into Loop Counter
    MOV CH, 0
    LEA SI, BUFFER1 + 2     ; Start of String 1
    LEA DI, BUFFER2 + 2     ; Start of String 2
    
CHECK_LOOP:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE NOT_EQUAL           ; If any char differs, stop
    
    INC SI
    INC DI
    LOOP CHECK_LOOP
    
    ; If loop finishes, strings are Equal
    JMP EQUAL 

EQUAL: 
    MOV AH, 09H
    LEA DX, EQ
    INT 21H
    JMP REV
    
NOT_EQUAL:
    MOV AH, 09H
    LEA DX, NEQ
    INT 21H
    JMP REV
      
      
REV:  
    MOV CL, [BUFFER1 + 1]   ; Get length
    MOV CH, 0
    LEA SI, BUFFER1 + 2     ; Start of text
    LEA DI, REV_BUFFER
    
PUSH_LOOP: 
    MOV BL, [SI]
    MOV BH, 0
    PUSH BX
    INC SI
    LOOP PUSH_LOOP 
    
    MOV CL, [BUFFER1 + 1]
    MOV CH, 0
    
POP_LOOP:
    POP AX
    MOV [DI], AL
    INC DI
    LOOP POP_LOOP
    
    MOV [DI], "$"           ; Add terminator

PRINT:
    ; Print Reversed String
    MOV AH, 09H
    LEA DX, REVERSED
    INT 21H
    
    MOV AH, 09H
    LEA DX, REV_BUFFER
    INT 21H 
    
    ; Print Length
    MOV AH, 09H
    LEA DX, LENGTH_PROMPT
    INT 21H
    
    MOV CL, [BUFFER1 + 1]
    MOV CH, 0
    MOV AX, CX
    
    MOV CX, 0
    MOV BX, 10

CONVERT_LOOP:
    XOR DX, DX
    DIV BX
    ADD DL, '0'
    PUSH DX
    INC CX
    
    CMP AX, 0
    JNE CONVERT_LOOP
    
PRINT_LOOP:
    POP DX
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP
    
    MOV AH, 4CH
    INT 21H    

MAIN ENDP
END MAIN