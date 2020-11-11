; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
; PLC IDs
PLCID_Std1:		equ (PLCptr_Std1-ArtLoadCues)/2
PLCID_Std2:		equ (PLCptr_Std2-ArtLoadCues)/2
PLCID_Explosion:	equ (PLCptr_Explosion-ArtLoadCues)/2
PLCID_GameOver:		equ (PLCptr_GameOver-ArtLoadCues)/2
PLCID_GHZ:		equ (PLCptr_GHZ-ArtLoadCues)/2
PLCID_GHZ2:		equ (PLCptr_GHZ2-ArtLoadCues)/2
PLCID_LZ:		equ (PLCptr_LZ-ArtLoadCues)/2
PLCID_LZ2:		equ (PLCptr_LZ2-ArtLoadCues)/2
PLCID_CPZ:		equ (PLCptr_CPZ-ArtLoadCues)/2
PLCID_CPZ2:		equ (PLCptr_CPZ2-ArtLoadCues)/2
PLCID_EHZ:		equ (PLCptr_EHZ-ArtLoadCues)/2
PLCID_EHZ2:		equ (PLCptr_EHZ2-ArtLoadCues)/2
PLCID_HPZ:		equ (PLCptr_HPZ-ArtLoadCues)/2
PLCID_HPZ2:		equ (PLCptr_HPZ2-ArtLoadCues)/2
PLCID_HTZ:		equ (PLCptr_HTZ-ArtLoadCues)/2
PLCID_HTZ2:		equ (PLCptr_HTZ2-ArtLoadCues)/2
PLCID_S1TitleCard:	equ (PLCptr_S1TitleCard-ArtLoadCues)/2
PLCID_Boss:		equ (PLCptr_Boss-ArtLoadCues)/2
PLCID_Signpost:		equ (PLCptr_Signpost-ArtLoadCues)/2
PLCID_S1Warp:		equ (PLCptr_S1Warp-ArtLoadCues)/2
PLCID_S1SpecialStage:	equ (PLCptr_S1SpecialStage-ArtLoadCues)/2
PLCID_GHZAnimals:	equ (PLCptr_GHZAnimals-ArtLoadCues)/2
PLCID_LZAnimals:	equ (PLCptr_LZAnimals-ArtLoadCues)/2
PLCID_CPZAnimals:	equ (PLCptr_CPZAnimals-ArtLoadCues)/2
PLCID_EHZAnimals:	equ (PLCptr_EHZAnimals-ArtLoadCues)/2
PLCID_HPZAnimals:	equ (PLCptr_HPZAnimals-ArtLoadCues)/2
PLCID_HTZAnimals:	equ (PLCptr_HTZAnimals-ArtLoadCues)/2
PLCID_S1SSResults:	equ (PLCptr_S1SSResults-ArtLoadCues)/2
PLCID_S1Ending:		equ (PLCptr_S1Ending-ArtLoadCues)/2
PLCID_S1TryAgain:	equ (PLCptr_S1TryAgain-ArtLoadCues)/2
PLCID_S1EggmanSBZ2:	equ (PLCptr_S1EggmanSBZ2-ArtLoadCues)/2
PLCID_S1FZBoss:		equ (PLCptr_S1FZBoss-ArtLoadCues)/2

; ---------------------------------------------------------------------------
; Variables
RAM_Start:			equ	$FFFF0000		; 4 bytes

; Level variables
Chunk_Table:			equ	$FFFF0000		; $8000 bytes
Level_Layout:			equ	$FFFF8000		; $1000 bytes
Block_Table:			equ	$FFFF9000		; $C00 bytes
TempArray_LayerDef:		equ	$FFFFA800		; $200 bytes
Decomp_Buffer:			equ	$FFFFAA00		; $200 bytes

; Object variables
Sprite_Table_Input:		equ	$FFFFAC00		; $400 bytes
Ring_Positions:			equ	$FFFFE800		; $600 bytes

; Camera variables
Camera_RAM:			equ	$FFFFEE00		; 4 bytes
Camera_X_pos:			equ	$FFFFEE00		; 4 bytes ; same as Camera_RAM but with different meaning
Camera_Y_pos:			equ	$FFFFEE04		; 4 bytes
Camera_BG_X_pos:		equ	$FFFFEE08		; 4 bytes
Camera_BG_Y_pos:		equ	$FFFFEE0C		; 4 bytes
Camera_BG2_X_pos:		equ	$FFFFEE10		; 4 bytes
Camera_BG2_Y_pos:		equ	$FFFFEE14		; 4 bytes
Camera_BG3_X_pos:		equ	$FFFFEE18		; 4 bytes
Camera_BG3_Y_pos:		equ	$FFFFEE1C		; 4 bytes
Camera_X_pos_P2:		equ	$FFFFEE20		; 4 bytes
Camera_Y_pos_P2:		equ	$FFFFEE24		; 4 bytes
Camera_BG_X_pos_P2:		equ	$FFFFEE28		; 4 bytes
Camera_BG_Y_pos_P2:		equ	$FFFFEE2C		; 4 bytes
Camera_BG2_X_pos_P2:		equ	$FFFFEE30		; 2 bytes
Camera_BG2_Y_pos_P2:		equ	$FFFFEE34		; 4 bytes
Camera_BG3_X_pos_P2:		equ	$FFFFEE38		; 2 bytes
Camera_BG3_Y_pos_P2:		equ	$FFFFEE3C		; 4 bytes
Horiz_block_crossed_flag:	equ	$FFFFEE40		; 1 byte
Verti_block_crossed_flag:	equ	$FFFFEE41		; 1 byte
Horiz_block_crossed_flag_BG:	equ	$FFFFEE42		; 1 byte
Verti_block_crossed_flag_BG:	equ	$FFFFEE43		; 1 byte
Horiz_block_crossed_flag_BG2:	equ	$FFFFEE44		; 1 byte
Horiz_block_crossed_flag_BG3:	equ	$FFFFEE46		; 1 byte
Horiz_block_crossed_flag_P2:	equ	$FFFFEE48		; 1 byte
Verti_block_crossed_flag_P2:	equ	$FFFFEE49		; 1 byte
Scroll_flags:			equ	$FFFFEE50		; 2 bytes
Scroll_flags_BG:		equ	$FFFFEE52		; 2 bytes
Scroll_flags_BG2:		equ	$FFFFEE54		; 2 bytes
Scroll_flags_BG3:		equ	$FFFFEE56		; 2 bytes
Scroll_flags_P2:		equ	$FFFFEE58		; 2 bytes
Scroll_flags_BG_P2:		equ	$FFFFEE5A		; 2 bytes
Scroll_flags_BG2_P2:		equ	$FFFFEE5C		; 2 bytes
Scroll_flags_BG3_P2:		equ	$FFFFEE5E		; 2 bytes
Camera_RAM_copy:		equ	$FFFFEE60		; 8 bytes
Camera_BG_copy:			equ	$FFFFEE68		; 8 bytes
Camera_BG2_copy:		equ	$FFFFEE70		; 8 bytes
Camera_BG3_copy:		equ	$FFFFEE78		; 8 bytes
Camera_P2_copy:			equ	$FFFFEE80		; 8 bytes
Scroll_flags_copy:		equ	$FFFFEEA0		; 2 bytes
Scroll_flags_BG_copy:		equ	$FFFFEEA2		; 2 bytes
Scroll_flags_BG2_copy:		equ	$FFFFEEA4		; 2 bytes
Scroll_flags_BG3_copy:		equ	$FFFFEEA6		; 2 bytes
Scroll_flags_copy_P2:		equ	$FFFFEEA8		; 2 bytes
Scroll_flags_BG_copy_P2:	equ	$FFFFEEAA		; 2 bytes
Scroll_flags_BG2_copy_P2:	equ	$FFFFEEAC		; 2 bytes
Scroll_flags_BG3_copy_P2:	equ	$FFFFEEAE		; 2 bytes
Camera_X_pos_diff:		equ	$FFFFEEB0		; 2 bytes
Camera_Y_pos_diff:		equ	$FFFFEEB2		; 2 bytes
Camera_X_pos_diff_P2:		equ	$FFFFEEB6		; 2 bytes
Camera_Y_pos_diff_P2:		equ	$FFFFEEB8		; 2 bytes
unk_EEC0:			equ	$FFFFEEC0		; 4 bytes ; only written to once
unk_EEC4:			equ	$FFFFEEC4		; 2 bytes ; only written to once, but actually as a long-word (4 bytes) which also prevents the screen from scrolling up and killing Sonic
Camera_Max_Y_pos:		equ	$FFFFEEC6		; 2 bytes
Camera_Min_X_pos:		equ	$FFFFEEC8		; 2 bytes
Camera_Max_X_pos:		equ	$FFFFEECA		; 2 bytes
Camera_Min_Y_pos:		equ	$FFFFEECC		; 2 bytes
Camera_Max_Y_pos_now:		equ	$FFFFEECE		; 2 bytes
Horiz_scroll_delay_val:		equ	$FFFFEED0		; 2 bytes
Sonic_Pos_Record_Index:		equ	$FFFFEED2		; 2 bytes
Horiz_scroll_delay_val_P2:	equ	$FFFFEED4		; 2 bytes
Tails_Pos_Record_Index:		equ	$FFFFEED6		; 2 bytes
Camera_Y_pos_bias:		equ	$FFFFEED8		; 2 bytes
Deform_lock:			equ	$FFFFEEDC		; 1 byte
Camera_Max_Y_Pos_Changing:	equ	$FFFFEEDE		; 1 byte
Dynamic_Resize_Routine:		equ	$FFFFEEDF		; 1 byte
unk_EEE0:			equ	$FFFFEEE0		; 2 bytes ; referenced by an unused position recording routine...
Camera_X_pos_copy:		equ	$FFFFEEF0		; 4 bytes

; Misc variables
Block_cache:			equ	$FFFFEF00		; $80 bytes
SoundDriver_RAM:		equ	$FFFFF000		; $5C0 bytes
Game_Mode:			equ	$FFFFF600		; 1 byte
Vint_routine:			equ	$FFFFF62A		; 1 byte
RNG_seed:			equ	$FFFFF636		; 4 bytes
Game_paused:			equ	$FFFFF63A		; 2 bytes
DMA_data_thunk:			equ	$FFFFF640		; 2 bytes
Hint_flag:			equ	$FFFFF644		; 2 bytes
Do_Updates_in_H_int:		equ	$FFFFF64F		; 1 byte
Screen_redraw_flag:		equ	$FFFFF720		; 1 byte
Water_flag:			equ	$FFFFF730		; 1 byte

; Some of Sonic's variables
Sonic_top_speed:		equ	$FFFFF760		; 2 bytes
Sonic_acceleration:		equ	$FFFFF762		; 2 bytes
Sonic_deceleration:		equ	$FFFFF764		; 2 bytes
Sonic_LastLoadedDPLC:		equ	$FFFFF766		; 2 bytes

; Object placement variables
Obj_placement_routine:		equ	$FFFFF76C		; 2 bytes
Camera_X_pos_last:		equ	$FFFFF76E		; 2 bytes
Obj_load_addr_right:		equ	$FFFFF770		; 4 bytes
Obj_load_addr_left:		equ	$FFFFF774		; 4 bytes
Obj_load_addr_right_P2:		equ	$FFFFF778		; 4 bytes
Obj_load_addr_left_P2:		equ	$FFFFF77C		; 4 bytes

; Demo variables
Demo_button_index:		equ	$FFFFF790		; 2 bytes
Demo_press_counter:		equ	$FFFFF792		; 1 byte

; Misc variables
PalChangeSpeed:			equ	$FFFFF794		; 2 bytes
Collision_addr:			equ	$FFFFF796		; 4 bytes

; Has something to do with the Special Stages...
unk_F79A:			equ	$FFFFF79A		; 2 bytes
unk_F79C:			equ	$FFFFF79C		; 2 bytes
unk_F79E:			equ	$FFFFF79E		; 2 bytes
unk_F7A0:			equ	$FFFFF7A0		; 2 bytes

; Misc variables
Boss_defeated_flag:		equ	$FFFFF7A7		; 1 byte
Current_Boss_ID:		equ	$FFFFF7AA		; 1 byte
BigRingGraphics:		equ	$FFFFF7BE		; 2 bytes
WindTunnel_flag:		equ	$FFFFF7C7		; 1 byte
Object_control:			equ	$FFFFF7C8		; 1 byte
WindTunnel_holding_flag:	equ	$FFFFF7C9		; 1 byte
Sonic_sliding:			equ	$FFFFF7CA		; 1 byte
Control_locked:			equ	$FFFFF7CC		; 1 byte
Sonic_EnteredBigRing:		equ	$FFFFF7CD		; 1 byte
Chain_Bonus_counter:		equ	$FFFFF7D0		; 2 bytes

; Misc variables
Sprite_Table:			equ	$FFFFF800		; $200 bytes
System_Stack:			equ	$FFFFFE00
Current_ZoneAndAct:		equ	$FFFFFE10		; covers Current_Zone and Current_Act, two bytes
Current_Zone:			equ	Current_ZoneAndAct	; $FFFFFE10, listed like this in case of RAM shifting
Current_Act:			equ	Current_ZoneAndAct+1	; $FFFFFE11, listed like this in case of RAM shifting
Two_player_mode:		equ	$FFFFFFE8
Demo_mode_flag:			equ	$FFFFFFF0
Graphics_Flags:			equ	$FFFFFFF8
Debug_mode_flag:		equ	$FFFFFFFA
Checksum_fourcc:		equ	$FFFFFFFC		; writes "init" at this piece of RAM

; ---------------------------------------------------------------------------
; Sound Driver RAM variables; starts at $FFFFF000 and ends at $FFFFF5BF.
QueueToPlay:			equ	9	; if NOT set to $80, means new index was requested by 68K
SFXToPlay:			equ	$A	; when Genesis wants to play "normal" sound, it writes it here
SFXSpecialToPlay:		equ	$B	; when Genesis wants to play "special" sound, it writes it here
SFXUnknownToPlay:		equ	$C	; when Genesis wants to play "unused" sound, it writes it here (unused and broken in normal gameplay)

; ---------------------------------------------------------------------------
; VDP addressses
VDP_data_port:			equ	$C00000 ; (8=r/w, 16=r/w)
VDP_control_port:		equ	$C00004 ; (8=r/w, 16=r/w)
PSG_input:			equ	$C00011