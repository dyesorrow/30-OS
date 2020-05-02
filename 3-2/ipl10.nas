; hello-os
; TAB=4
CYLS EQU 10 ;声明常熟

        ORG    0x7c00           ;指明程序的装?地址
; 以下的?述用于?准FAT12格式的??

        JMP     entry           ;跳??行程序主体
        DB      0x90
        DB      "HELLOIPL"      ;??区的名称可以是任意的字符串（8个字?）
        DW      512             ;?个扇区(sector)的大小(必??512字?)
        DB      1               ;簇(cluster)大小（必?是1个扇区）
        DW      1               ;FAT的起始位置(一般是从第一个扇区?始)
        DB      2               ;FAT的个数（必??2）
        DW      224             ;根目?大小(一般?成224?)
        DW      2880            ;?磁?的大小(必?是2880扇区)
        DB      0xf0            ;磁?的??(必?是0xf0)
        DW      9               ;FAT的?度（必?是9扇区）
        DW      18              ;1个磁道(track)有几个扇区(必?是18)
        DW      2               ;磁?数（必?是2）
        DD      0               ;不使用分区（必?是0）
        DD      2880            ;重?写一次磁?大小
        DB      0, 0, 0x29      ;意?不明，固定
        DD      0xffffffff      ;(可能是)卷?号?
        DB      "HELLO-OS   "   ;磁?名称(11字?)
        DB      "FAT12   "      ;磁?格式名称(8字?)
        RESB   18              ;先空出18字?

;程序主体
entry:
        MOV     AX, 0           ;初始化寄存器
        MOV     SS, AX          ;
        MOV     SP, 0x7c00
        MOV     DS, AX
        
;?取磁?
        MOV     AX, 0x0820
        MOV     ES, AX
        MOV     CH, 0           ;柱面0
        MOV     DH, 0           ;磁?0
        MOV     CL, 2           ;扇区2

readloop:
        MOV     SI, 0           ;??失?次数的寄存器

retry:
        MOV     AH, 0x02        ;AH=0x02??
        MOV     AL, 1           ;1个扇区
        MOV     BX, 0           ;
        MOV     DL, 0x00        ;A??器
        INT     0x13            ;?用磁?BIOS
        JNC     next            ;没有出?就跳?到next, 然后???取
        ADD     SI, 1           ;SI添加1
        CMP     SI, 5           ;比?SI与5
        JAE     error           ;SI >= 5?跳?到 error
        MOV     AH, 0x00
        MOV     DL, 0x00
        INT     0x13
        JMP     retry
        
next:
        ;将内存地址后移0x200
        MOV     AX, ES          
        ADD     AX, 0x0020
        MOV     ES, AX          

        ADD     CL, 1
        CMP     CL, 18
        ;如果CL<=18,跳?至readloop，???取
        JBE     readloop        
        ;否?扇区CL?到1，磁?DH加1
        MOV     CL, 1
        ADD     DH, 1
        ;如果磁?DH <2, 跳? readloop,???取
        CMP     DH, 2
        JB      readloop
        ;否?，磁?DH?置位0,柱面CH??1
        MOV     DH, 0
        MOV     CH, 1
        CMP     CH, CYLS
        JB      readloop
;??后，?行haribote.sys！
        MOV     [0x0ff0], CH    ;?下IPL?了多少
        JMP     0xc200

error:
        MOV     SI, msg

fin:    
        HLT                     ;?cpu停止，等待指令
        JMP     fin             ;无?循?

msg:
        DB      0x0a, 0x0a		; 改行を2つ
        DB      "load error"
        DB      0x0a			; 改行
        DB      0
        RESB    0x7dfe-$		; 0x7dfeまでを0x00で埋める命令
        DB      0x55, 0xaa
        