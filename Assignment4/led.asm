cpu "8085.tbl"
hof "int8"

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH

org 9000h 

MVI A,8BH		;setting 8255 to mode0 and port A o/p and port B,C i/p
MVI B,01H
OUT 03H
START:
	IN 01H		; [A] <- IN from 8255 port B
	CMA
	CPI 04H		; compare immediate with 04H (continuing condition)
	JZ CONT
	ANI 40H		; logical and 40H with content of A 
	CPI 40H		; 40H is ending condition 
	JZ END	
	JMP START
CONT:
	MOV A,B
	OUT 00H
	MOV A,B
	RLC			; rotste(in cyclic fashion) content of A to left by one 
	MOV B,A
	IN 01H		
	CMA
	ANI 08H
	CPI 08H		
	JZ START	
	IN 01H
	CMA
	ANI 40H		; logical and 40H with content of A 
	CPI 40H		; 40H is ending condition 
	JZ END
	CALL DELAY	; delay function for 1sec delay
	JMP CONT
END: 	RST 5	;end of program
DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,0AF00H
INLOOP:
	DCX D		; decrease the D-E pair by one
	MOV A,D
	ORA E		; logical or with content of A
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET