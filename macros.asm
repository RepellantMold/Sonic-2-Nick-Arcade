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
  
; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(VDP_control_port).l
		else
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endc
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro
		lea	(VDP_control_port).l,a5
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro
		lea	(VDP_control_port).l,a5
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,width,height
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		bsr.w	ShowVDPGraphics
		endm