;A pulse width modulation program which changed the duty cycle based on a 4bit input to the program.
	
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

PR2		EQU 92H
T2CON		EQU 12H

CCPR1L		EQU 15H
CCP1CON		EQU 17H

;*********************************************************
 LIST	P=16F819	; we are using the 16F819. (another pseudo-op so the assembler knows what the target processor is)

;**********************************************************************
; Configuration Bits. 

 __CONFIG H'3F70'   	;selects LP oscillator, WDT off, PUT on, Code Protection disabled.
			


 		ORG		0		;the start address in memory is 0 ie the assembler will start arranging 
						;instructions from this location (this is another pseudo-op)
 		GOTO	START			;goto start of program (this is the first 'real' instruction).

;CONFIGURATION SECTION

START	BSF		STATUS,5	;Set accesses to Bank1.

		MOVLW	B'11110000'	;set the 4 relevant bits of PORTA to be inputs 
		MOVWF	TRISA		
		MOVLW	B'00000000'       		
		MOVWF	TRISB		;set all the bits in PORTB to be outputs

		MOVLW	B'00000110'	;set all port configuration control bits to be digital
		MOVWF	ADCON1

		MOVLW	B'11111111'	;Initialises PR2 for use
		MOVWF	PR2

		BCF	STATUS,5	;Reset accesses to Bank0


		MOVLW	B'00000100'	;Enables timer2, no prescaler or postscaler
		MOVWF	T2CON

		MOVLW	B'00001100'	;Sets the CCP1CON to PWM mode
		MOVWF	CCP1CON

		

;Business bit of program

LOOP	
		MOVF PORTA,0
		

		MOVWF CCPR1L	;The bits moved to CCPR1l will be the MSBs and have the largest impact on the duty cycle
				;These bits will move the duty cycle from about 5% to about 95%

		GOTO LOOP


END			

