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
        .section .data
        .align  3
        .global boot_status
        .type   boot_status, %object
boot_status:
        .word   0
	
	.section .text
        .align  3
	.globl _start
	.type _start,@function
_start:	
        csrw    mip,  zero 
        csrw    mie,   zero 
        la      t0,     _start_hang
        csrw    mtvec,  t0

	csrr	a0, 	mhartid
        bne     a0,     zero,   wait_done

        la      a0,     _sidata
        la      a1,     _sdata
        la      a2,     _edata
        load_data   a0, a1, a2
        
	
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


        la      t0,     boot_status
        la      t1,     1
        amoadd.w    t0,     t1,     (t0) 

	li	t0,	0x800
	slli	t0,	t0,	20

	jr 	t0


wait_done:
        la      t0,     boot_status
        lw      t0,     0(t0)
        beqz    t0,     wait_done

	csrr	a0, 	mhartid
	li	a1,	0x822 	//device tree address
	slli 	a1, 	a1, 	20

	li	t0,	0x800
	slli	t0,	t0,	20

	jr 	t0


        .section .text, "ax", %progbits
        .align  3
        .global _start_hang
_start_hang:
        wfi
        j _start_hang
	.end
