; hello-os
; TAB=4
CYLS EQU 10 ;������n

        ORG    0x7c00           ;�w�������I��?�n��
; �ȉ��I?�q�p��?�yFAT12�i���I??

        JMP     entry           ;��??�s�������
        DB      0x90
        DB      "HELLOIPL"      ;??��I���̉Ȑ��C�ӓI�������i8����?�j
        DW      512             ;?�����(sector)�I�召(�K??512��?)
        DB      1               ;��(cluster)�召�i�K?��1�����j
        DW      1               ;FAT�I�N�n�ʒu(��ʐ�����꘢���?�n)
        DB      2               ;FAT�I�����i�K??2�j
        DW      224             ;����?�召(���?��224?)
        DW      2880            ;?��?�I�召(�K?��2880���)
        DB      0xf0            ;��?�I??(�K?��0xf0)
        DW      9               ;FAT�I?�x�i�K?��9���j
        DW      18              ;1������(track)�L�{�����(�K?��18)
        DW      2               ;��?���i�K?��2�j
        DD      0               ;�s�g�p����i�K?��0�j
        DD      2880            ;�d?�ʈꎟ��?�召
        DB      0, 0, 0x29      ;��?�s���C�Œ�
        DD      0xffffffff      ;(�\��)��?��?
        DB      "HELLO-OS   "   ;��?����(11��?)
        DB      "FAT12   "      ;��?�i������(8��?)
        RESB   18              ;���o18��?

;�������
entry:
        MOV     AX, 0           ;���n���񑶊�
        MOV     SS, AX          ;
        MOV     SP, 0x7c00
        MOV     DS, AX
        
;?�接?
        MOV     AX, 0x0820
        MOV     ES, AX
        MOV     CH, 0           ;����0
        MOV     DH, 0           ;��?0
        MOV     CL, 2           ;���2

readloop:
        MOV     SI, 0           ;??��?�����I�񑶊�

retry:
        MOV     AH, 0x02        ;AH=0x02??
        MOV     AL, 1           ;1�����
        MOV     BX, 0           ;
        MOV     DL, 0x00        ;A??��
        INT     0x13            ;?�p��?BIOS
        JNC     next            ;�v�L�o?�A��?��next, �R�@???��
        ADD     SI, 1           ;SI�Y��1
        CMP     SI, 5           ;��?SI�^5
        JAE     error           ;SI >= 5?��?�� error
        MOV     AH, 0x00
        MOV     DL, 0x00
        INT     0x13
        JMP     retry
        
next:
        ;�������n���@��0x200
        MOV     AX, ES          
        ADD     AX, 0x0020
        MOV     ES, AX          

        ADD     CL, 1
        CMP     CL, 18
        ;�@��CL<=18,��?��readloop�C???��
        JBE     readloop        
        ;��?���CL?��1�C��?DH��1
        MOV     CL, 1
        ADD     DH, 1
        ;�@�ʎ�?DH <2, ��? readloop,???��
        CMP     DH, 2
        JB      readloop
        ;��?�C��?DH?�u��0,����CH??1
        MOV     DH, 0
        MOV     CH, 1
        CMP     CH, CYLS
        JB      readloop
;??�@�C?�sharibote.sys�I
        MOV     [0x0ff0], CH    ;?��IPL?������
        JMP     0xc200

error:
        MOV     SI, msg

fin:    
        HLT                     ;?cpu��~�C���Ҏw��
        JMP     fin             ;��?�z?

msg:
        DB      0x0a, 0x0a		; ���s��2��
        DB      "load error"
        DB      0x0a			; ���s
        DB      0
        RESB    0x7dfe-$		; 0x7dfe�܂ł�0x00�Ŗ��߂閽��
        DB      0x55, 0xaa
        