; hello-os
; TAB=4
CYLS EQU 10 ;声明常熟

        ORG    0x7c00           ;指明程序的装载地址
; 以下的记述用于标准FAT12格式的软盘

        JMP     entry           ;跳转执行程序主体
        DB      0x90
        DB      "HELLOIPL"      ;启动区的名称可以是任意的字符串（8个字节）
        DW      512             ;每个扇区(sector)的大小(必须为512字节)
        DB      1               ;簇(cluster)大小（必须是1个扇区）
        DW      1               ;FAT的起始位置(一般是从第一个扇区开始)
        DB      2               ;FAT的个数（必须为2）
        DW      224             ;根目录大小(一般设成224项)
        DW      2880            ;该磁盘的大小(必须是2880扇区)
        DB      0xf0            ;磁盘的种类(必须是0xf0)
        DW      9               ;FAT的长度（必须是9扇区）
        DW      18              ;1个磁道(track)有几个扇区(必须是18)
        DW      2               ;磁头数（必须是2）
        DD      0               ;不使用分区（必须是0）
        DD      2880            ;重复写一次磁盘大小
        DB      0, 0, 0x29      ;意义不明，固定
        DD      0xffffffff      ;(可能是)卷标号码
        DB      "HELLO-OS   "   ;磁盘名称(11字节)
        DB      "FAT12   "      ;磁盘格式名称(8字节)
        RESB   18              ;先空出18字节

;程序主体
entry:
        MOV     AX, 0           ;初始化寄存器
        MOV     SS, AX          ;
        MOV     SP, 0x7c00
        MOV     DS, AX
        
;读取磁盘
        MOV     AX, 0x0820
        MOV     ES, AX
        MOV     CH, 0           ;柱面0
        MOV     DH, 0           ;磁头0
        MOV     CL, 2           ;扇区2

readloop:
        MOV     SI, 0           ;记录失败次数的寄存器

retry:
        MOV     AH, 0x02        ;AH=0x02读盘
        MOV     AL, 1           ;1个扇区
        MOV     BX, 0           ;
        MOV     DL, 0x00        ;A驱动器
        INT     0x13            ;调用磁盘BIOS
        JNC     next            ;没有出错就跳转到next, 然后继续读取
        ADD     SI, 1           ;SI添加1
        CMP     SI, 5           ;比较SI与5
        JAE     error           ;SI >= 5时跳转到 error
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
        ;如果CL<=18,跳转至readloop，继续读取
        JBE     readloop        
        ;否则扇区CL调到1，磁头DH加1
        MOV     CL, 1
        ADD     DH, 1
        ;如果磁头DH <2, 跳转 readloop,继续读取
        CMP     DH, 2
        JB      readloop
        ;否则，磁头DH设置位0,柱面CH设为1
        MOV     DH, 0
        MOV     CH, 1
        CMP     CH, CYLS
        JB      readloop

        MOV     [0x0ff0], CH    ;
        JMP     0xc200

error:
        MOV     SI, msg

fin:    
        HLT                     ;让cpu停止，等待指令
        JMP     fin             ;无线循环

msg:
        DB      0x0a, 0x0a		; 改行を2つ
        DB      "load error"
        DB      0x0a			; 改行
        DB      0
        RESB    0x7dfe-$		; 0x7dfeまでを0x00で埋める命令
        DB      0x55, 0xaa
        