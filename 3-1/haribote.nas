; haribote-os
; TAB=4

		ORG		0xc200			; ?个程序将要被装?的地方

		MOV		AL,0x13			; VGA ??，320x200x8位色彩
		MOV		AH,0x00
		INT		0x10
fin:
		HLT
		JMP		fin
