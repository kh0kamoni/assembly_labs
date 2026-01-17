.MODEL SMALL
.STACK 100H

.DATA
MSG1    DB "FIRST NUMBER: $"
MSG2    DB 10,13,"SECOND NUMBER: $"
MSG3    DB 10,13,"SUM: $"
MSG4    DB 10,13,"DIFF: $"
MINUSS  DB 10,13,"DIFF: -$"

NUM1    DB ?
NUM2    DB ?
; SUM and DIFF should just be handled in registers for printing, 
; but if you want to store them, use registers directly.

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- INPUT 1 ---
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H

    CALL GET_NUM
    MOV NUM1, AL

    ; --- INPUT 2 ---
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H

    CALL GET_NUM
    MOV NUM2, AL

    ; --- CALCULATE SUM (FIXED FOR > 255) ---
    MOV AL, NUM1
    MOV AH, 0       ; Clear High Byte
    ADD AL, NUM2    ; Add numbers
    ADC AH, 0       ; Add Carry (If Result > 255)
    
    PUSH AX         ; Save Sum for a moment
    
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    POP AX          ; Restore Sum (Full AX)
    CALL PRINT

    ; --- CALCULATE DIFFERENCE ---
    MOV AL, NUM1
    CMP AL, NUM2
    JL NEGATIVE

    ; Positive Difference
    SUB AL, NUM2
    MOV BL, AL      ; Save result in BL
    
    MOV AH, 09H
    LEA DX, MSG4
    INT 21H

    MOV AL, BL      ; Move result to AL
    MOV AH, 0       ; Clear AH
    CALL PRINT
    JMP EXIT

NEGATIVE:
    ; Negative Difference
    MOV AL, NUM2
    SUB AL, NUM1
    MOV BL, AL      ; Save result
    
    MOV AH, 09H
    LEA DX, MINUSS
    INT 21H

    MOV AL, BL
    MOV AH, 0
    CALL PRINT

EXIT:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; --------------------------------------
; GET_NUM (FIXED LOGIC)
; --------------------------------------
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

    CMP AL, '0'
    JL READ
    CMP AL, '9'
    JG READ

    SUB AL, '0'
    MOV CL, AL      ; Store new digit in CL

    MOV AL, BL      ; Move old total to AL
    MOV DL, 10
    MUL DL          ; AX = Total * 10
    
    ADD AL, CL      ; ADD New Digit (Fixed Logic)
    MOV BL, AL      ; Save back to BL

    JMP READ

DONE:
    MOV AL, BL

    POP DX
    POP CX
    POP BX
    RET
GET_NUM ENDP

; --------------------------------------
; PRINT PROC (STANDARD)
; --------------------------------------
PRINT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0
    MOV BX, 10

PUSH_LOOP:
    MOV DX, 0       ; Clear DX for division
    DIV BX          ; AX / 10
    PUSH DX         ; Push Remainder
    INC CX
    CMP AX, 0
    JNE PUSH_LOOP

POP_LOOP:
    POP DX
    ADD DL, '0'
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