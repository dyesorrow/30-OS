; haribote-os
; TAB=4

		ORG		0xc200			; ?���������v�푕?�I�n��

		MOV		AL,0x13			; VGA ??�C320x200x8�ʐF��
		MOV		AH,0x00
		INT		0x10
fin:
		HLT
		JMP		fin
