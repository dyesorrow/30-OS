; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; �����?�����I�͎�
[BITS 32]						; ����32�ʖ͎��p�I���B?��


; �����?�����I�M��

[FILE "naskfunc.nas"]			; ���������M��

		GLOBAL	_io_hlt			; ��������ܓI������


; �ȉ���??����

[SECTION .text]		; ��?�����ʗ�?���V�@�Ďʒ���

_io_hlt:	; void io_hlt(void);
		HLT
		RET
