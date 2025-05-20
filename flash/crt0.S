// define loop count	
.macro loop,count
        li		t1,	0xffff
        li		t2,	\count
1:
	nop
	addi    t1, t1, -1
	bne		t1, x0, 1b
        li		t1,	0xffff
	addi    t2, t2, -1
	bne		t2, x0, 1b
.endm

// load data from src_start to [dst_start - dst_end]
.macro load_data,_src_start,_dst_start,_dst_end
	bgeu	\_dst_start, \_dst_end, 2f
1:
	lw      t0, (\_src_start)
	sw      t0, (\_dst_start)
	addi    \_src_start, \_src_start, 4
	addi    \_dst_start, \_dst_start, 4
	bltu    \_dst_start, \_dst_end, 1b
2:
.endm

// crt0.S startup
	
	.section .text
	.globl _start
	.type _start,@function
_start:	
	csrr	a0, 	mhartid
	

#if 1
	// load device tree 512KB
	li 	a0, 	0x2008
	slli 	a0, 	a0, 	16
	li 	a1, 	0x822
	slli 	a1, 	a1, 	20
	li 	a2, 	0x8228
	slli 	a2, 	a2, 	16

	load_data a0,	a1,	a2

	li	a1,	0x822 	//device tree address
	slli 	a1, 	a1, 	20
#endif
	csrr	a0, 	mhartid
	li	t0,	0x800
	slli	t0,	t0,	20

	jr 	t0

	.end
