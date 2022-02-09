
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _k=R5

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0xFF,0xFF,0xFF

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _x
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;unsigned char k=0;
;unsigned long x=0xFFFFFF;

	.DSEG
;//PORTA=((0<<PORTA0) | (0<<PORTA1) | (0<<PORTA2)| (0<<PORTA3) | (0<<PORTA4) | (0<<PORTA5) | (0<<PORTA6) | (0<<PORTA7));
;void chia(){
; 0000 0006 void chia(){

	.CSEG
_chia:
; .FSTART _chia
; 0000 0007      PORTA=x>>16;
	RCALL SUBOPT_0x0
	CALL __LSRD16
	OUT  0x1B,R30
; 0000 0008      PORTC=x>>8;
	LDS  R26,_x
	LDS  R27,_x+1
	LDS  R24,_x+2
	LDS  R25,_x+3
	LDI  R30,LOW(8)
	CALL __LSRD12
	OUT  0x15,R30
; 0000 0009      PORTB=x;
	LDS  R30,_x
	OUT  0x18,R30
; 0000 000A }
	RET
; .FEND
;void portaa(unsigned char tm){
; 0000 000B void portaa(unsigned char tm){
; 0000 000C     PORTA.0=tm>>7;
;	tm -> Y+0
; 0000 000D      PORTA.1=tm>>6;
; 0000 000E      PORTA.2=tm>>5;
; 0000 000F      PORTA.3=tm>>4;
; 0000 0010      PORTA.4=tm>>3;
; 0000 0011      PORTA.5=tm>>2;
; 0000 0012      PORTA.6=tm>>1;
; 0000 0013      PORTA.7=tm;
; 0000 0014 }
;void h_u1(){
; 0000 0015 void h_u1(){
_h_u1:
; .FSTART _h_u1
; 0000 0016     x=~x;
	RCALL SUBOPT_0x1
; 0000 0017     delay_ms(300);
	RCALL SUBOPT_0x2
; 0000 0018     chia();
	RCALL _chia
; 0000 0019 }
	RET
; .FEND
;void h_u2(){
; 0000 001A void h_u2(){
_h_u2:
; .FSTART _h_u2
; 0000 001B     x=0xAAAAAA;
	__GETD1N 0xAAAAAA
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
; 0000 001C     chia();
	RCALL _chia
; 0000 001D     delay_ms(300);
	RCALL SUBOPT_0x2
; 0000 001E     x=~x;
	RCALL SUBOPT_0x1
; 0000 001F     chia();
	RCALL _chia
; 0000 0020     delay_ms(300);
	RCALL SUBOPT_0x2
; 0000 0021 }
	RET
; .FEND
;void h_u3(){
; 0000 0022 void h_u3(){
_h_u3:
; .FSTART _h_u3
; 0000 0023     unsigned char i,j;
; 0000 0024     unsigned char cd,c;
; 0000 0025     cd=0xFF;
	CALL __SAVELOCR4
;	i -> R17
;	j -> R16
;	cd -> R19
;	c -> R18
	LDI  R19,LOW(255)
; 0000 0026     for(i=8;i>0;i--){
	LDI  R17,LOW(8)
_0x15:
	CPI  R17,1
	BRLO _0x16
; 0000 0027         c=0xFE;
	LDI  R18,LOW(254)
; 0000 0028         for(j=0;j<i;j++){
	LDI  R16,LOW(0)
_0x18:
	CP   R16,R17
	BRSH _0x19
; 0000 0029              PORTC=PORTB=c&cd;
	MOV  R30,R19
	AND  R30,R18
	OUT  0x18,R30
	OUT  0x15,R30
; 0000 002A              PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x1A
	CBI  0x1B,0
	RJMP _0x1B
_0x1A:
	SBI  0x1B,0
_0x1B:
; 0000 002B              PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x1C
	CBI  0x1B,1
	RJMP _0x1D
_0x1C:
	SBI  0x1B,1
_0x1D:
; 0000 002C              PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x1E
	CBI  0x1B,2
	RJMP _0x1F
_0x1E:
	SBI  0x1B,2
_0x1F:
; 0000 002D              PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x20
	CBI  0x1B,3
	RJMP _0x21
_0x20:
	SBI  0x1B,3
_0x21:
; 0000 002E              PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x22
	CBI  0x1B,4
	RJMP _0x23
_0x22:
	SBI  0x1B,4
_0x23:
; 0000 002F              PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x24
	CBI  0x1B,5
	RJMP _0x25
_0x24:
	SBI  0x1B,5
_0x25:
; 0000 0030              PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x26
	CBI  0x1B,6
	RJMP _0x27
_0x26:
	SBI  0x1B,6
_0x27:
; 0000 0031              PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x28
	CBI  0x1B,7
	RJMP _0x29
_0x28:
	SBI  0x1B,7
_0x29:
; 0000 0032              delay_ms(85);
	LDI  R26,LOW(85)
	LDI  R27,0
	CALL _delay_ms
; 0000 0033              c=(c<<1)|1;
	MOV  R30,R18
	LSL  R30
	ORI  R30,1
	MOV  R18,R30
; 0000 0034         }
	SUBI R16,-1
	RJMP _0x18
_0x19:
; 0000 0035         cd=PORTC;
	IN   R19,21
; 0000 0036     }
	SUBI R17,1
	RJMP _0x15
_0x16:
; 0000 0037 }
	RJMP _0x2000002
; .FEND
;void h_u4(){
; 0000 0038 void h_u4(){
_h_u4:
; .FSTART _h_u4
; 0000 0039     unsigned char i;
; 0000 003A     unsigned char a=0xFC;
; 0000 003B     for(i=0;i<4;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	a -> R16
	LDI  R16,252
	LDI  R17,LOW(0)
_0x2B:
	CPI  R17,4
	BRSH _0x2C
; 0000 003C         PORTC=PORTB=a;
	MOV  R30,R16
	OUT  0x18,R30
	OUT  0x15,R30
; 0000 003D         PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x2D
	CBI  0x1B,0
	RJMP _0x2E
_0x2D:
	SBI  0x1B,0
_0x2E:
; 0000 003E         PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x2F
	CBI  0x1B,1
	RJMP _0x30
_0x2F:
	SBI  0x1B,1
_0x30:
; 0000 003F         PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x31
	CBI  0x1B,2
	RJMP _0x32
_0x31:
	SBI  0x1B,2
_0x32:
; 0000 0040          PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x33
	CBI  0x1B,3
	RJMP _0x34
_0x33:
	SBI  0x1B,3
_0x34:
; 0000 0041          PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x35
	CBI  0x1B,4
	RJMP _0x36
_0x35:
	SBI  0x1B,4
_0x36:
; 0000 0042          PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x37
	CBI  0x1B,5
	RJMP _0x38
_0x37:
	SBI  0x1B,5
_0x38:
; 0000 0043          PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x39
	CBI  0x1B,6
	RJMP _0x3A
_0x39:
	SBI  0x1B,6
_0x3A:
; 0000 0044          PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x3B
	CBI  0x1B,7
	RJMP _0x3C
_0x3B:
	SBI  0x1B,7
_0x3C:
; 0000 0045         delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 0046         a=(a<<2)|0x03;
	MOV  R30,R16
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x3)
	MOV  R16,R30
; 0000 0047     }
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
; 0000 0048 }
	RJMP _0x2000001
; .FEND
;void h_u5(){
; 0000 0049 void h_u5(){
_h_u5:
; .FSTART _h_u5
; 0000 004A    unsigned char i;
; 0000 004B    unsigned char x=0xFF;    //fe  7f
; 0000 004C    unsigned char y=0xFF;
; 0000 004D    for(i=0;i<4;i++){
	CALL __SAVELOCR4
;	i -> R17
;	x -> R16
;	y -> R19
	LDI  R16,255
	LDI  R19,255
	LDI  R17,LOW(0)
_0x3E:
	CPI  R17,4
	BRSH _0x3F
; 0000 004E       PORTC=PORTB=x&y;
	MOV  R30,R19
	AND  R30,R16
	OUT  0x18,R30
	OUT  0x15,R30
; 0000 004F       PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x40
	CBI  0x1B,0
	RJMP _0x41
_0x40:
	SBI  0x1B,0
_0x41:
; 0000 0050      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x42
	CBI  0x1B,1
	RJMP _0x43
_0x42:
	SBI  0x1B,1
_0x43:
; 0000 0051      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x44
	CBI  0x1B,2
	RJMP _0x45
_0x44:
	SBI  0x1B,2
_0x45:
; 0000 0052      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x46
	CBI  0x1B,3
	RJMP _0x47
_0x46:
	SBI  0x1B,3
_0x47:
; 0000 0053      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x48
	CBI  0x1B,4
	RJMP _0x49
_0x48:
	SBI  0x1B,4
_0x49:
; 0000 0054      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x4A
	CBI  0x1B,5
	RJMP _0x4B
_0x4A:
	SBI  0x1B,5
_0x4B:
; 0000 0055      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x4C
	CBI  0x1B,6
	RJMP _0x4D
_0x4C:
	SBI  0x1B,6
_0x4D:
; 0000 0056      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x4E
	CBI  0x1B,7
	RJMP _0x4F
_0x4E:
	SBI  0x1B,7
_0x4F:
; 0000 0057       delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0058       x=(x<<1);
	LSL  R16
; 0000 0059       y=(y>>1);
	LSR  R19
; 0000 005A    }
	SUBI R17,-1
	RJMP _0x3E
_0x3F:
; 0000 005B    x=y=0;
	LDI  R30,LOW(0)
	MOV  R19,R30
	MOV  R16,R30
; 0000 005C  for(i=0;i<4;i++){
	LDI  R17,LOW(0)
_0x51:
	CPI  R17,4
	BRSH _0x52
; 0000 005D       x=(x<<1)&0x01;
	MOV  R30,R16
	LSL  R30
	ANDI R30,LOW(0x1)
	MOV  R16,R30
; 0000 005E       y=(y>>1)&0x04;
	MOV  R30,R19
	LSR  R30
	ANDI R30,LOW(0x4)
	MOV  R19,R30
; 0000 005F      PORTC=PORTB=x|y;
	OR   R30,R16
	OUT  0x18,R30
	OUT  0x15,R30
; 0000 0060      PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x53
	CBI  0x1B,0
	RJMP _0x54
_0x53:
	SBI  0x1B,0
_0x54:
; 0000 0061      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x55
	CBI  0x1B,1
	RJMP _0x56
_0x55:
	SBI  0x1B,1
_0x56:
; 0000 0062      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x57
	CBI  0x1B,2
	RJMP _0x58
_0x57:
	SBI  0x1B,2
_0x58:
; 0000 0063      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x59
	CBI  0x1B,3
	RJMP _0x5A
_0x59:
	SBI  0x1B,3
_0x5A:
; 0000 0064      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x5B
	CBI  0x1B,4
	RJMP _0x5C
_0x5B:
	SBI  0x1B,4
_0x5C:
; 0000 0065      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x5D
	CBI  0x1B,5
	RJMP _0x5E
_0x5D:
	SBI  0x1B,5
_0x5E:
; 0000 0066      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x5F
	CBI  0x1B,6
	RJMP _0x60
_0x5F:
	SBI  0x1B,6
_0x60:
; 0000 0067      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x61
	CBI  0x1B,7
	RJMP _0x62
_0x61:
	SBI  0x1B,7
_0x62:
; 0000 0068       delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0069    }
	SUBI R17,-1
	RJMP _0x51
_0x52:
; 0000 006A }
_0x2000002:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void h_u6(){      //  so led chay qua chay lai tang dan trong mot khoang thoi gian
; 0000 006B void h_u6(){
_h_u6:
; .FSTART _h_u6
; 0000 006C     char k[8]={0xFE,0xFC,0xF8,0xF0,0xE0,0xC0,0x80,0x00};
; 0000 006D     unsigned char i,j;
; 0000 006E     unsigned int r;
; 0000 006F     for(i=0;i<8;i++){
	SBIW R28,8
	LDI  R30,LOW(254)
	ST   Y,R30
	LDI  R30,LOW(252)
	STD  Y+1,R30
	LDI  R30,LOW(248)
	STD  Y+2,R30
	LDI  R30,LOW(240)
	STD  Y+3,R30
	LDI  R30,LOW(224)
	STD  Y+4,R30
	LDI  R30,LOW(192)
	STD  Y+5,R30
	LDI  R30,LOW(128)
	STD  Y+6,R30
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CALL __SAVELOCR4
;	k -> Y+4
;	i -> R17
;	j -> R16
;	r -> R18,R19
	LDI  R17,LOW(0)
_0x64:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x65
; 0000 0070         r=k[i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X
	CLR  R19
; 0000 0071         for(j=8;j>i;j--){
	LDI  R16,LOW(8)
_0x67:
	CP   R17,R16
	BRSH _0x68
; 0000 0072            PORTB=PORTC=r;
	MOV  R30,R18
	OUT  0x15,R30
	OUT  0x18,R30
; 0000 0073            PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x69
	CBI  0x1B,0
	RJMP _0x6A
_0x69:
	SBI  0x1B,0
_0x6A:
; 0000 0074              PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x6B
	CBI  0x1B,1
	RJMP _0x6C
_0x6B:
	SBI  0x1B,1
_0x6C:
; 0000 0075              PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x6D
	CBI  0x1B,2
	RJMP _0x6E
_0x6D:
	SBI  0x1B,2
_0x6E:
; 0000 0076              PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x6F
	CBI  0x1B,3
	RJMP _0x70
_0x6F:
	SBI  0x1B,3
_0x70:
; 0000 0077              PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x71
	CBI  0x1B,4
	RJMP _0x72
_0x71:
	SBI  0x1B,4
_0x72:
; 0000 0078              PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x73
	CBI  0x1B,5
	RJMP _0x74
_0x73:
	SBI  0x1B,5
_0x74:
; 0000 0079              PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x75
	CBI  0x1B,6
	RJMP _0x76
_0x75:
	SBI  0x1B,6
_0x76:
; 0000 007A              PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x77
	CBI  0x1B,7
	RJMP _0x78
_0x77:
	SBI  0x1B,7
_0x78:
; 0000 007B            delay_ms(65);
	RCALL SUBOPT_0x4
; 0000 007C            r=(r<<1)|1;
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ORI  R30,1
	MOVW R18,R30
; 0000 007D       }
	SUBI R16,1
	RJMP _0x67
_0x68:
; 0000 007E         for(j=9;j>i;j--){
	LDI  R16,LOW(9)
_0x7A:
	CP   R17,R16
	BRSH _0x7B
; 0000 007F           PORTB=PORTC=r;
	MOV  R30,R18
	OUT  0x15,R30
	OUT  0x18,R30
; 0000 0080           PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x7C
	CBI  0x1B,0
	RJMP _0x7D
_0x7C:
	SBI  0x1B,0
_0x7D:
; 0000 0081          PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x7E
	CBI  0x1B,1
	RJMP _0x7F
_0x7E:
	SBI  0x1B,1
_0x7F:
; 0000 0082          PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x80
	CBI  0x1B,2
	RJMP _0x81
_0x80:
	SBI  0x1B,2
_0x81:
; 0000 0083          PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x82
	CBI  0x1B,3
	RJMP _0x83
_0x82:
	SBI  0x1B,3
_0x83:
; 0000 0084          PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x84
	CBI  0x1B,4
	RJMP _0x85
_0x84:
	SBI  0x1B,4
_0x85:
; 0000 0085          PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x86
	CBI  0x1B,5
	RJMP _0x87
_0x86:
	SBI  0x1B,5
_0x87:
; 0000 0086          PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x88
	CBI  0x1B,6
	RJMP _0x89
_0x88:
	SBI  0x1B,6
_0x89:
; 0000 0087          PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x8A
	CBI  0x1B,7
	RJMP _0x8B
_0x8A:
	SBI  0x1B,7
_0x8B:
; 0000 0088            delay_ms(65);
	RCALL SUBOPT_0x4
; 0000 0089            r=(r>>1);
	LSR  R19
	ROR  R18
; 0000 008A       }
	SUBI R16,1
	RJMP _0x7A
_0x7B:
; 0000 008B       r=0xFF;
	__GETWRN 18,19,255
; 0000 008C       delay_ms(65);
	RCALL SUBOPT_0x4
; 0000 008D    }
	SUBI R17,-1
	RJMP _0x64
_0x65:
; 0000 008E }
	CALL __LOADLOCR4
	ADIW R28,12
	RET
; .FEND
;void h_u7(){
; 0000 008F void h_u7(){
_h_u7:
; .FSTART _h_u7
; 0000 0090     unsigned char m=0xF0;
; 0000 0091     unsigned char i;
; 0000 0092     for(i=0;i<2;i++){
	ST   -Y,R17
	ST   -Y,R16
;	m -> R17
;	i -> R16
	LDI  R17,240
	LDI  R16,LOW(0)
_0x8D:
	CPI  R16,2
	BRSH _0x8E
; 0000 0093        PORTB=PORTC=m;
	MOV  R30,R17
	OUT  0x15,R30
	OUT  0x18,R30
; 0000 0094        PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0x8F
	CBI  0x1B,0
	RJMP _0x90
_0x8F:
	SBI  0x1B,0
_0x90:
; 0000 0095      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0x91
	CBI  0x1B,1
	RJMP _0x92
_0x91:
	SBI  0x1B,1
_0x92:
; 0000 0096      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0x93
	CBI  0x1B,2
	RJMP _0x94
_0x93:
	SBI  0x1B,2
_0x94:
; 0000 0097      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0x95
	CBI  0x1B,3
	RJMP _0x96
_0x95:
	SBI  0x1B,3
_0x96:
; 0000 0098      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0x97
	CBI  0x1B,4
	RJMP _0x98
_0x97:
	SBI  0x1B,4
_0x98:
; 0000 0099      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0x99
	CBI  0x1B,5
	RJMP _0x9A
_0x99:
	SBI  0x1B,5
_0x9A:
; 0000 009A      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0x9B
	CBI  0x1B,6
	RJMP _0x9C
_0x9B:
	SBI  0x1B,6
_0x9C:
; 0000 009B      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0x9D
	CBI  0x1B,7
	RJMP _0x9E
_0x9D:
	SBI  0x1B,7
_0x9E:
; 0000 009C         delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 009D         m=(m<<4)|0x0F;
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	ORI  R30,LOW(0xF)
	MOV  R17,R30
; 0000 009E     }
	SUBI R16,-1
	RJMP _0x8D
_0x8E:
; 0000 009F }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void h_u8(){     //vao hai ben va chay ra 2 ben
; 0000 00A0 void h_u8(){
_h_u8:
; .FSTART _h_u8
; 0000 00A1    unsigned char i;
; 0000 00A2    unsigned int a,b,c ;
; 0000 00A3    b=0xFE;
	SBIW R28,2
	CALL __SAVELOCR6
;	i -> R17
;	a -> R18,R19
;	b -> R20,R21
;	c -> Y+6
	__GETWRN 20,21,254
; 0000 00A4    a=0x7F;
	__GETWRN 18,19,127
; 0000 00A5    for(i=0;i<4;i++){
	LDI  R17,LOW(0)
_0xA0:
	CPI  R17,4
	BRSH _0xA1
; 0000 00A6       c=b&a;
	RCALL SUBOPT_0x5
; 0000 00A7       PORTB=PORTC=c;
; 0000 00A8       PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0xA2
	CBI  0x1B,0
	RJMP _0xA3
_0xA2:
	SBI  0x1B,0
_0xA3:
; 0000 00A9      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0xA4
	CBI  0x1B,1
	RJMP _0xA5
_0xA4:
	SBI  0x1B,1
_0xA5:
; 0000 00AA      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0xA6
	CBI  0x1B,2
	RJMP _0xA7
_0xA6:
	SBI  0x1B,2
_0xA7:
; 0000 00AB      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0xA8
	CBI  0x1B,3
	RJMP _0xA9
_0xA8:
	SBI  0x1B,3
_0xA9:
; 0000 00AC      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0xAA
	CBI  0x1B,4
	RJMP _0xAB
_0xAA:
	SBI  0x1B,4
_0xAB:
; 0000 00AD      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0xAC
	CBI  0x1B,5
	RJMP _0xAD
_0xAC:
	SBI  0x1B,5
_0xAD:
; 0000 00AE      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0xAE
	CBI  0x1B,6
	RJMP _0xAF
_0xAE:
	SBI  0x1B,6
_0xAF:
; 0000 00AF      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0xB0
	CBI  0x1B,7
	RJMP _0xB1
_0xB0:
	SBI  0x1B,7
_0xB1:
; 0000 00B0       delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 00B1        b=(b<<1)|1;
	MOVW R30,R20
	LSL  R30
	ROL  R31
	ORI  R30,1
	MOVW R20,R30
; 0000 00B2         a=(a>>1)|0x80;
	MOVW R30,R18
	LSR  R31
	ROR  R30
	ORI  R30,0x80
	MOVW R18,R30
; 0000 00B3    }
	SUBI R17,-1
	RJMP _0xA0
_0xA1:
; 0000 00B4    PORTB=PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
	OUT  0x18,R30
; 0000 00B5    PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0xB2
	CBI  0x1B,0
	RJMP _0xB3
_0xB2:
	SBI  0x1B,0
_0xB3:
; 0000 00B6      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0xB4
	CBI  0x1B,1
	RJMP _0xB5
_0xB4:
	SBI  0x1B,1
_0xB5:
; 0000 00B7      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0xB6
	CBI  0x1B,2
	RJMP _0xB7
_0xB6:
	SBI  0x1B,2
_0xB7:
; 0000 00B8      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0xB8
	CBI  0x1B,3
	RJMP _0xB9
_0xB8:
	SBI  0x1B,3
_0xB9:
; 0000 00B9      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0xBA
	CBI  0x1B,4
	RJMP _0xBB
_0xBA:
	SBI  0x1B,4
_0xBB:
; 0000 00BA      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0xBC
	CBI  0x1B,5
	RJMP _0xBD
_0xBC:
	SBI  0x1B,5
_0xBD:
; 0000 00BB      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0xBE
	CBI  0x1B,6
	RJMP _0xBF
_0xBE:
	SBI  0x1B,6
_0xBF:
; 0000 00BC      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0xC0
	CBI  0x1B,7
	RJMP _0xC1
_0xC0:
	SBI  0x1B,7
_0xC1:
; 0000 00BD    delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 00BE    b=0xEF;
	__GETWRN 20,21,239
; 0000 00BF    a=0xF7;
	__GETWRN 18,19,247
; 0000 00C0    for(i=0;i<4;i++){
	LDI  R17,LOW(0)
_0xC3:
	CPI  R17,4
	BRSH _0xC4
; 0000 00C1       c=b&a;
	RCALL SUBOPT_0x5
; 0000 00C2       PORTB=PORTC=c;
; 0000 00C3       PORTA.0=PORTC.7;
	SBIC 0x15,7
	RJMP _0xC5
	CBI  0x1B,0
	RJMP _0xC6
_0xC5:
	SBI  0x1B,0
_0xC6:
; 0000 00C4      PORTA.1=PORTC.6;
	SBIC 0x15,6
	RJMP _0xC7
	CBI  0x1B,1
	RJMP _0xC8
_0xC7:
	SBI  0x1B,1
_0xC8:
; 0000 00C5      PORTA.2=PORTC.5;
	SBIC 0x15,5
	RJMP _0xC9
	CBI  0x1B,2
	RJMP _0xCA
_0xC9:
	SBI  0x1B,2
_0xCA:
; 0000 00C6      PORTA.3=PORTC.4;
	SBIC 0x15,4
	RJMP _0xCB
	CBI  0x1B,3
	RJMP _0xCC
_0xCB:
	SBI  0x1B,3
_0xCC:
; 0000 00C7      PORTA.4=PORTC.3;
	SBIC 0x15,3
	RJMP _0xCD
	CBI  0x1B,4
	RJMP _0xCE
_0xCD:
	SBI  0x1B,4
_0xCE:
; 0000 00C8      PORTA.5=PORTC.2;
	SBIC 0x15,2
	RJMP _0xCF
	CBI  0x1B,5
	RJMP _0xD0
_0xCF:
	SBI  0x1B,5
_0xD0:
; 0000 00C9      PORTA.6=PORTC.1;
	SBIC 0x15,1
	RJMP _0xD1
	CBI  0x1B,6
	RJMP _0xD2
_0xD1:
	SBI  0x1B,6
_0xD2:
; 0000 00CA      PORTA.7=PORTC.0;
	SBIC 0x15,0
	RJMP _0xD3
	CBI  0x1B,7
	RJMP _0xD4
_0xD3:
	SBI  0x1B,7
_0xD4:
; 0000 00CB       delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 00CC        a=(a<<1)|1;
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ORI  R30,1
	MOVW R18,R30
; 0000 00CD         b=(b>>1)|0x80;
	MOVW R30,R20
	LSR  R31
	ROR  R30
	ORI  R30,0x80
	MOVW R20,R30
; 0000 00CE    }
	SUBI R17,-1
	RJMP _0xC3
_0xC4:
; 0000 00CF }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00D1 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D2    k++;
	INC  R5
; 0000 00D3    if(k==8)k=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0xD5
	CLR  R5
; 0000 00D4 }
_0xD5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00D7 {
_main:
; .FSTART _main
; 0000 00D8     PORTD.2=1;
	SBI  0x12,2
; 0000 00D9     DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00DA     PORTA=0x00;
	OUT  0x1B,R30
; 0000 00DB     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00DC     PORTC=0xFF;
	OUT  0x15,R30
; 0000 00DD     DDRC=0xFF;
	OUT  0x14,R30
; 0000 00DE     PORTB=0xFF;
	OUT  0x18,R30
; 0000 00DF     DDRB=0xFF;
	OUT  0x17,R30
; 0000 00E0 // INT0: On    Low level
; 0000 00E1 GICR|=(1<<6); // bat int
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00E2 MCUCR|=(1<<1);  // che do hoat dong int0
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 00E3 #asm("sei")//khai bao ngat toan cuc
	sei
; 0000 00E4 while (1)
_0xD8:
; 0000 00E5       {
; 0000 00E6           if(k==0)h_u1();
	TST  R5
	BRNE _0xDB
	RCALL _h_u1
; 0000 00E7           else if(k==1)h_u2();
	RJMP _0xDC
_0xDB:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0xDD
	RCALL _h_u2
; 0000 00E8           else if(k==2)h_u3();
	RJMP _0xDE
_0xDD:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0xDF
	RCALL _h_u3
; 0000 00E9           else if(k==3)h_u4();
	RJMP _0xE0
_0xDF:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0xE1
	RCALL _h_u4
; 0000 00EA           else if(k==4)h_u5();
	RJMP _0xE2
_0xE1:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0xE3
	RCALL _h_u5
; 0000 00EB           else if(k==5)h_u6();
	RJMP _0xE4
_0xE3:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0xE5
	RCALL _h_u6
; 0000 00EC           else if(k==6) h_u7();
	RJMP _0xE6
_0xE5:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0xE7
	RCALL _h_u7
; 0000 00ED           else if(k==7)h_u8();
	RJMP _0xE8
_0xE7:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0xE9
	RCALL _h_u8
; 0000 00EE       }
_0xE9:
_0xE8:
_0xE6:
_0xE4:
_0xE2:
_0xE0:
_0xDE:
_0xDC:
	RJMP _0xD8
; 0000 00EF }
_0xEA:
	RJMP _0xEA
; .FEND

	.DSEG
_x:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R30,_x
	LDS  R31,_x+1
	LDS  R22,_x+2
	LDS  R23,_x+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	RCALL SUBOPT_0x0
	CALL __COMD1
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(65)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	MOVW R30,R18
	AND  R30,R20
	AND  R31,R21
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+6
	OUT  0x15,R30
	OUT  0x18,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__COMD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
