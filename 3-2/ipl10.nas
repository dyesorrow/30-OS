; hello-os
; TAB=4
CYLS EQU 10 ;º¾ín

        ORG    0x7c00           ;w¾öI?n¬
; ÈºI?qp°?yFAT12i®I??

        JMP     entry           ;µ??söåÌ
        DB      0x90
        DB      "HELLOIPL"      ;??æI¼ÌÂÈ¥CÓIøi8¢?j
        DW      512             ;?¢îæ(sector)Iå¬(K??512?)
        DB      1               ;âÆ(cluster)å¬iK?¥1¢îæj
        DW      1               ;FATINnÊu(êÊ¥¸æê¢îæ?n)
        DB      2               ;FATI¢iK??2j
        DW      224             ;ªÚ?å¬(êÊ?¬224?)
        DW      2880            ;?¥?Iå¬(K?¥2880îæ)
        DB      0xf0            ;¥?I??(K?¥0xf0)
        DW      9               ;FATI?xiK?¥9îæj
        DW      18              ;1¢¥¹(track)L{¢îæ(K?¥18)
        DW      2               ;¥?iK?¥2j
        DD      0               ;sgpªæiK?¥0j
        DD      2880            ;d?Êê¥?å¬
        DB      0, 0, 0x29      ;Ó?s¾CÅè
        DD      0xffffffff      ;(Â\¥)É??
        DB      "HELLO-OS   "   ;¥?¼Ì(11?)
        DB      "FAT12   "      ;¥?i®¼Ì(8?)
        RESB   18              ;æóo18?

;öåÌ
entry:
        MOV     AX, 0           ;n»ñ¶í
        MOV     SS, AX          ;
        MOV     SP, 0x7c00
        MOV     DS, AX
        
;?æ¥?
        MOV     AX, 0x0820
        MOV     ES, AX
        MOV     CH, 0           ;Ê0
        MOV     DH, 0           ;¥?0
        MOV     CL, 2           ;îæ2

readloop:
        MOV     SI, 0           ;??¸?Iñ¶í

retry:
        MOV     AH, 0x02        ;AH=0x02??
        MOV     AL, 1           ;1¢îæ
        MOV     BX, 0           ;
        MOV     DL, 0x00        ;A??í
        INT     0x13            ;?p¥?BIOS
        JNC     next            ;vLo?Aµ?next, R@???æ
        ADD     SI, 1           ;SIYÁ1
        CMP     SI, 5           ;ä?SI^5
        JAE     error           ;SI >= 5?µ? error
        MOV     AH, 0x00
        MOV     DL, 0x00
        INT     0x13
        JMP     retry
        
next:
        ;«à¶n¬@Ú0x200
        MOV     AX, ES          
        ADD     AX, 0x0020
        MOV     ES, AX          

        ADD     CL, 1
        CMP     CL, 18
        ;@ÊCL<=18,µ?readloopC???æ
        JBE     readloop        
        ;Û?îæCL?1C¥?DHÁ1
        MOV     CL, 1
        ADD     DH, 1
        ;@Ê¥?DH <2, µ? readloop,???æ
        CMP     DH, 2
        JB      readloop
        ;Û?C¥?DH?uÊ0,ÊCH??1
        MOV     DH, 0
        MOV     CH, 1
        CMP     CH, CYLS
        JB      readloop
;??@C?sharibote.sysI
        MOV     [0x0ff0], CH    ;?ºIPL?¹½­
        JMP     0xc200

error:
        MOV     SI, msg

fin:    
        HLT                     ;?cpuâ~CÒwß
        JMP     fin             ;Ù?z?

msg:
        DB      0x0a, 0x0a		; üsð2Â
        DB      "load error"
        DB      0x0a			; üs
        DB      0
        RESB    0x7dfe-$		; 0x7dfeÜÅð0x00Åßé½ß
        DB      0x55, 0xaa
        