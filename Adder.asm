;This is a program that adds two 2-bit numbers together and stores them in memory.
	
;*********************************************************
; EQUATES SECTION (Note 'EQU' is a so-called 'pseudo op' meaning that it is an instruction to the assembler program only,
; NOT to the PIC). The purpose of these 'EQU' instructions is to give locations names rather than having to use the 
; actual addresses in the program.  

	
STATUS		EQU	3				;means STATUS is file 3.	
PORTA		EQU	5				;means PORTA  is file 5.	
PORTB		EQU	6				;means PORTB is file 6.
TRISA		EQU	85H           	;TRISA (the PORTA I/O selection) is file 85H
TRISB		EQU	86H           	;TRISB (the PORTB I/O selection) is file 86H
ADCON1		EQU 9FH

;*********************************************************
 LIST	P=16F819	; we are using the 16F819. (another pseudo-op so the assembler knows what the target processor is)

;**********************************************************************
; Configuration Bits. 

 __CONFIG H'3F70'   	;selects LP oscillator, WDT off, PUT on, Code Protection disabled.
			;This is a special instruction to the programmer to set some special bits in the PIC.


 		ORG		0		;the start address in memory is 0 ie the assembler will start arranging 
						;instructions from this location (this is another pseudo-op)
 		GOTO	START			;goto start of program (this is the first 'real' instruction).

;CONFIGURATION SECTION

START	BSF		STATUS,5	;Set accesses to Bank1.

		MOVLW	B'00001111'	;set the 4 relevant bits of PORTA to be inputs 
		MOVWF	TRISA		;(Actually they are set as inputs anyway on reset so this isn't strictly necessary.)

		MOVLW	B'11110000'       		
		MOVWF	TRISB		;set all the bits in PORTB to be outputs

		MOVLW	B'00000110'	;Set all port configuration control bits to be digital
		MOVWF	ADCON1

		BCF	STATUS,5	;Reset accesses to Bank0.

;Business bit of program

LOOP	MOVF    PORTA,0		;Fetches the contents of port A into the W register
	
		; Taking the first two bits of the number and stoirng it to memory (at 21H)
		MOVWF	20H
		ANDLW   B'00000011'
		MOVWF	21H
		
		; Seperating the second pair of bits and storing them to memory (at 22H)
		MOVF	20H,0		;Moving original number back to w-register
		ANDLW   B'00001100'
		MOVWF	22H	

		; Placing the second pair of bits into the two LSB's, then storing it to memory (at 22H)
		RRF		22H,1
		RRF		22H,1	
		MOVF	22H,0
		ANDLW   B'00000011'	;And operation in case a carry of 1 was ever produced
		MOVWF	22H			

	;----------------------------------------------------------------------;
		CLRW

	LOOP2
		;Return back to here repeatedly
		ADDWF 21H,0		;Adding Frist number to itself via w-register
	

		DECFSZ 22H,1	;Decrement (second number)-1 by '1', if '0' it will stop loop
		GOTO LOOP2
		
	;----------------------------------------------------------------------;
	

		MOVWF   PORTB		; The value read from port A will now be output to port B

		GOTO LOOP		; Keep doing it indefinitely. (Note that you cant just stop a program)

		END			; This is another 'pseudo op' to tell the assembler program that that is all.


