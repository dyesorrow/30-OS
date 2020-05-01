
16位寄存器
```c
AX      accumulator         累加寄存器
CX      counter             计数寄存器
DX      data                数据寄存器
BX      base                基址寄存器
SP      statck pointer      栈指针寄存器
BP      base pointer        基址指针寄存器
SI      source index        原变址寄存器
DI      destination index   目的变址寄存器
```
8位寄存器
```c
AL      accumulator low     累加寄存器低位
CL      counter low         计数寄存器低位
DL      data low            数据寄存器低位
BL      base low            基址寄存器低位
AH      accumulator high    累加寄存器高位
CH      counter high        计数寄存器高位
DH      data high           数据寄存器高位
BH      base high           基址寄存器高位
```
32位寄存器
```c
EAX 
ECX     
EDX   
EBX  
ESP   
EBP
ESI   
EDI
```

段寄存器(是16位寄存器)
```c
ES      extra segment       附加段寄存器
CS      code segment        代码段寄存器
SS      stack segment       栈段寄存器
DS      data segment        数据段寄存器
FS      segment part 2
GS      segment part 3
```


```c
DB          define byte     往文件写入1个字节指令
    eg:
    DB  0x90
    DB  0, 0, 0x29

RESB       reserve byte    写入指定个数的 0x00
    eg:
    RESB    18
    RESB    0x7dfe-$        ;填写0x00直到0x7dfe, $表示现在的字数

DW          define word             word表示16位，2个字节
    eg:
    DW  512

DD          define double-word      double-word表示32位，4个字节
    eg:
    DD  0
    DD  0xffffffff

MOV 复制
    eg:
    MOV BX, DX
    MOV BYTE [678], 123         ; 用内存'678'号地址保存"123", 8位
    MOV WORD [678], 123         ; '678'和旁边的地址'679'都会做出反应, 一共16位来存储。
                                ; 00000000 01111011 其中 00000000 保存在高位'679'
                                ; 01111011 保存在低位 '678'
                                ; 对是反过来的
    MOV AL, BYTE [BX]
    MOV AL, BYTE [SI]           ; 将SI地址的1字节类容读入AL
    MOV AL, [SI]                ; MOV指令源数据和目的数据必须位数相同，所以可以省略 BYTE




ADD 加法指令
    eg: 
    ADD SI, 1

CMP 比较指令
JMP 跳转
    eg: 
    CMP AL, 0
    JMP fin

    相当于
    if(AL==0){
        goto fin;
    }

HLT CPU停止
```

启动区内容装载地址
```c
0x00007c00 - 0x00007dff
```