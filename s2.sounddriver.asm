Go_SoundTypes:	dc.l SoundTypes
Go_SoundD0:	dc.l SoundD0Index
Go_MusicIndex:	dc.l MusicIndex
Go_SoundIndex:	dc.l SoundIndex
Go_SpedTempo:	dc.l SpedUpTempoTable
Go_PSGIndex:	dc.l PSG_Index
; ---------------------------------------------------------------------------
; PSG envelopes used in music
; ---------------------------------------------------------------------------
PSG_Index:	dc.l PSG1, PSG2, PSG3, PSG4, PSG5, PSG6, PSG7, PSG8, PSG9
		even
PSG1:		incbin "sound/PSG/psg1.bin"
PSG2:		incbin "sound/PSG/psg2.bin"
PSG3:		incbin "sound/PSG/psg3.bin"
PSG4:		incbin "sound/PSG/psg4.bin"
PSG6:		incbin "sound/PSG/psg6.bin"
PSG5:		incbin "sound/PSG/psg5.bin"
PSG7:		incbin "sound/PSG/psg7.bin"
PSG8:		incbin "sound/PSG/psg8.bin"
PSG9:		incbin "sound/PSG/psg9.bin"
		even
; byte_71A94:
; Note: if you add more songs, change these
; (exactly the same in Sonic 1 and the Simon Wai prototype)
SpedUpTempoTable:	dc.b   7,$72,$73,$26,$15,  8,$FF,  5
; ---------------------------------------------------------------------------
; Music	Pointers
; ---------------------------------------------------------------------------
MusicIndex:	dc.l Mus_GHZ
		dc.l Mus_LZ
		dc.l Mus_MZ
		dc.l Mus_SLZ
		dc.l Mus_SYZ
		dc.l Mus_SBZ
		dc.l Mus_Inv
		dc.l Mus_ExtraLife
		dc.l Mus_SS
		dc.l Mus_Title
		dc.l Mus_Ending
		dc.l Mus_Boss
		dc.l Mus_FZ
		dc.l Mus_SonicGotThrough
		dc.l Mus_GameOver
		dc.l Mus_Continue
		dc.l Mus_Credits
		dc.l Mus_Drowning
		dc.l Mus_Emerald
; ---------------------------------------------------------------------------
; Type of sound	being played ($90 = music; $70 = normal	sound effect)
; ---------------------------------------------------------------------------
SoundTypes:	dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90
		dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$80
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$68,$70,$70,$70,$60,$70,$70
		dc.b $60,$70,$60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$7F,$60
		dc.b $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$80
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$90
		dc.b $90,$90,$90,$90
; ---------------------------------------------------------------------------
; Subroutine to update the 68000 sound driver in the vertical interrupts
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_71B4C:
UpdateMusic:
		move.w	#$100,(Z80_Bus_Request).l ; stop the Z80
		nop
		nop
		nop

loc_71B5A:
		btst	#0,(Z80_Bus_Request).l
		bne.s	loc_71B5A
		btst	#7,(Z80_DAC_Status).l
		beq.s	loc_71B82
		move.w	#0,(Z80_Bus_Request).l	; start	the Z80
		nop
		nop
		nop
		nop
		nop
		bra.s	UpdateMusic
; ===========================================================================

loc_71B82:
		lea	(SoundDriver_RAM).l,a6
		clr.b	$E(a6)
		tst.b	PauseSound(a6)		; is music paused?
		bne.w	PauseMusic	; if yes, branch
		subq.b	#1,1(a6)
		bne.s	loc_71B9E
		jsr	TempoWait(pc)

loc_71B9E:
		move.b	4(a6),d0
		beq.s	loc_71BA8
		jsr	UpdateFadeOut(pc)

loc_71BA8:
		tst.b	$24(a6)
		beq.s	loc_71BB2
		jsr	UpdateFadeIn(pc)

loc_71BB2:
		; Should be a long-word, otherwise PlaySound_Unk is broken
		tst.w	SFXToPlay(a6)	; is music or sound being played?
		beq.s	loc_71BBC	; if not, branch
		jsr	CycleQueue(pc)

loc_71BBC:
		cmpi.b	#-$80,QueueToPlay(a6)
		beq.s	loc_71BC8
		jsr	PlaySoundByIndex(pc)

loc_71BC8:
		lea	$40(a6),a5
		tst.b	(a5)
		bpl.s	loc_71BD4
		jsr	DACUpdateTrack(pc)

loc_71BD4:
		clr.b	8(a6)
		moveq	#5,d7

loc_71BDA:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71BE6
		jsr	FMUpdateTrack(pc)

loc_71BE6:
		dbf	d7,loc_71BDA
		moveq	#2,d7

loc_71BEC:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71BF8
		jsr	PSGUpdateTrack(pc)

loc_71BF8:
		dbf	d7,loc_71BEC
		move.b	#-$80,$E(a6)
		moveq	#2,d7

loc_71C04:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C10
		jsr	FMUpdateTrack(pc)

loc_71C10:
		dbf	d7,loc_71C04
		moveq	#2,d7

loc_71C16:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C22
		jsr	PSGUpdateTrack(pc)

loc_71C22:
		dbf	d7,loc_71C16
		move.b	#$40,$E(a6)
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_71C38
		jsr	FMUpdateTrack(pc)

loc_71C38:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	UpdateZ80
		jsr	PSGUpdateTrack(pc)
; loc_71C44:
UpdateZ80:
		move.w	#0,(Z80_Bus_Request).l	; start	the Z80
		rts
; End of function UpdateMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71C4E:
DACUpdateTrack:
		subq.b	#1,$E(a5)
		bne.s	locret_71CAA
		move.b	#-$80,8(a6)
		movea.l	4(a5),a4

loc_71C5E:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_71C6E
		jsr	CoordFlag(pc)
		bra.s	loc_71C5E
; ===========================================================================

loc_71C6E:
		tst.b	d5
		bpl.s	loc_71C84
		move.b	d5,$10(a5)
		move.b	(a4)+,d5
		bpl.s	loc_71C84
		subq.w	#1,a4
		move.b	$F(a5),$E(a5)
		bra.s	DACAfterDur
; ===========================================================================

loc_71C84:
		jsr	SetDuration(pc)
; loc_71C88:
DACAfterDur:
		move.l	a4,4(a5)
		btst	#2,(a5)
		bne.s	locret_71CAA
		moveq	#0,d0
		move.b	$10(a5),d0
		cmpi.b	#-$80,d0
		beq.s	locret_71CAA
		btst	#3,d0
		bne.s	TimpaniSetTempo
		move.b	d0,(Z80_DAC_Sample).l

locret_71CAA:
		rts
; ===========================================================================
; loc_71CAC:
TimpaniSetTempo:
		subi.b	#-$78,d0
		move.b	TimpaniTempoTable(pc,d0.w),d0
		move.b	d0,(Z80_DAC3_Pitch).l
		move.b	#-$7D,(Z80_DAC_Sample).l
		rts
; End of function DACUpdateTrack

; ===========================================================================
; byte_71CC4:
TimpaniTempoTable:	dc.b $12,$15,$1C,$1D,$FF,$FF

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71CCA:
FMUpdateTrack:
		subq.b	#1,$E(a5)
		bne.s	loc_71CE0
		bclr	#4,(a5)
		jsr	FMDoNext(pc)
		jsr	FMPrepareNote(pc)
		bra.w	FMNoteOn
; ===========================================================================

loc_71CE0:
		jsr	NoteFillUpdate(pc)
		jsr	DoModulation(pc)
		bra.w	FMUpdateFreq
; End of function FMUpdateTrack


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71CEC:
FMDoNext:
		movea.l	4(a5),a4
		bclr	#1,(a5)

loc_71CF4:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_71D04
		jsr	CoordFlag(pc)
		bra.s	loc_71CF4
; ===========================================================================

loc_71D04:
		jsr	FMNoteOff(pc)
		tst.b	d5
		bpl.s	loc_71D1A
		jsr	FMSetFreq(pc)
		move.b	(a4)+,d5
		bpl.s	loc_71D1A
		subq.w	#1,a4
		bra.w	FinishTrackUpdate
; ===========================================================================

loc_71D1A:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; End of function FMDoNext

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71D22:
FMSetFreq:
		subi.b	#-$80,d5
		beq.s	loc_71D58
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	FMFrequencies(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,$10(a5)
		rts
; End of function FMSetFreq


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71D40:
SetDuration:
		move.b	d5,d0
		move.b	2(a5),d1

loc_71D46:
		subq.b	#1,d1
		beq.s	loc_71D4E
		add.b	d5,d0
		bra.s	loc_71D46
; ===========================================================================

loc_71D4E:
		move.b	d0,$F(a5)
		move.b	d0,$E(a5)
		rts
; End of function SetDuration

; ===========================================================================
; START	OF FUNCTION CHUNK FOR FMSetFreq

loc_71D58:				; CODE XREF: FMSetFreq+4j
		bset	#1,(a5)
		clr.w	$10(a5)
; END OF FUNCTION CHUNK	FOR FMSetFreq

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71D60:
FinishTrackUpdate:
		move.l	a4,4(a5)
		move.b	$F(a5),$E(a5)
		btst	#4,(a5)
		bne.s	locret_71D9C
		move.b	$13(a5),$12(a5)
		clr.b	$C(a5)
		btst	#3,(a5)
		beq.s	locret_71D9C
		movea.l	$14(a5),a0
		move.b	(a0)+,$18(a5)
		move.b	(a0)+,$19(a5)
		move.b	(a0)+,$1A(a5)
		move.b	(a0)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)

locret_71D9C:
		rts
; End of function FinishTrackUpdate


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71D9E:
NoteFillUpdate:
		tst.b	$12(a5)
		beq.s	locret_71DC4
		subq.b	#1,$12(a5)
		bne.s	locret_71DC4
		bset	#1,(a5)
		tst.b	1(a5)
		bmi.w	loc_71DBE
		jsr	FMNoteOff(pc)
		addq.w	#4,sp
		rts
; ===========================================================================

loc_71DBE:
		jsr	PSGNoteOff(pc)
		addq.w	#4,sp

locret_71DC4:
		rts
; End of function NoteFillUpdate


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71DC6:
DoModulation:
		addq.w	#4,sp
		btst	#3,(a5)
		beq.s	locret_71E16
		tst.b	$18(a5)
		beq.s	loc_71DDA
		subq.b	#1,$18(a5)
		rts
; ===========================================================================

loc_71DDA:
		subq.b	#1,$19(a5)
		beq.s	loc_71DE2
		rts
; ===========================================================================

loc_71DE2:
		movea.l	$14(a5),a0
		move.b	1(a0),$19(a5)
		tst.b	$1B(a5)
		bne.s	loc_71DFE
		move.b	3(a0),$1B(a5)
		neg.b	$1A(a5)
		rts
; ===========================================================================

loc_71DFE:
		subq.b	#1,$1B(a5)
		move.b	$1A(a5),d6
		ext.w	d6
		add.w	$1C(a5),d6
		move.w	d6,$1C(a5)
		add.w	$10(a5),d6
		subq.w	#4,sp

locret_71E16:
		rts
; End of function DoModulation


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_71E18:
FMPrepareNote:
		btst	#1,(a5)
		bne.s	locret_71E48
		move.w	$10(a5),d6
		beq.s	loc_71E4A
; loc_71E24:
FMUpdateFreq:
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_71E48
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0
		jsr	WriteFMIorII(pc)
		move.b	d6,d1
		move.b	#$A0,d0
		jsr	WriteFMIorII(pc)

locret_71E48:
		rts
; ===========================================================================

loc_71E4A:
		bset	#1,(a5)
		rts
; End of function FMPrepareNote

; ===========================================================================
; loc_71E50:
PauseMusic:
		bmi.s	ResumeTrack
		cmpi.b	#2,PauseSound(a6)
		beq.w	loc_71EFE
		move.b	#2,PauseSound(a6)
		moveq	#2,d3
		move.b	#$B4,d0
		moveq	#0,d1

loc_71E6A:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.b	#1,d0
		dbf	d3,loc_71E6A
		moveq	#2,d3
		moveq	#$28,d0

loc_71E7C:
		move.b	d3,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d3,loc_71E7C
		jsr	PSGSilenceAll(pc)
		bra.w	UpdateZ80
; ===========================================================================
; loc_71E94:
ResumeTrack:
		clr.b	PauseSound(a6)
		moveq	#$30,d3
		lea	$40(a6),a5
		moveq	#6,d4

loc_71EA0:
		btst	#7,(a5)
		beq.s	loc_71EB8
		btst	#2,(a5)
		bne.s	loc_71EB8
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	WriteFMIorII(pc)

loc_71EB8:
		adda.w	d3,a5
		dbf	d4,loc_71EA0
		lea	$220(a6),a5
		moveq	#2,d4

loc_71EC4:
		btst	#7,(a5)
		beq.s	loc_71EDC
		btst	#2,(a5)
		bne.s	loc_71EDC
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	WriteFMIorII(pc)

loc_71EDC:
		adda.w	d3,a5
		dbf	d4,loc_71EC4
		lea	$340(a6),a5
		btst	#7,(a5)
		beq.s	loc_71EFE
		btst	#2,(a5)
		bne.s	loc_71EFE
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	WriteFMIorII(pc)

loc_71EFE:
		bra.w	UpdateZ80
; End of function UpdateMusic

; ---------------------------------------------------------------------------
; Subroutine to	play a sound or	music track
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Sound_Play:
CycleQueue:
		movea.l	(Go_SoundTypes).l,a0
		lea	SFXToPlay(a6),a1	; load music track number
		move.b	0(a6),d3
		moveq	#2,d4

loc_71F12:
		move.b	(a1),d0			; move track number to d0
		move.b	d0,d1
		clr.b	(a1)+
		subi.b	#-$7F,d0
		bcs.s	loc_71F3E
		cmpi.b	#-$80,QueueToPlay(a6)
		beq.s	loc_71F2C
		move.b	d1,SFXToPlay(a6)
		bra.s	loc_71F3E
; ===========================================================================

loc_71F2C:
		andi.w	#$7F,d0
		move.b	(a0,d0.w),d2
		cmp.b	d3,d2
		bcs.s	loc_71F3E
		move.b	d2,d3
		move.b	d1,QueueToPlay(a6)	; set music flag

loc_71F3E:
		dbf	d4,loc_71F12
		tst.b	d3
		bmi.s	locret_71F4A
		move.b	d3,0(a6)

locret_71F4A:
		rts
; End of function CycleQueue


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Sound_ChkValue:
PlaySoundByIndex:
		moveq	#0,d7
		move.b	QueueToPlay(a6),d7
		beq.w	StopSoundAndMusic
		bpl.s	locret_71F8C
		move.b	#$80,QueueToPlay(a6)	; reset	music flag
		cmpi.b	#$9F,d7			; is it between $81 to 9F? (only $81 to $93 are used normally, so playing the rest will crash the game)
		bls.w	PlayMusic		; if yes, then play music
		cmpi.b	#$A0,d7			; is it between $9F and $A0? (redundant check)
		bcs.w	locret_71F8C		; if yes, don't play anything
		cmpi.b	#$CF,d7			; if it between $A0 and $CF?
		bls.w	PlaySound_CheckRing	; if yes, play sound effects
		cmpi.b	#$D0,d7			; is it between $CF and $D0? (redundant check)
		bcs.w	locret_71F8C		; if yes, don't play anything
		cmpi.b	#$E0,d7			; is it between $D0 and $E0?
		bcs.w	PlaySound_Waterfall	; if yes, play special sound effects (only $D0 is used normally, so playing the rest will crash the game)
		cmpi.b	#$E4,d7			; is it between $E0 and $E4?
		bls.s	PlaySound_Commands	; if yes, play sound commands

locret_71F8C:
		rts
; ===========================================================================
; loc_71F8E:
PlaySound_Commands:
		subi.b	#$E0,d7
		lsl.w	#2,d7
		jmp	CommandIndex(pc,d7.w)
; ===========================================================================
; loc_71F98:
CommandIndex:
		bra.w	FadeOutMusic		; fade out music and sound effects
		bra.w	PlaySegaSound		; Seeegaaa! chant
		bra.w	SpeedUpMusic		; speed up music
		bra.w	SlowDownMusic		; slow down music
		bra.w	StopSoundAndMusic	; stop all music and sounds
; ===========================================================================
; ---------------------------------------------------------------------------
; Play "Say-gaa" PCM sound
; ---------------------------------------------------------------------------
; loc_71FAC: Sound_E1:
PlaySegaSound:
		move.b	#$88,(Z80_DAC_Sample).l	; play DAC sample $88 (normally hi-timpani)
		move.w	#0,(Z80_Bus_Request).l		; start	the Z80
		move.w	#$11,d1

loc_71FC0:
		move.w	#$FFFF,d0

loc_71FC4:
		nop
		dbf	d0,loc_71FC4
		dbf	d1,loc_71FC0
		addq.w	#4,sp
		rts
; End of function PlaySegaSound

; ===========================================================================
; ---------------------------------------------------------------------------
; Play music track $81-$9F
; ---------------------------------------------------------------------------
; loc_71FD2: Sound_81to9F:
PlayMusic:
		cmpi.b	#$88,d7		; is "extra life" music	played?
		bne.s	loc_72024	; if not, branch
		tst.b	$27(a6)
		bne.w	loc_721B6
		lea	$40(a6),a5
		moveq	#9,d0

loc_71FE6:
		bclr	#2,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_71FE6
		lea	$220(a6),a5
		moveq	#5,d0

loc_71FF8:
		bclr	#7,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_71FF8
		clr.b	0(a6)
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_72012:
		move.l	(a0)+,(a1)+
		dbf	d0,loc_72012
		move.b	#-$80,$27(a6)
		clr.b	0(a6)
		bra.s	BGMLoad
; ===========================================================================

loc_72024:
		clr.b	$27(a6)
		clr.b	$26(a6)
; loc_7202C:
BGMLoad:
		jsr	InitMusicPlayback(pc)
		movea.l	(Go_SpedTempo).l,a4
		subi.b	#-$7F,d7
		move.b	(a4,d7.w),$29(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4
		moveq	#0,d0
		move.w	(a4),d0
		add.l	a4,d0
		move.l	d0,$18(a6)
		move.b	5(a4),d0
		move.b	d0,$28(a6)
		tst.b	$2A(a6)
		beq.s	loc_72068
		move.b	$29(a6),d0

loc_72068:
		move.b	d0,2(a6)
		move.b	d0,1(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4
		moveq	#0,d7
		move.b	2(a3),d7
		beq.w	BGM_InitPSG
		subq.b	#1,d7
		move.b	#$C0,d1
		move.b	4(a3),d4
		moveq	#$30,d6
		move.b	#1,d5
		lea	$40(a6),a1
		lea	FMDACInitBytes(pc),a2

loc_72098:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d1,$A(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		adda.w	d6,a1
		dbf	d7,loc_72098
		cmpi.b	#7,2(a3)
		bne.s	BGM_InitFMDAC
		moveq	#$2B,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		bra.w	BGM_InitPSG
; ===========================================================================
; loc_720D8:
BGM_InitFMDAC:
		moveq	#$28,d0		; key on/off register
		moveq	#6,d1		; FM channel 6
		jsr	WriteFMI(pc)	; All operators off
		move.b	#$42,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4A,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$46,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$4E,d0
		moveq	#$7F,d1
		jsr	WriteFMII(pc)
		move.b	#$B6,d0
		move.b	#$C0,d1
		jsr	WriteFMII(pc)

; loc_72114:
BGM_InitPSG:
		moveq	#0,d7
		move.b	3(a3),d7
		beq.s	loc_72154
		subq.b	#1,d7
		lea	$190(a6),a1
		lea	PSGInitBytes(pc),a2

loc_72126:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		move.b	(a4)+,d0
		move.b	(a4)+,$B(a1)
		adda.w	d6,a1
		dbf	d7,loc_72126

loc_72154:
		lea	$220(a6),a1
		moveq	#5,d7

loc_7215A:
		tst.b	(a1)
		bpl.w	loc_7217C
		moveq	#0,d0
		move.b	1(a1),d0
		bmi.s	loc_7216E
		subq.b	#2,d0
		lsl.b	#2,d0
		bra.s	loc_72170
; ===========================================================================

loc_7216E:
		lsr.b	#3,d0

loc_72170:
		lea	MusicTrackOffs(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,(a0)			; humerously, Sonic 2 changed this to a "res" (equivilent is a 'bclr'), breaking the code

loc_7217C:
		adda.w	d6,a1
		dbf	d7,loc_7215A
		tst.w	$340(a6)
		bpl.s	loc_7218E
		bset	#2,$100(a6)

loc_7218E:
		tst.w	$370(a6)
		bpl.s	loc_7219A
		bset	#2,$1F0(a6)

loc_7219A:
		lea	$70(a6),a5
		moveq	#5,d4

loc_721A0:
		jsr	FMNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,loc_721A0
		moveq	#2,d4

loc_721AC:
		jsr	PSGNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,loc_721AC

loc_721B6:
		addq.w	#4,sp
		rts
; ===========================================================================
; FM channel assignment bits
; byte_721BA:
FMDACInitBytes:	dc.b 6,	0, 1, 2, 4, 5, 6, 0	; first byte is for DAC; then notice the 0, 1, 2 then 4, 5, 6; this is the gap between parts I and II for YM2612 port writes

; Default values for PSG tracks
; byte_721C2:
PSGInitBytes:	dc.b $80, $A0, $C0, 0		; specifically, these configure writes to the PSG port for each channel
; ===========================================================================
; ---------------------------------------------------------------------------
; Play normal sound effect
; ---------------------------------------------------------------------------
; loc_721C6: Sound_A0toCF:
PlaySound_CheckRing:
		tst.b	$27(a6)
		bne.w	loc_722C6
		tst.b	4(a6)
		bne.w	loc_722C6
		tst.b	$24(a6)
		bne.w	loc_722C6
		cmpi.b	#-$4B,d7	; is ring sound	effect played?
		bne.s	loc_721F4	; if not, branch
		tst.b	$2B(a6)
		bne.s	loc_721EE
		move.b	#-$32,d7	; play ring sound in left speaker

loc_721EE:
		bchg	#0,$2B(a6)	; change speaker

loc_721F4:
		cmpi.b	#-$59,d7	; is "pushing" sound played?
		bne.s	loc_72208	; if not, branch
		tst.b	$2C(a6)
		bne.w	locret_722C4
		move.b	#-$80,$2C(a6)

loc_72208:
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#-$60,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d1
		move.w	(a1)+,d1
		add.l	a3,d1
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_72228:
		moveq	#0,d3
		move.b	1(a1),d3
		move.b	d3,d4
		bmi.s	loc_72244
		subq.w	#2,d3
		lsl.w	#2,d3
		lea	MusicTrackOffs(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		bra.s	loc_7226E
; ===========================================================================

loc_72244:
		lsr.w	#3,d3
		lea	MusicTrackOffs(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		cmpi.b	#-$40,d4
		bne.s	loc_7226E
		move.b	d4,d0
		ori.b	#$1F,d0
		move.b	d0,(PSG_input).l
		bchg	#5,d0
		move.b	d0,(PSG_input).l

loc_7226E:
		movea.l	SFXTrackOffs(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#$B,d0

loc_72276:
		clr.l	(a2)+
		dbf	d0,loc_72276
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_722A8
		move.b	#-$40,$A(a5)
		move.l	d1,$20(a5)

loc_722A8:
		dbf	d7,loc_72228
		tst.b	$250(a6)
		bpl.s	loc_722B8
		bset	#2,$340(a6)

loc_722B8:
		tst.b	$310(a6)
		bpl.s	locret_722C4
		bset	#2,$370(a6)

locret_722C4:
		rts
; ===========================================================================

loc_722C6:
		clr.b	0(a6)
		rts
; ===========================================================================
; The following two tables are used for when an SFX terminates
; its track to properly restore the music track it temporarily took
; over.  Note that an important rule here is that no SFX may use
; DAC, FM Channel 1, FM Channel 2, or FM Channel 6, period.
; Thus there's also only SFX tracks starting at FM Channel 3.

; The zeroes appear after FM 3 because it calculates the offsets into
; these tables by their channel assignment, where between Channel 3
; and Channel 4 there is a gap numerically.
; dword_722CC:
MusicTrackOffs:	dc.l SoundDriver_RAM+$0D0	; FM3
		dc.l 0		; dummy
		dc.l SoundDriver_RAM+$100	; FM4
		dc.l SoundDriver_RAM+$130	; FM5
		dc.l SoundDriver_RAM+$190	; PSG1
		dc.l SoundDriver_RAM+$1C0	; PSG2
		dc.l SoundDriver_RAM+$1F0	; Plain PSG3
		dc.l SoundDriver_RAM+$1F0	; Noise
; dword_722EC:
SFXTrackOffs:	dc.l SoundDriver_RAM+$220	; SFX FM3
		dc.l 0		; dummy
		dc.l SoundDriver_RAM+$250	; SFX FM4
		dc.l SoundDriver_RAM+$280	; SFX FM5
		dc.l SoundDriver_RAM+$2B0	; SFX PSG1
		dc.l SoundDriver_RAM+$2E0	; SFX PSG2
		dc.l SoundDriver_RAM+$310	; Plain PSG3
		dc.l SoundDriver_RAM+$310	; Noise
; ===========================================================================
; ---------------------------------------------------------------------------
; Play GHZ waterfall sound
; ---------------------------------------------------------------------------
; loc_7230C:
PlaySound_Waterfall:
		tst.b	$27(a6)
		bne.w	locret_723C6
		tst.b	4(a6)
		bne.w	locret_723C6
		tst.b	$24(a6)
		bne.w	locret_723C6
		movea.l	(Go_SoundD0).l,a0
		subi.b	#-$30,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$20(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_72348:
		move.b	1(a1),d4
		bmi.s	loc_7235A
		bset	#2,$100(a6)
		lea	$340(a6),a5
		bra.s	loc_72364
; ===========================================================================

loc_7235A:
		bset	#2,$1F0(a6)
		lea	$370(a6),a5

loc_72364:
		movea.l	a5,a2
		moveq	#$B,d0

loc_72368:
		clr.l	(a2)+
		dbf	d0,loc_72368
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_72396
		move.b	#-$40,$A(a5)

loc_72396:
		dbf	d7,loc_72348
		tst.b	$250(a6)
		bpl.s	loc_723A6
		bset	#2,$340(a6)

loc_723A6:
		tst.b	$310(a6)
		bpl.s	locret_723C6
		bset	#2,$370(a6)
		ori.b	#$1F,d4
		move.b	d4,(PSG_input).l
		bchg	#5,d4
		move.b	d4,(PSG_input).l

locret_723C6:
		rts
; End of function PlaySoundByIndex

; ===========================================================================
; SpecialSFXTrackOffs:
		dc.l $FFF100, $FFF1F0, $FFF250,	$FFF310, $FFF340, $FFF370

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Snd_FadeOut1:
		clr.b	0(a6)
		lea	$220(a6),a5
		moveq	#5,d7

loc_723EA:
		tst.b	(a5)
		bpl.w	loc_72472
		bclr	#7,(a5)
		moveq	#0,d3
		move.b	1(a5),d3
		bmi.s	loc_7243C
		jsr	FMNoteOff(pc)
		cmpi.b	#4,d3
		bne.s	loc_72416
		tst.b	$340(a6)
		bpl.s	loc_72416
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_72428
; ===========================================================================

loc_72416:
		subq.b	#2,d3
		lsl.b	#2,d3
		lea	MusicTrackOffs(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	$18(a6),a1

loc_72428:
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)
		movea.l	a3,a5
		bra.s	loc_72472
; ===========================================================================

loc_7243C:
		jsr	PSGNoteOff(pc)
		lea	$370(a6),a0
		cmpi.b	#-$20,d3
		beq.s	loc_7245A
		cmpi.b	#-$40,d3
		beq.s	loc_7245A
		lsr.b	#3,d3
		lea	MusicTrackOffs(pc),a0
		movea.l	(a0,d3.w),a0

loc_7245A:
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#-$20,1(a0)
		bne.s	loc_72472
		move.b	$1F(a0),(PSG_input).l

loc_72472:
		adda.w	#$30,a5
		dbf	d7,loc_723EA
		rts
; End of function Snd_FadeOut1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Snd_FadeOut2:
		lea	$340(a6),a5
		tst.b	(a5)
		bpl.s	loc_724AE
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	loc_724AE
		jsr	loc_7270A(pc)
		lea	$100(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	loc_724AE
		movea.l	$18(a6),a1
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)

loc_724AE:
		lea	$370(a6),a5
		tst.b	(a5)
		bpl.s	locret_724E4
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	locret_724E4
		jsr	loc_729A6(pc)
		lea	$1F0(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	locret_724E4
		cmpi.b	#$E0,1(a5)
		bne.s	locret_724E4
		move.b	$1F(a5),(PSG_input).l

locret_724E4:
		rts
; End of function Snd_FadeOut2

; ===========================================================================
; ---------------------------------------------------------------------------
; Fade out music
; ---------------------------------------------------------------------------
; Sound_E0:
FadeOutMusic:
		jsr	Snd_FadeOut1(pc)
		jsr	Snd_FadeOut2(pc)
		move.b	#3,6(a6)
		move.b	#$28,4(a6)
		clr.b	$40(a6)
		clr.b	$2A(a6)
		rts
; End of function FadeOutMusic

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72504:
UpdateFadeOut:
		move.b	6(a6),d0
		beq.s	loc_72510
		subq.b	#1,6(a6)
		rts
; ===========================================================================

loc_72510:
		subq.b	#1,4(a6)
		beq.w	StopSoundAndMusic
		move.b	#3,6(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_72524:
		tst.b	(a5)
		bpl.s	loc_72538
		addq.b	#1,9(a5)
		bpl.s	loc_72534
		bclr	#7,(a5)
		bra.s	loc_72538
; ===========================================================================

loc_72534:
		jsr	SetChanVol(pc)

loc_72538:
		adda.w	#$30,a5
		dbf	d7,loc_72524
		moveq	#2,d7

loc_72542:
		tst.b	(a5)
		bpl.s	loc_72560
		addq.b	#1,9(a5)
		cmpi.b	#$10,9(a5)
		bcs.s	loc_72558
		bclr	#7,(a5)
		bra.s	loc_72560
; ===========================================================================

loc_72558:
		move.b	9(a5),d6
		jsr	PSGUpdateVol(pc)

loc_72560:
		adda.w	#$30,a5
		dbf	d7,loc_72542
		rts
; End of function UpdateFadeOut


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7256A:
FMSilenceAll:
		moveq	#2,d3
		moveq	#$28,d0

loc_7256E:
		move.b	d3,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1
		jsr	WriteFMI(pc)
		dbf	d3,loc_7256E
		moveq	#$40,d0
		moveq	#$7F,d1
		moveq	#2,d4

loc_72584:
		moveq	#3,d3

loc_72586:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.w	#4,d0
		dbf	d3,loc_72586
		subi.b	#$F,d0
		dbf	d4,loc_72584
		rts
; End of function FMSilenceAll

; ===========================================================================
; ---------------------------------------------------------------------------
; Stop music
; ---------------------------------------------------------------------------
; Sound_E4:
StopSoundAndMusic:
		moveq	#$2B,d0
		move.b	#-$80,d1
		jsr	WriteFMI(pc)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	WriteFMI(pc)
		movea.l	a6,a0
		move.w	#$E3,d0

loc_725B6:
		clr.l	(a0)+
		dbf	d0,loc_725B6
		move.b	#-$80,QueueToPlay(a6)	; set music to $80 (silence)
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
; End of function StopSoundAndMusic

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_725CA:
InitMusicPlayback:
		movea.l	a6,a0
		move.b	0(a6),d1
		move.b	$27(a6),d2
		move.b	$2A(a6),d3
		move.b	$26(a6),d4
		; Should be a long-word, otherwise PlaySound_Unk is broken
		move.w	SFXToPlay(a6),d5
		move.w	#$87,d0

loc_725E4:
		clr.l	(a0)+
		dbf	d0,loc_725E4
		move.b	d1,0(a6)
		move.b	d2,$27(a6)
		move.b	d3,$2A(a6)
		move.b	d4,$26(a6)
		; Should be a long-word, otherwise PlaySound_Unk is broken
		move.w	d5,SFXToPlay(a6)
		move.b	#-$80,QueueToPlay(a6)
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
; End of function InitMusicPlayback

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7260C:
TempoWait:
		move.b	2(a6),1(a6)
		lea	$4E(a6),a0
		moveq	#$30,d0
		moveq	#9,d1

loc_7261A:
		addq.b	#1,(a0)
		adda.w	d0,a0
		dbf	d1,loc_7261A
		rts
; End of function TempoWait

; ===========================================================================
; ---------------------------------------------------------------------------
; Speed	up music
; ---------------------------------------------------------------------------
; Sound_E2:
SpeedUpMusic:
		tst.b	$27(a6)
		bne.s	loc_7263E
		move.b	$29(a6),2(a6)
		move.b	$29(a6),1(a6)
		move.b	#-$80,$2A(a6)
		rts
; ===========================================================================

loc_7263E:
		move.b	$3C9(a6),$3A2(a6)
		move.b	$3C9(a6),$3A1(a6)
		move.b	#-$80,$3CA(a6)
		rts
; End of function SpeedUpMusic

; ===========================================================================
; ---------------------------------------------------------------------------
; Change music back to normal speed
; ---------------------------------------------------------------------------
; Sound_E3:
SlowDownMusic:
		tst.b	$27(a6)
		bne.s	loc_7266A
		move.b	$28(a6),2(a6)
		move.b	$28(a6),1(a6)
		clr.b	$2A(a6)
		rts
; ===========================================================================

loc_7266A:
		move.b	$3C8(a6),$3A2(a6)
		move.b	$3C8(a6),$3A1(a6)
		clr.b	$3CA(a6)
		rts
; End of function SlowDownMusic

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7267C:
UpdateFadeIn:
		tst.b	$25(a6)
		beq.s	loc_72688
		subq.b	#1,$25(a6)
		rts
; ===========================================================================

loc_72688:
		tst.b	$26(a6)
		beq.s	loc_726D6
		subq.b	#1,$26(a6)
		move.b	#2,$25(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_7269E:
		tst.b	(a5)
		bpl.s	loc_726AA
		subq.b	#1,9(a5)
		jsr	SetChanVol(pc)

loc_726AA:
		adda.w	#$30,a5
		dbf	d7,loc_7269E
		moveq	#2,d7

loc_726B4:
		tst.b	(a5)
		bpl.s	loc_726CC
		subq.b	#1,9(a5)
		move.b	9(a5),d6
		cmpi.b	#$10,d6
		bcs.s	loc_726C8
		moveq	#$F,d6

loc_726C8:
		jsr	PSGUpdateVol(pc)

loc_726CC:
		adda.w	#$30,a5
		dbf	d7,loc_726B4
		rts
; ===========================================================================

loc_726D6:
		bclr	#2,$40(a6)
		clr.b	$24(a6)
		rts
; End of function UpdateFadeIn

; ===========================================================================
; loc_726E2:
FMNoteOn:
		btst	#1,(a5)
		bne.s	locret_726FC
		btst	#2,(a5)
		bne.s	locret_726FC
		moveq	#$28,d0
		move.b	1(a5),d1
		ori.b	#$F0,d1
		bra.w	WriteFMI
; ===========================================================================

locret_726FC:
		rts
; End of function FMNoteOn

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_726FE:
FMNoteOff:
		btst	#4,(a5)
		bne.s	locret_72714
		btst	#2,(a5)
		bne.s	locret_72714

loc_7270A:
		moveq	#$28,d0
		move.b	1(a5),d1
		bra.w	WriteFMI
; ===========================================================================

locret_72714:
		rts
; End of function FMNoteOff

; ===========================================================================

loc_72716:				; CODE XREF: ROM:00072AE6j
		btst	#2,(a5)
		bne.s	locret_72720
		bra.w	WriteFMIorII
; ===========================================================================

locret_72720:				; CODE XREF: ROM:0007271Aj
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72722:
WriteFMIorII:
		btst	#2,1(a5)
		bne.s	loc_7275A
		add.b	1(a5),d0
; End of function WriteFMIorII


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7272E:
WriteFMI:
		move.b	(YM2612_a0).l,d2
		btst	#7,d2
		bne.s	WriteFMI
		move.b	d0,(YM2612_a0).l
		nop
		nop
		nop

loc_72746:
		move.b	(YM2612_a0).l,d2
		btst	#7,d2
		bne.s	loc_72746
		move.b	d1,(YM2612_d0).l
		rts
; End of function WriteFMI

; ===========================================================================
; START	OF FUNCTION CHUNK FOR WriteFMIorII

loc_7275A:
		move.b	1(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; END OF FUNCTION CHUNK	FOR WriteFMIorII

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72764:
WriteFMII:
		move.b	(YM2612_a0).l,d2
		btst	#7,d2
		bne.s	WriteFMII
		move.b	d0,(YM2612_a1).l
		nop
		nop
		nop

loc_7277C:
		move.b	(YM2612_a0).l,d2
		btst	#7,d2
		bne.s	loc_7277C
		move.b	d1,(MY2612_d1).l
		rts
; End of function WriteFMII

; ===========================================================================
; word_72790:
FMFrequencies:	dc.w $25E, $284, $2AB, $2D3, $2FE, $32D, $35C, $38F, $3C5
		dc.w $3FF, $43C, $47C, $A5E, $A84, $AAB, $AD3, $AFE, $B2D
		dc.w $B5C, $B8F, $BC5, $BFF, $C3C, $C7C, $125E,	$1284
		dc.w $12AB, $12D3, $12FE, $132D, $135C,	$138F, $13C5, $13FF
		dc.w $143C, $147C, $1A5E, $1A84, $1AAB,	$1AD3, $1AFE, $1B2D
		dc.w $1B5C, $1B8F, $1BC5, $1BFF, $1C3C,	$1C7C, $225E, $2284
		dc.w $22AB, $22D3, $22FE, $232D, $235C,	$238F, $23C5, $23FF
		dc.w $243C, $247C, $2A5E, $2A84, $2AAB,	$2AD3, $2AFE, $2B2D
		dc.w $2B5C, $2B8F, $2BC5, $2BFF, $2C3C,	$2C7C, $325E, $3284
		dc.w $32AB, $32D3, $32FE, $332D, $335C,	$338F, $33C5, $33FF
		dc.w $343C, $347C, $3A5E, $3A84, $3AAB,	$3AD3, $3AFE, $3B2D
		dc.w $3B5C, $3B8F, $3BC5, $3BFF, $3C3C,	$3C7C

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72850:
PSGUpdateTrack:
		subq.b	#1,$E(a5)
		bne.s	loc_72866
		bclr	#4,(a5)
		jsr	PSGDoNext(pc)
		jsr	PSGDoNoteOn(pc)
		bra.w	PSGDoVolFX
; ===========================================================================

loc_72866:
		jsr	NoteFillUpdate(pc)
		jsr	PSGUpdateVolFX(pc)
		jsr	DoModulation(pc)
		jsr	PSGUpdateFreq(pc)
		rts
; End of function PSGUpdateTrack


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72878:
PSGDoNext:
		bclr	#1,(a5)
		movea.l	4(a5),a4

loc_72880:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#-$20,d5
		bcs.s	loc_72890
		jsr	CoordFlag(pc)
		bra.s	loc_72880
; ===========================================================================

loc_72890:
		tst.b	d5
		bpl.s	loc_728A4
		jsr	PSGSetFreq(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	loc_728A4
		subq.w	#1,a4
		bra.w	FinishTrackUpdate
; ===========================================================================

loc_728A4:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; End of function PSGDoNext


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_728AC:
PSGSetFreq:
		subi.b	#-$7F,d5
		bcs.s	loc_728CA
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	PSGFrequencies(pc),a0
		move.w	(a0,d5.w),$10(a5)
		bra.w	FinishTrackUpdate
; ===========================================================================

loc_728CA:
		bset	#1,(a5)
		move.w	#$FFFF,$10(a5)
		jsr	FinishTrackUpdate(pc)
		bra.w	PSGNoteOff
; End of function PSGSetFreq


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_728DC:
PSGDoNoteOn:
		move.w	$10(a5),d6
		bmi.s	loc_72920

; sub_728E2:
PSGUpdateFreq:
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_7291E
		btst	#1,(a5)
		bne.s	locret_7291E
		move.b	1(a5),d0
		cmpi.b	#-$20,d0
		bne.s	loc_72904
		move.b	#-$40,d0

loc_72904:
		move.w	d6,d1
		andi.b	#$F,d1
		or.b	d1,d0
		lsr.w	#4,d6
		andi.b	#$3F,d6
		move.b	d0,(PSG_input).l
		move.b	d6,(PSG_input).l

locret_7291E:
		rts
; ===========================================================================

loc_72920:
		bset	#1,(a5)
		rts
; End of function PSGDoNoteOn

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72926:
PSGUpdateVolFX:
		tst.b	$B(a5)
		beq.w	locret_7298A
; loc_7292E:
PSGDoVolFX:
		move.b	9(a5),d6
		moveq	#0,d0
		move.b	$B(a5),d0
		beq.s	PSGUpdateVol
		movea.l	(Go_PSGIndex).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	$C(a5),d0
		move.b	(a0,d0.w),d0
		addq.b	#1,$C(a5)
		btst	#7,d0
		beq.s	loc_72960
		cmpi.b	#-$80,d0
		beq.s	VolEnvHold

loc_72960:
		add.w	d0,d6
		cmpi.b	#$10,d6
		bcs.s	PSGUpdateVol
		moveq	#$F,d6
; End of function PSGUpdateVolFX


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7296A:
PSGUpdateVol:
		btst	#1,(a5)
		bne.s	locret_7298A
		btst	#2,(a5)
		bne.s	locret_7298A
		btst	#4,(a5)
		bne.s	loc_7298C

loc_7297C:
		or.b	1(a5),d6
		addi.b	#$10,d6
		move.b	d6,(PSG_input).l

locret_7298A:
		rts
; ===========================================================================

loc_7298C:
		tst.b	$13(a5)
		beq.s	loc_7297C
		tst.b	$12(a5)
		bne.s	loc_7297C
		rts
; End of function PSGUpdateVol

; ===========================================================================
; loc_7299A:
VolEnvHold:
		subq.b	#1,$C(a5)
		rts
; End of function PSGUpdateVolFX

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_729A0:
PSGNoteOff:
		btst	#2,(a5)		; is "SFX override" bit set?
		bne.s	locret_729B4	; if yes, quit!

loc_729A6:
		move.b	1(a5),d0	; get "voice control" byte (loads upper bits which specify attenuation setting)
		ori.b	#$1F,d0		; attenuation Off
		move.b	d0,(PSG_input).l

locret_729B4:
		rts
; End of function PSGNoteOff


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_729B6:
PSGSilenceAll:
		lea	(PSG_input).l,a0
		move.b	#-$61,(a0)
		move.b	#-$41,(a0)
		move.b	#-$21,(a0)
		move.b	#-1,(a0)
		rts
; End of function PSGSilenceAll

; ===========================================================================
; word_729CE:
PSGFrequencies:	dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A
		dc.w $1FB, $1DF, $1C4, $1AB, $193, $17D, $167, $153, $140
		dc.w $12E, $11D, $10D, $FE, $EF, $E2, $D6, $C9,	$BE, $B4
		dc.w $A9, $A0, $97, $8F, $87, $7F, $78,	$71, $6B, $65
		dc.w $5F, $5A, $55, $50, $4B, $47, $43,	$40, $3C, $39
		dc.w $36, $33, $30, $2D, $2B, $28, $26,	$24, $22, $20
		dc.w $1F, $1D, $1B, $1A, $18, $17, $16,	$15, $13, $12
		dc.w $11, 0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72A5A:
CoordFlag:
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	coordflagLookup(pc,d5.w)
; End of function CoordFlag

; ===========================================================================
; loc_72A64:
coordflagLookup:
		bra.w	cfPanningAMSFMS		; $E0
		bra.w	cfDetune		; $E1
		bra.w	cfSetCommunication	; $E2
		bra.w	cfJumpReturn		; $E3
		bra.w	cfFadeInToPrevious	; $E4
		bra.w	cfSetTempoDivider	; $E5
		bra.w	cfChangeFMVolume        ; $E6
		bra.w	cfHoldNote              ; $E7
		bra.w	cfNoteTimeout           ; $E8
		bra.w	cfChangeTransposition   ; $E9
		bra.w	cfSetTempo              ; $EA
		bra.w	cfSetTempoDividerAll    ; $EB
		bra.w	cfChangePSGVolume	; $EC
		bra.w	cfClearPush             ; $ED
		bra.w	cfStopSpecialFM4        ; $EE
		bra.w	cfSetVoice		; $EF
		bra.w	cfModulation            ; $F0
		bra.w	cfEnableModulation	; $F1
		bra.w	cfStopTrack		; $F2
		bra.w	cfSetPSGNoise		; $F3
		bra.w	cfDisableModulation	; $F4
		bra.w	cfSetPSGTone		; $F5
		bra.w	cfJumpTo		; $F6
		bra.w	cfRepeatAtPos		; $F7
		bra.w	cfJumpToGosub		; $F8
		bra.w	cfOpF9			; $F9
; ===========================================================================
; Sets either AMS or FMS panning, can't be both.
; loc_72ACC:
cfPanningAMSFMS:
		move.b	(a4)+,d1
		tst.b	1(a5)
		bmi.s	locret_72AEA
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#-$4C,d0
		bra.w	loc_72716
; ===========================================================================

locret_72AEA:
		rts
; ===========================================================================
; Alters notes by XX.
; loc_72AEC:
cfDetune:
		move.b	(a4)+,$1E(a5)
		rts
; ===========================================================================
; Set otherwise unused communication byte to parameter, used for triggering
; a boss' attacks in Ristar.
; loc_72AF2:
cfSetCommunication:
		move.b	(a4)+,7(a6)
		rts
; ===========================================================================
; Return (Sonic 1 & 2).
; loc_72AF8:
cfJumpReturn:
		moveq	#0,d0
		move.b	$D(a5),d0
		movea.l	(a5,d0.w),a4
		move.l	#0,(a5,d0.w)
		addq.w	#2,a4
		addq.b	#4,d0
		move.b	d0,$D(a5)
		rts
; ===========================================================================
; Fade-in to previous song (needed on DAC channel, Sonic 1 & 2).
; loc_72B14:
cfFadeInToPrevious:
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_72B1E:
		move.l	(a1)+,(a0)+
		dbf	d0,loc_72B1E
		bset	#2,$40(a6)
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	$26(a6),d6
		moveq	#5,d7
		lea	$70(a6),a5

loc_72B3A:
		btst	#7,(a5)
		beq.s	loc_72B5C
		bset	#1,(a5)
		add.b	d6,9(a5)
		btst	#2,(a5)
		bne.s	loc_72B5C
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		jsr	sub_72C4E(pc)

loc_72B5C:
		adda.w	#$30,a5
		dbf	d7,loc_72B3A
		moveq	#2,d7

loc_72B66:
		btst	#7,(a5)
		beq.s	loc_72B78
		bset	#1,(a5)
		jsr	PSGNoteOff(pc)
		add.b	d6,9(a5)

loc_72B78:
		adda.w	#$30,a5
		dbf	d7,loc_72B66
		movea.l	a3,a5
		move.b	#-$80,$24(a6)
		move.b	#$28,$26(a6)
		clr.b	$27(a6)
		move.w	#0,(Z80_Bus_Request).l
		addq.w	#8,sp
		rts
; ===========================================================================
; Used to change the tempo divider
; loc_72B9E:
cfSetTempoDivider:				; CODE XREF: ROM:00072A78j
		move.b	(a4)+,2(a5)
		rts
; ===========================================================================
; Changing an FM channels volume
; loc_72BA4:
cfChangeFMVolume:				; CODE XREF: ROM:00072A7Cj
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		bra.w	SetChanVol
; ===========================================================================
; Basically a no-attack flag.
; loc_72BAE:
cfHoldNote:				; CODE XREF: ROM:00072A80j
		bset	#4,(a5)
		rts
; ===========================================================================
; Number of frames until a note is dead
; loc_72BB4:
cfNoteTimeout:				; CODE XREF: ROM:00072A84j
		move.b	(a4),$12(a5)
		move.b	(a4)+,$13(a5)
		rts
; ===========================================================================
; Adds a (signed) number to the channel key displacement
; loc_72BBE:
cfChangeTransposition:				; CODE XREF: ROM:00072A88j
		move.b	(a4)+,d0
		add.b	d0,8(a5)
		rts
; ===========================================================================
; Sets the tempo of the song
; loc_72BC6:
cfSetTempo:				; CODE XREF: ROM:00072A8Cj
		move.b	(a4),2(a6)
		move.b	(a4)+,1(a6)
		rts
; ===========================================================================
; Sets the tempo divider for all music tracks (does nothing on SFX)
;loc_72BD0:
cfSetTempoDividerAll:                   ; CODE XREF: ROM:00072A90j
		lea	$40(a6),a0
		move.b	(a4)+,d0
		moveq	#$30,d1
		moveq	#9,d2

loc_72BDA:				; CODE XREF: ROM:00072BE0j
		move.b	d0,2(a0)
		adda.w	d1,a0
		dbf	d2,loc_72BDA
		rts
; ===========================================================================
; Basically a PSG version of cfChangeFMVolume
; (it does work on FM channels but only on next voice change)
; loc_72BE6:
cfChangePSGVolume:				; CODE XREF: ROM:00072A94j
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		rts
; ===========================================================================
; Clears the "pushing" flag on the pushing sound
; loc_72BEE:
cfClearPush:				; CODE XREF: ROM:00072A98j
		clr.b	$2C(a6)
		rts
; ===========================================================================
; Stops FM4 if it's on a special SFX and in $D0-$DF
; (does nothing on any other channel/SFX, otherwise it'll send it to currently playing music)
; loc_72BF4:
cfStopSpecialFM4:				; CODE XREF: ROM:00072A9Cj
		bclr	#7,(a5)
		bclr	#4,(a5)
		jsr	FMNoteOff(pc)
		tst.b	$250(a6)
		bmi.s	loc_72C22
		movea.l	a5,a3
		lea	$100(a6),a5
		movea.l	$18(a6),a1
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)
		movea.l	a3,a5

loc_72C22:				; CODE XREF: ROM:00072C04j
		addq.w	#8,sp
		rts
; ===========================================================================
; Changes the voice to the specified parameter (not meant for PSG/DAC)
; loc_72C26:
cfSetVoice:				; CODE XREF: ROM:00072AA0j
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	d0,$B(a5)
		btst	#2,(a5)
		bne.w	locret_72CAA
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	sub_72C4E
		movea.l	$20(a5),a1
		tst.b	$E(a6)
		bmi.s	sub_72C4E
		movea.l	$20(a6),a1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_72C4E:				; CODE XREF: ROM:00072C3Ej
					; ROM:00072C48j
					; DATA XREF: ...
		subq.w	#1,d0
		bmi.s	loc_72C5C
		move.w	#$19,d1

loc_72C56:				; CODE XREF: sub_72C4E+Aj
		adda.w	d1,a1
		dbf	d0,loc_72C56

loc_72C5C:				; CODE XREF: sub_72C4E+2j
		move.b	(a1)+,d1
		move.b	d1,$1F(a5)
		move.b	d1,d4
		move.b	#-$50,d0
		jsr	WriteFMIorII(pc)
		lea	byte_72D18(pc),a2
		moveq	#$13,d3

loc_72C72:				; CODE XREF: sub_72C4E+2Cj
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	WriteFMIorII(pc)
		dbf	d3,loc_72C72
		moveq	#3,d5
		andi.w	#7,d4
		move.b	byte_72CAC(pc,d4.w),d4
		move.b	9(a5),d3

loc_72C8C:				; CODE XREF: sub_72C4E+4Cj
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_72C96
		add.b	d3,d1

loc_72C96:				; CODE XREF: sub_72C4E+44j
		jsr	WriteFMIorII(pc)
		dbf	d5,loc_72C8C
		move.b	#-$4C,d0
		move.b	$A(a5),d1
		jsr	WriteFMIorII(pc)

locret_72CAA:				; CODE XREF: ROM:00072C32j
		rts
; End of function sub_72C4E

; ===========================================================================
byte_72CAC:	dc.b   8,  8,  8,  8	; 0
		dc.b  $A, $E, $E, $F	; 4

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_72CB4:
SetChanVol:
		btst	#2,(a5)
		bne.s	locret_72D16
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	loc_72CD8
		movea.l	$20(a6),a1
		tst.b	$E(a6)
		bmi.s	loc_72CD8
		movea.l	$20(a6),a1

loc_72CD8:
		subq.w	#1,d0
		bmi.s	loc_72CE6
		move.w	#$19,d1

loc_72CE0:
		adda.w	d1,a1
		dbf	d0,loc_72CE0

loc_72CE6:
		adda.w	#$15,a1
		lea	byte_72D2C(pc),a2
		move.b	$1F(a5),d0
		andi.w	#7,d0
		move.b	byte_72CAC(pc,d0.w),d4
		move.b	9(a5),d3
		bmi.s	locret_72D16
		moveq	#3,d5

loc_72D02:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_72D12
		add.b	d3,d1
		bcs.s	loc_72D12
		jsr	WriteFMIorII(pc)

loc_72D12:
		dbf	d5,loc_72D02

locret_72D16:
		rts
; End of function SetChanVol

; ===========================================================================
byte_72D18:	dc.b $30, $38, $34, $3C, $50, $58, $54,	$5C, $60, $68
		dc.b $64, $6C, $70, $78, $74, $7C, $80,	$88, $84, $8C
byte_72D2C:	dc.b $40, $48, $44, $4C
; ===========================================================================
; Uses 4 parameters, wait speed, modulation speed, change per step, and number of steps
; loc_72D30:
cfModulation:				; CODE XREF: ROM:00072AA4j
		bset	#3,(a5)
		move.l	a4,$14(a5)
		move.b	(a4)+,$18(a5)
		move.b	(a4)+,$19(a5)
		move.b	(a4)+,$1A(a5)
		move.b	(a4)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ===========================================================================
; Enables modulation (only recommended to use this after the flag above)
; loc_72D52:
cfEnableModulation:				; CODE XREF: ROM:00072AA8j
		bset	#3,(a5)
		rts
; ===========================================================================
; Stops the current track
; loc_72D58:
cfStopTrack:				; CODE XREF: ROM:00072AACj
		bclr	#7,(a5)
		bclr	#4,(a5)
		tst.b	1(a5)
		bmi.s	loc_72D74
		tst.b	8(a6)
		bmi.w	loc_72E02
		jsr	FMNoteOff(pc)
		bra.s	loc_72D78
; ===========================================================================

loc_72D74:				; CODE XREF: ROM:00072D64j
		jsr	PSGNoteOff(pc)

loc_72D78:				; CODE XREF: ROM:00072D72j
		tst.b	$E(a6)
		bpl.w	loc_72E02
		clr.b	0(a6)
		moveq	#0,d0
		move.b	1(a5),d0
		bmi.s	loc_72DCC
		lea	MusicTrackOffs(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0
		bne.s	loc_72DA8
		tst.b	$340(a6)
		bpl.s	loc_72DA8
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_72DB8
; ===========================================================================

loc_72DA8:				; CODE XREF: ROM:00072D96j
					; ROM:00072D9Cj
		subq.b	#2,d0
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	(a5)
		bpl.s	loc_72DC8
		movea.l	$18(a6),a1

loc_72DB8:				; CODE XREF: ROM:00072DA6j
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_72C4E(pc)

loc_72DC8:				; CODE XREF: ROM:00072DB2j
		movea.l	a3,a5
		bra.s	loc_72E02
; ===========================================================================

loc_72DCC:				; CODE XREF: ROM:00072D8Aj
		lea	$370(a6),a0
		tst.b	(a0)
		bpl.s	loc_72DE0
		cmpi.b	#-$20,d0
		beq.s	loc_72DEA
		cmpi.b	#-$40,d0
		beq.s	loc_72DEA

loc_72DE0:				; CODE XREF: ROM:00072DD2j
		lea	MusicTrackOffs(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

loc_72DEA:				; CODE XREF: ROM:00072DD8j
					; ROM:00072DDEj
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#-$20,1(a0)
		bne.s	loc_72E02
		move.b	$1F(a0),(PSG_input).l

loc_72E02:				; CODE XREF: ROM:00072D6Aj
					; ROM:00072D7Cj ...
		addq.w	#8,sp
		rts
; ===========================================================================
; Turns on the noise channel (only use $E0 - $E7 as parameter bytes)
; loc_72E06
cfSetPSGNoise:				; CODE XREF: ROM:00072AB0j
		move.b	#-$20,1(a5)
		move.b	(a4)+,$1F(a5)
		btst	#2,(a5)
		bne.s	locret_72E1E
		move.b	-1(a4),(PSG_input).l

locret_72E1E:				; CODE XREF: ROM:00072E14j
		rts
; ===========================================================================
; Disables modulation
; loc_72E20:
cfDisableModulation:				; CODE XREF: ROM:00072AB4j
		bclr	#3,(a5)
		rts
; ===========================================================================
; Uses parameter byte to change the PSG envelope
; loc_72E26:
cfSetPSGTone:				; CODE XREF: ROM:00072AB8j
		move.b	(a4)+,$B(a5)
		rts
; ===========================================================================
; SMPS equevilant of JMP (2-byte big endian offset + 1)
; loc_72E2C:
cfJumpTo:				; CODE XREF: ROM:00072ABCj
					; ROM:00072E4Cj ...
		move.b	(a4)+,d0
		lsl.w	#8,d0
		move.b	(a4)+,d0
		adda.w	d0,a4
		subq.w	#1,a4
		rts
; ===========================================================================
; Repeat a section of music (1 byte to indicate how many times to loop and 2-byte big endian offset + 1)
; loc_72E38:
cfRepeatAtPos:				; CODE XREF: ROM:00072AC0j
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		tst.b	$24(a5,d0.w)
		bne.s	loc_72E48
		move.b	d1,$24(a5,d0.w)

loc_72E48:				; CODE XREF: ROM:00072E42j
		subq.b	#1,$24(a5,d0.w)
		bne.s	cfJumpTo
		addq.w	#2,a4
		rts
; ===========================================================================
; This is basically an SMPS equivelant of BSR
; loc_72E52:
cfJumpToGosub:				; CODE XREF: ROM:00072AC4j
		moveq	#0,d0
		move.b	$D(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,$D(a5)
		bra.s	cfJumpTo
; ===========================================================================
; This is a really weird flag...
; Sets the D1R max volume and RR to max for operators 3 and 4 of FM1
; loc_72E64:
cfOpF9:				; CODE XREF: ROM:00072AC8j
		move.b	#-$78,d0
		move.b	#$F,d1
		jsr	WriteFMI(pc)
		move.b	#-$74,d0
		move.b	#$F,d1
		bra.w	WriteFMI
; ===========================================================================
Kos_Z80:	incbin	"sound/DAC Driver.bin"
		even
Mus_GHZ:	incbin	"sound/music/GHZ.bin"
		even
Mus_LZ:		incbin  "sound/music/LZ.bin"
		even
Mus_MZ:		incbin  "sound/music/MZ.bin"
		even
Mus_SLZ:	incbin  "sound/music/SLZ.bin"
		even
Mus_SYZ:	incbin  "sound/music/SYZ.bin"
		even
Mus_SBZ:	incbin  "sound/music/SBZ.bin"
		even
Mus_Inv:	incbin  "sound/music/Invincibility.bin"
		even
Mus_ExtraLife:	incbin  "sound/music/Extra Life.bin"
		even
Mus_SS:		incbin  "sound/music/Special Stage.bin"
		even
Mus_Title:	incbin	"sound/music/Title screen.bin"
		even
Mus_Ending:	incbin	"sound/music/Ending.bin"
		even
Mus_Boss:	incbin	"sound/music/Boss.bin"
		even
Mus_FZ:		incbin	"sound/music/FZ.bin"
		even
Mus_SonicGotThrough:	incbin	"sound/music/Sonic Got Through.bin"
		even
Mus_GameOver:	incbin	"sound/music/Game Over.bin"
		even
Mus_Continue:	incbin	"sound/music/Continue Screen.bin"
		even
Mus_Credits:	incbin	"sound/music/Credits.bin"
		even
Mus_Drowning:	incbin	"sound/music/Drowning.bin"
		even
Mus_Emerald:	incbin	"sound/music/Emerald.bin"
		even
; ---------------------------------------------------------------------------
; Sound	effect pointers
; ---------------------------------------------------------------------------
SoundIndex:	dc.l SoundA0, SoundA1, SoundA2,	SoundA3, SoundA4, SoundA5
		dc.l SoundA6, SoundA7, SoundA8,	SoundA9, SoundAA, SoundAB
		dc.l SoundAC, SoundAD, SoundAE,	SoundAF, SoundB0, SoundB1
		dc.l SoundB2, SoundB3, SoundB4,	SoundB5, SoundB6, SoundB7
		dc.l SoundB8, SoundB9, SoundBA,	SoundBB, SoundBC, SoundBD
		dc.l SoundBE, SoundBF, SoundC0,	SoundC1, SoundC2, SoundC3
		dc.l SoundC4, SoundC5, SoundC6,	SoundC7, SoundC8, SoundC9
		dc.l SoundCA, SoundCB, SoundCC,	SoundCD, SoundCE, SoundCF
SoundD0Index:	dc.l SoundD0
SoundA0:	incbin	"sound/sfx/SndA0 - Jump.bin"
		even
SoundA1:	incbin	"sound/sfx/SndA1 - Lamppost.bin"
		even
SoundA2:	incbin	"sound/sfx/SndA2.bin"
		even
SoundA3:	incbin	"sound/sfx/SndA3 - Death.bin"
		even
SoundA4:	incbin	"sound/sfx/SndA4 - Skid.bin"
		even
SoundA5:	incbin	"sound/sfx/SndA5.bin"
		even
SoundA6:	incbin	"sound/sfx/SndA6 - Hit Spikes.bin"
		even
SoundA7:	incbin	"sound/sfx/SndA7 - Push Block.bin"
		even
SoundA8:	incbin	"sound/sfx/SndA8 - SS Goal.bin"
		even
SoundA9:	incbin	"sound/sfx/SndA9 - SS Item.bin"
		even
SoundAA:	incbin	"sound/sfx/SndAA - Splash.bin"
		even
SoundAB:	incbin	"sound/sfx/SndAB.bin"
		even
SoundAC:	incbin	"sound/sfx/SndAC - Hit Boss.bin"
		even
SoundAD:	incbin	"sound/sfx/SndAD - Get Bubble.bin"
		even
SoundAE:	incbin	"sound/sfx/SndAE - Fireball.bin"
		even
SoundAF:	incbin	"sound/sfx/SndAF - Shield.bin"
		even
SoundB0:	incbin	"sound/sfx/SndB0 - Saw.bin"
		even
SoundB1:	incbin	"sound/sfx/SndB1 - Electric.bin"
		even
SoundB2:	incbin	"sound/sfx/SndB2 - Drown Death.bin"
		even
SoundB3:	incbin	"sound/sfx/SndB3 - Flamethrower.bin"
		even
SoundB4:	incbin	"sound/sfx/SndB4 - Bumper.bin"
		even
SoundB5:	incbin	"sound/sfx/SndB5 - Ring.bin"
		even
SoundB6:	incbin	"sound/sfx/SndB6 - Spikes Move.bin"
		even
SoundB7:	incbin	"sound/sfx/SndB7 - Rumbling.bin"
		even
SoundB8:	incbin	"sound/sfx/SndB8.bin"
		even
SoundB9:	incbin	"sound/sfx/SndB9 - Collapse.bin"
		even
SoundBA:	incbin	"sound/sfx/SndBA - SS Glass.bin"
		even
SoundBB:	incbin	"sound/sfx/SndBB - Door.bin"
		even
SoundBC:	incbin	"sound/sfx/SndBC - Teleport.bin"
		even
SoundBD:	incbin	"sound/sfx/SndBD - ChainStomp.bin"
		even
SoundBE:	incbin	"sound/sfx/SndBE - Roll.bin"
		even
SoundBF:	incbin	"sound/sfx/SndBF - Get Continue.bin"
		even
SoundC0:	incbin	"sound/sfx/SndC0 - Basaran Flap.bin"
		even
SoundC1:	incbin	"sound/sfx/SndC1 - Break Item.bin"
		even
SoundC2:	incbin	"sound/sfx/SndC2 - Drown Warning.bin"
		even
SoundC3:	incbin	"sound/sfx/SndC3 - Giant Ring.bin"
		even
SoundC4:	incbin	"sound/sfx/SndC4 - Bomb.bin"
		even
SoundC5:	incbin	"sound/sfx/SndC5 - Cash Register.bin"
		even
SoundC6:	incbin	"sound/sfx/SndC6 - Ring Loss.bin"
		even
SoundC7:	incbin	"sound/sfx/SndC7 - Chain Rising.bin"
		even
SoundC8:	incbin	"sound/sfx/SndC8 - Burning.bin"
		even
SoundC9:	incbin	"sound/sfx/SndC9 - Hidden Bonus.bin"
		even
SoundCA:	incbin	"sound/sfx/SndCA - Enter SS.bin"
		even
SoundCB:	incbin	"sound/sfx/SndCB - Wall Smash.bin"
		even
SoundCC:	incbin	"sound/sfx/SndCC - Spring.bin"
		even
SoundCD:	incbin	"sound/sfx/SndCD - Switch.bin"
		even
SoundCE:	incbin	"sound/sfx/SndCE - Ring Left Speaker.bin"
		even
SoundCF:	incbin	"sound/sfx/SndCF - Signpost.bin"
		even
SoundD0:	incbin	"sound/sfx/SndD0 - Waterfall.bin"
		even
		;bankalign Size_of_SegaPCM		; The DAC driver doesn't change banks automatically
Snd_Sega:	incbin	"sound/PCM/SEGA.bin"		; so we need to make it not cross a $8000 byte boundary
Snd_Sega_End:	even

		if Snd_Sega_End-Snd_Sega>$8000
			inform 3,"Sega sound must fit within $8000 bytes, but you have a $%h byte Sega sound.",SegaPCM_End-SegaPCM
		endc
		if Snd_Sega_End-Snd_Sega>Size_of_SegaPCM
			inform 3,"Size_of_SegaPCM = $%h, but you have a $%h byte Sega sound.",Size_of_SegaPCM,SegaPCM_End-SegaPCM
		endc