;;; $Header: /cvs/programs/videogame-starter/videogame-starter.asm,v 1.6 2004-09-19 22:18:27 david Exp $
;;; -------=====================<<<< COPYRIGHT >>>>========================-------
;;;          Copyright (c) 2001 David Caldwell,  All Rights Reserved.
;;;  See full text of copyright notice and limitations of use in file COPYRIGHT.h
;;; -------================================================================-------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;;                           _______  _______
;;;                          |       \/       |
;;;                    Vdd --+ 1 <<      >> 8 +-- Vss
;;;                          |                |
;;;    CoinOut <= GP5/OSC1 --+ 2 <<      >> 7 +-- GP0 => Player1Out
;;;                          |                |
;;; Player2Out <= GP4/OSC2 --+ 3 <<      << 6 +-- GP1 <= Player1In
;;;                          |                |
;;; Player2In => GP3/!MCLR --+ 4 >>         5 +-- GP2/T0CKI
;;;                          |                |
;;;                          +----------------+

		LIST

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Here are things that should be in a header file somewhere (PIC constants)
GPIO            equ 6

;;; Internal Configuration Fuses
_MCLRE_OFF      equ b'00000000'
_CP_OFF         equ b'00001000'
_WDT_OFF        equ b'00000000'
_INT_OSC        equ b'00000010'

;;; Option register
_GPWU_OFF       equ b'10000000' ; No wake up on GPIO change
_GPPU_ON        equ b'00000000' ; Pullups on GP0,GP1,GP3
_T0CS_INTERNAL  equ b'00000000'
_T0SE_LH        equ b'00000000'
_PSA_Timer0     equ b'00000000'
_PS_Timer0_8    equ b'00000010'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This defines some special fuses that control really global chip configuration.
		__CONFIG (_MCLRE_OFF | _CP_OFF | _WDT_OFF | _INT_OSC)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Here are my constants:
Player1InBit	equ	1
Player2InBit	equ	3
Player1OutBit	equ	0
Player2OutBit	equ	4
CoinOutBit		equ	5
Player1In		equ	(1 << Player1InBit) ;b'00000010'
Player2In		equ	(1 << Player2InBit) ;b'00001000'
Player1Out		equ	(1 << Player1OutBit) ;b'00000001'
Player2Out		equ	(1 << Player2OutBit) ;b'00010000'
CoinOut			equ	(1 << CoinOutBit) ;b'00100000'
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Here are my variables:	
		cblock  0x07
				ms				; Used by delay routine
				i				;  loop counter
		endc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; And now the program starts:	
		org     0x00            ; Start of code space 
start:	
		movlw   b'11111111'     ; Set Every GPIO to tri-state
		tris    GPIO            ;
		clrf	GPIO			; Set the output latch to low

		movlw	(_GPWU_OFF | _GPPU_ON | _T0CS_INTERNAL | _T0SE_LH | _PSA_Timer0 | _PS_Timer0_8)
		option
		;; Let the pullups settle.
		call	delay

main_loop:
		btfss	GPIO,Player1InBit
		 goto	Player1WasPressed
		btfss	GPIO,Player2InBit
		 goto	Player2WasPressed

		goto	main_loop

Player1WasPressed:
		movlw	CoinOut
		call	PulseOutput
		movlw	Player1Out
		call	PulseOutput
		goto	main_loop

Player2WasPressed:
		movlw	CoinOut
		call	PulseOutput
		movlw	CoinOut
		call	PulseOutput
		movlw	Player2Out
		call	PulseOutput
		goto	main_loop

;;; Pass in the bit to clear in W (as a mask, not the bit number)
PulseOutput:
		xorlw	0xFF
		tris	GPIO
		call	delay
		movlw	0xFF
		tris	GPIO
		call	delay
		retlw	0

;;; This will delay 250 ms
delay:
		movlw	D'250'
		goto	dly_ms

;;; Brazely stolen from the Playstation Mod chip code:
;  dly_ms -- entry with number of ms in w (1 to 255)
dly_ms	movwf   ms              ;/
dy_0	movlw   249             ;1ms loop count on 100x series
		movwf	i

dy_1	nop                     ;Delay loop, default is 4 * 249 = 996
		nop
		nop
		nop
		decfsz  i,F
		goto    dy_1

		decfsz  ms,F			;# of 1ms delays
		goto    dy_0

		retlw   0

END

;; $Log: videogame-starter.asm,v $
;; Revision 1.6  2004-09-19 22:18:27  david
;; - New version of gpasm requires an "END".
;;
;; Revision 1.5  2004/09/19 21:44:16  david
;; - Whitespace.
;;
;; Revision 1.4  2004/09/19 21:44:01  david
;; - We have to delay before polling on the inputs because they take some
;;   time to rise.
;;
;; Revision 1.3  2004/09/19 21:42:57  david
;; - Make the delay more accurate.
;;
;; Revision 1.2  2004/09/19 21:42:21  david
;; - This PIC only has a jump stack 2 deep!!! So make some calls into
;;   gotos so we don't overflow.
;;
;; Revision 1.1.1.1  2004/09/19 21:37:32  david
;; - Initial version of the pic to control Amy's Ms. Pac-man cocktail cabinet.
;;

