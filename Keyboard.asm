; Example 1. This sets PORTA as an INPUT (NB 1 means input)
; and PORTB as an OUTPUT  (NB 0 means output). The contents of port A (5 least significant bits)are then transferred to port B
; A semi-colon means that everything on the line after the semi-colon is a comment for the benefit of humans and has no 
; significance to the PIC.
	
;*********************************************************
; EQUATES SECTION (Note 'EQU' is a so-called 'pseudo op' meaning that it is an instruction to the assembler program only,
; NOT to the PIC). The purpose of these 'EQU' instructions is to give locations names rather than having to use the 
; actual addresses in the program.  

	
STATUS		EQU	3H				;means STATUS is file 3.
OPTION_REG	EQU 1H
INTCON		EQU 0BH	
WTEMP		EQU 20H
STATEMP		EQU	21H
INDEX 		EQU 22H
PC			EQU 2H
PORTA		EQU	5H				;means PORTA  is file 5.	
PORTB		EQU	6H				;means PORTB is file 6.
TRISA		EQU	85H           	;TRISA (the PORTA I/O selection) is file 85H
TRISB		EQU	86H           	;TRISB (the PORTB I/O selection) is file 86H
ADCON1	 	EQU 9FH				;ADCON1 is 9FH

;*********************************************************
 LIST	P=16F819	; we are using the 16F819. (another pseudo-op so the assembler knows what the target processor is)

;**********************************************************************
; Configuration Bits. 

 __CONFIG H'3F18'  	;selects internal RC oscillator, WDT off, PUT on, Code Protection disabled.
			;This is a special instruction to the programmer to set some special bits in the PIC.


 		ORG		0		;the start address in memory is 0 ie the assembler will start arranging 
						;instructions from this location (this is another pseudo-op)
       		GOTO	START			;goto start of program (this is the first 'real' instruction).

;CONFIGURATION SECTION
		
		ORG		4
		GOTO 	INTRPT

	


START	BSF	STATUS,5	;Set accesses to Bank1.
		BCF OPTION_REG,3

		BCF	OPTION_REG,0
		BSF	OPTION_REG,1
		BCF	OPTION_REG,2

		BCF OPTION_REG,5
		BCF OPTION_REG,7
		
		
		

		MOVLW	B'00000000'	;set PORTA to be outputs
		MOVWF	TRISA		;(Actually they are set as inputs anyway on reset so this isn't strictly necessary.)

		MOVLW	B'11111111'       		
		MOVWF	TRISB		;set all the bits in PORTB to be inputs

		MOVLW	B'00111111'	;Set AN0 to AN4 (ie PA0 - PA4) as digital inputs
		MOVWF	ADCON1

		BCF	STATUS,5	;Reset accesses to Bank0 because PORTA and PORTB are in Bank 0


		



;Business bit of program

		

	
		
	

		


SEGMENT_TABLE	ADDWF	PC
				RETLW	B'1111110'
				RETLW	B'0110000'	
				RETLW	B'1101101'	
				RETLW	B'1111001'		
				RETLW	B'0110011'	
				RETLW	B'1011011'	
				RETLW	B'1011111'
				RETLW	B'1110000'
				RETLW	B'1111111'		
				RETLW	B'1110011'
				RETLW	B'0110111'
				RETLW	B'0001111'				

	





;------------------------------------------------------------
;zero all columns
BCF	PORTB,0
BCF	PORTB,1
BCF	PORTB,2

;Check if any R is a zero
BTFSS	PORTB,4
GOTO SUBROUTINE1

BTFSS	PORTB,5
GOTO SUBROUTINE2

BTFSS	PORTB,6
GOTO SUBROUTINE3

BTFSS	PORTB,7
GOTO SUBROUTINE4

SUBROUTINE1

		BCF PORTB,0
		BSF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,4
		MOVLW B'00000010'

		BSF PORTB,0
		BCF PORTB,1
		BSF PORTB,2	
		BTFSS PORTB,4
		MOVLW B'00000011'

		BSF PORTB,0
		BSF PORTB,1
		BCF PORTB,2
		BTFSS PORTB,4
		MOVLW B'00000100'

		

		CALL SEGMENT_TABLE
		MOVWF PORTA
		BSF	INTCON,7
		BSF	INTCON,5

SUBROUTINE2
		BCF PORTB,0
		BSF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,5
		MOVLW B'00000101'

		BSF PORTB,0
		BCF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,5
		MOVLW B'00000110'

		BSF PORTB,0
		BSF PORTB,1
		BCF PORTB,2
		BTFSS PORTB,5
		MOVLW B'00000111'

		

		CALL SEGMENT_TABLE
		MOVWF PORTA
		BSF	INTCON,7
		BSF	INTCON,5

SUBROUTINE3
		BCF PORTB,0
		BSF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,6
		MOVLW B'00001000'

		BSF PORTB,0
		BCF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,6
		MOVLW B'00001001'

		BSF PORTB,0
		BSF PORTB,1
		BCF PORTB,2
		BTFSS PORTB,6
		MOVLW B'00001010'

		

		CALL SEGMENT_TABLE
		MOVWF PORTA
		BSF	INTCON,7
		BSF	INTCON,5

SUBROUTINE4
		BCF PORTB,0
		BSF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,7
		MOVLW B'00001011'

		BSF PORTB,0
		BCF PORTB,1
		BSF PORTB,2
		BTFSS PORTB,7
		MOVLW B'00000001'

		BSF PORTB,0
		BSF PORTB,1
		BCF PORTB,2
		BTFSS PORTB,7
		MOVLW B'00001100'

		

		CALL SEGMENT_TABLE
		MOVWF PORTA
		BSF	INTCON,7
		BSF	INTCON,5

;------------------------------------------------------------



INTRPT		MOVF	WTEMP
			SWAPF	STATUS,0
			MOVWF	STATEMP
			BCF INTCON,2
			;		.
			;		.
			;DO INTERUPT
			;		.
			;		.
			SWAPF	STATEMP,0
			MOVWF	STATUS
			SWAPF	WTEMP,1
			SWAPF	WTEMP,0
			RETFIE
END