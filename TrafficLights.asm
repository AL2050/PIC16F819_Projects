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

 __CONFIG H'3F70'  	;selects internal RC oscillator, WDT off, PUT on, Code Protection disabled.
			;This is a special instruction to the programmer to set some special bits in the PIC.


 		ORG		0			;the start address in memory is 0 ie the assembler will start arranging 
							;instructions from this location (this is another pseudo-op)
       	GOTO	START		;goto start of program (this is the first 'real' instruction).

;CONFIGURATION SECTION
		
		ORG		4
		GOTO 	INTRPT	;Start placing instructions at location 4 when the interrupt is recognised
						;by the program

	


START	BSF		STATUS,5		;Set accesses to Bank1.
		
		BCF 	OPTION_REG,3	;Assign prescaler to TMR0 module

		BSF		OPTION_REG,2
		BCF 	OPTION_REG,1
		BCF 	OPTION_REG,0 	;Prescale TMR0 rate to be 1:32

		BCF 	OPTION_REG,5	;Utilising internal instruction cycle clock

		
		
		

		MOVLW	B'11111111'		;set PORTA to be inputs (done by default)
		MOVWF	TRISA

		MOVLW	B'00000000'     ;set all the bits in PORTB to be outputs		
		MOVWF	TRISB

		MOVLW	B'00111111'		;Set AN0 to AN4 (ie PA0 - PA4) as digital inputs
		MOVWF	ADCON1

		BCF		STATUS,5		;Reset accesses to Bank0 because PORTA and PORTB are in Bank 0


		



;Traffic light operation

		MOVLW 	8
		MOVWF 	INDEX		;INDEX is given a starting value of '8' for the eight logic states in the
							;lookup table TABLE.

		BSF		INTCON,7	;Enabling Global interrupts
		BSF		INTCON,5	;Allow for TMR0 interrupts

NEXT	MOVF 	INDEX,0		;Place INDEX value into W-reg
		CALL 	TABLE
		MOVWF 	PORTB		;Output relevant value from TABLE subroutine
		
		GOTO 	NEXT		;Repeat operation
		


TABLE	ADDWF	PC			;Literal added to W-Reg determined by Program Counter
		NOP					;NOP to account for INDEX starting at literal '8', not '7'
		RETLW	B'00100100'
		RETLW	B'00110100'	
		RETLW	B'00001100'	
		RETLW	B'00010100'		
		RETLW	B'00100100'	
		RETLW	B'00100110'	
		RETLW	B'00100001'
		RETLW	B'00100010'

	

INTRPT	MOVF	WTEMP		;Save W-Reg
		SWAPF	STATUS,0	;Move status register into W-reg and save
		MOVWF	STATEMP
		BCF 	INTCON,	2	;Preventing interrupt from overflowing in operation

		DECFSZ 	INDEX
		GOTO 	RECOVER

		MOVLW 	8
		MOVWF 	INDEX

RECOVER	SWAPF	STATEMP,0	;Move saved status into W-reg and correct nibbles
		MOVWF	STATUS		;Restore STATUS to pre-interrupt condition
		SWAPF	WTEMP,1		;Restore W-reg without afecting the STATUS
		SWAPF	WTEMP,0
			
			RETFIE			;ecover return address from stack and carry on
END