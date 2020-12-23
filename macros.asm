; Macros
align:	macro
	if (narg=1)
	dcb.b \1-(*%\1),0
	else
	dcb.b \1-(*%\1),\2
	endc
	endm

; Macro to align a bank to prevent it crossing a $8000 byte boundary.
bankalign macro size
	if (*&$7FFF)+size>$8000
	align $8000	; don't cross it over a $8000 boundary
	endif
     endm

; Macro to stop the Z80
stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l
.loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	.loop
     endm

; Macro to start the Z80
startZ80 macro
	move.w	#0,(Z80_Bus_Request).l
     endm
     
 ; Macros to disable/enable interrupts
disable_ints:	macro
		move	#$2700,sr
		endm

enable_ints:	macro
		move	#$2300,sr
		endm

; tells the VDP to fill a region of VRAM with a certain byte
dmaFillVRAM macro byte,addr,length
		lea		(VDP_control_port).l,a5
		move.w	#$8F01,(a5) ; VRAM pointer increment: $0001
	    	move.l	#(($9400|((((length)-1)&$FF00)>>8))<<16)|($9300|(((length)-1)&$FF)),(a5) ; DMA length ...
		move.w	#$9780,(a5) ; VRAM fill
	    	move.l	#$40000080|(((addr)&$3FFF)<<16)|(((addr)&$C000)>>14),(a5) ; Start at ...
		move.w	#(byte)<<8,(VDP_data_port).l ; Fill with byte
.loopDMA\@:	move.w	(a5),d1
		btst	#1,d1
		bne.s	.loopDMA\@ ; busy loop until the VDP is finished filling...
		move.w	#$8F02,(a5) ; VRAM pointer increment: $0002
    endm