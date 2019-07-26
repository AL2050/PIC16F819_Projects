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
ADCON0		EQU 1FH
PIE1		EQU	8CH
PIR1		EQU	0CH

ADRESH		EQU 1EH
LIGHTS 		EQU 18H
;*********************************************************
 LIST	P=16F819	; we are using the 16F819. (another pseudo-op so the assembler knows what the target processor is)

;**********************************************************************
; Configuration Bits. 

 __CONFIG H'3F18'  	;selects internal RC oscillator, WDT off, PUT on, Code Protection disabled.
					;This is a special instruction to the programmer to set some special bits in the PIC.


 		ORG		0				;the start address in memory is 0 ie the assembler will start arranging 
								;instructions from this location (this is another pseudo-op)
       	GOTO	START			;goto start of program (this is the first 'real' instruction).

	


START	BSF		STATUS,5		;Set accesses to Bank1.


		MOVLW	B'11111111'		;set PORTA to be inputs
		MOVWF	TRISA			;(Actually they are set as inputs anyway on reset so this isn't strictly necessary.)

		MOVLW	B'00000000'       		
		MOVWF	TRISB			;set all the bits in PORTB to be outputs

		MOVLW	B'00000000'		;Set AN0 to AN4 (ie PA0 - PA4) as digital inputs
		MOVWF	ADCON1

		BCF		STATUS,5		;Reset accesses to Bank0 because PORTA and PORTB are in Bank 0


		; Select bank 0 for ADCON0
		MOVLW	B'01000001' 	;Activate A/D converter; Using AN0 (Channel 0); Using RC Oscillator
		MOVWF	ADCON0
		
		;Starting A/D conversion
LOOP	BCF		PIR1,6 			;Disabling A/D conversion completion bit so conversion can take place
		
		;BSF 	INTCON,7 		;Global interrupt

		BSF 	STATUS,5 		; Moving to Bank1
		;BSF	PIE1,6 			;Enables the A/D converter interrupt

		NOP	;
		NOP
		NOP

		BCF 	STATUS,5 		;Returning to Bank0
		BSF		ADCON0,2 		;Initiate A/D conversion here


		NOP
		NOP
		NOP

		MOVF 	ADRESH,0 		;MSBs of output are moved to PORTB to be displayed on LEDs as binary
		MOVWF 	PORTB
		
;GOTO LOOP
;---------------------------------------------------------------------
;EXERCISE 2
;---------------------------------------------------------------------
	TABLE	ADDWF	PC			;W-reg assigned to PCL, corresponding to the relevant index in TABLE
								;to be outputted through PORTB.
			RETLW	B'1111110'
			RETLW	B'0110000'
			RETLW	B'1101101'
			RETLW	B'1111001'
			RETLW	B'0110011'
			RETLW	B'1011011'


			MOVWF 	LIGHTS

			BTFSC 	LIGHTS,7
			GOTO 	SUBROUTINE1
			BTFSC 	LIGHTS,6
			GOTO 	SUBROUTINE2
			BTFSC 	LIGHTS,5
			GOTO 	SUBROUTINE3
			GOTO 	SUBROUTINE4

		
	
SUBROUTINE1	BTFSC 	LIGHTS,6
			MOVLW 	B'00000101'
			BTFSC 	LIGHTS,6
			GOTO 	TABLE
			MOVLW 	B'00000100'
			GOTO 	TABLE
		

SUBROUTINE2	MOVLW 	B'00000011'
			GOTO 	TABLE


SUBROUTINE3	MOVLW 	B'00000010'
			GOTO 	TABLE


SUBROUTINE4	MOVLW 	B'00000001'
			GOTO 	TABLE

END