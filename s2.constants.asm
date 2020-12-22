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
; Game modes
GMid_SegaScrn:		equ ptr_SegaScrn-GameModeArray	; $00
GMid_TS:		equ ptr_TS-GameModeArray	; $04
GMid_Demo:		equ ptr_Demo-GameModeArray	; $08
GMid_Level:		equ ptr_Level-GameModeArray	; $0C
GMid_S1SpecStg:		equ ptr_S1SpecStg-GameModeArray	; $10
; Palette id's
palid_SegaBG:		equ (ptr_Pal_SegaBG-PalPointers)/8	; 0
palid_Title:		equ (ptr_Pal_Title-PalPointers)/8	; 1
palid_LevelSel:		equ (ptr_Pal_LevelSel-PalPointers)/8	; 2
palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8	; 3
palid_GHZ:		equ (ptr_Pal_GHZ-PalPointers)/8		; 4
palid_CPZ:		equ (ptr_Pal_CPZ-PalPointers)/8		; 5
palid_CPZ2:		equ (ptr_Pal_CPZ2-PalPointers)/8	; 6
palid_EHZ:		equ (ptr_Pal_EHZ-PalPointers)/8		; 7
palid_HPZ:		equ (ptr_Pal_HPZ-PalPointers)/8		; 8
palid_HTZ:		equ (ptr_Pal_HTZ-PalPointers)/8		; 9
palid_Special:		equ (ptr_Pal_Special-PalPointers)/8	; $A
palid_HPZWater:		equ (ptr_Pal_HPZWater-PalPointers)/8	; $B
palid_LZ:		equ (ptr_Pal_LZ-PalPointers)/8		; $C
palid_LZ4:		equ (ptr_Pal_LZ4-PalPointers)/8		; $D
palid_HTZ2:		equ (ptr_Pal_HTZ2-PalPointers)/8	; $E
palid_LZSonWater:	equ (ptr_Pal_LZSonWater-PalPointers)/8	; $F
palid_LZ4SonWat:	equ (ptr_Pal_LZ4SonWat-PalPointers)/8	; $10
palid_SSResult:		equ (ptr_Pal_SSResult-PalPointers)/8	; $11
palid_Continue:		equ (ptr_Pal_Continue-PalPointers)/8	; $12
palid_Ending:		equ (ptr_Pal_Ending-PalPointers)/8	; $13

; ---------------------------------------------------------------------------
; Object Status Table offsets (for everything between Object_RAM and Primary_Collision)
; ---------------------------------------------------------------------------
id =			  0
render_flags =		  1 ; bitfield ; bit 7 = onscreen flag, bit 0 = x mirror, bit 1 = y mirror, bit 2 = coordinate system
art_tile =		  2 ; and 3 ; start of sprite's art
mappings =		  4 ; and 5 and 6 and 7
x_pos =			  8 ; and 9 ... some objects use $A and $B as well when extra precision is r=ired (see ObjectMove) ... for screen-space objects this is called x_pixel instead
y_pos =			 $C ; and $D ... some objects use $E and $F as well when extra precision is r=ired ... screen-space objects use y_pixel instead
priority =		$18 ; 0 - 7, then converted to a word by DisplaySprite/DisplayA1Sprite/DisplaySprite_Param
width_pixels =		$19
mapping_frame =		$1A
; ---------------------------------------------------------------------------
; conventions followed by most objects:
x_vel  = 			$10 ; and $11 ; horizontal velocity
y_vel  = 			$12 ; and $13 ; vertical velocity
y_radius  = 		$16 ; collision width / 2
x_radius  = 		$17 ; collision height / 2
anim_frame  = 		$1B
anim  = 			$1C
next_anim  = 		$1D
anim_frame_duration  = 	$1E
status  = 		$22 ; note: exact meaning depends on the object... for sonic/tails: bit 0: leftfacing. bit 1: inair. bit 2: spinning. bit 3: onobject. bit 4: rolljumping. bit 5: pushing. bit 6: underwater.
routine  = 		$24
routine_secondary  = 	$25
angle  = 			$26 ; angle about the z = 0 axis (360 degrees  =  256)
; ---------------------------------------------------------------------------
; conventions followed by many objects but NOT sonic/tails:
collision_flags  = 	$20
collision_property  = 	$21
respawn_index  = 	$23
subtype  = 		$28
; ---------------------------------------------------------------------------
; conventions specific to sonic/tails (Obj01, Obj02, and ObjDB):
; note: $1F, $20, and $21 are unused and available
inertia  = 		$14 ; and $15 ; directionless representation of speed... not updated in the air
flip_angle  = 		$27 ; angle about the x = 0 axis (360 degrees  =  256) (twist/tumble)
air_left  = 		$28
flip_turned  = 		$29 ; 0 for normal, 1 to invert flipping (it's a 180 degree rotation about the axis of Sonic's spine, so he stays in the same position but looks turned around)
obj_control  = 		$2A ; 0 for normal, 1 for hanging or for resting on a flipper, $81 for going through CNZ/OOZ/MTZ tubes or stopped in CNZ cages or stoppers or flying if Tails
status_secondary  = 	$2B
flips_remaining  = 	$2C ; number of flip revolutions remaining
flip_speed  = 		$2D ; number of flip revolutions per frame / 256
move_lock  = 		$2E ; and $2F ; horizontal control lock, counts down to 0
invulnerable_time  = 	$30 ; and $31 ; time remaining until you stop blinking
invincibility_time  = 	$32 ; and $33 ; remaining
speedshoes_time  = 	$34 ; and $35 ; remaining
next_tilt  = 		$36 ; angle on ground in front of sprite
tilt  = 		$37 ; angle on ground
stick_to_convex  = 	$38 ; 0 for normal, 1 to make Sonic stick to convex surfaces like the rotating discs in Sonic 1 and 3 (unused in Sonic 2 but fully functional)
spindash_flag  = 	$39 ; 0 for normal, 1 for charging a spindash or forced rolling
spindash_counter  = 	$3A ; and $3B
jumping  = 		$3C
interact  = 		$3D ; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
layer  = 			$3E ; collision plane, track switching...
layer_plus  = 		$3F ; always same as layer+1 ?? used for collision somehow

; ---------------------------------------------------------------------------
; conventions followed by several objects but NOT sonic/tails:
y_pixel  = 		2+x_pos ; and 3+x_pos ; y coordinate for objects using screen-space coordinate system
x_pixel  = 		x_pos ; and 1+x_pos ; x coordinate for objects using screen-space coordinate system
parent  = 		$3E ; and $3F ; address of object that owns or spawned this one, if applicable
; ---------------------------------------------------------------------------
; unknown or inconsistently used offsets that are not applicable to sonic/tails:
; (provided because rearrangement of the above values sometimes r = ires making space in here too)
objoff_A = 2+x_pos ; note: x_pos can be 4 bytes, but sometimes the last 2 bytes of x_pos are used for other unrelated things
objoff_B = 3+x_pos
objoff_E = 2+y_pos
objoff_F = 3+y_pos
objoff_14 = $14
objoff_15 = $15
objoff_1F = $1F
objoff_27 = $27
objoff_28 = $28 ; overlaps subtype, but a few objects use it for other things anyway
objoff_29 = $29
objoff_2A = $2A
objoff_2B = $2B
objoff_2C = $2C
objoff_2D = $2D
objoff_2E = $2E
objoff_2F = $2F
objoff_30 = $30
objoff_31 = $31
objoff_32 = $32
objoff_33 = $33
objoff_34 = $34
objoff_35 = $35
objoff_36 = $36
objoff_37 = $37
objoff_38 = $38
objoff_39 = $39
objoff_3A = $3A
objoff_3B = $3B
objoff_3C = $3C
objoff_3D = $3D
objoff_3E = $3E
objoff_3F = $3F

; ---------------------------------------------------------------------------
; property of all objects:
next_object  = 		$40 ; the size of an object

; ---------------------------------------------------------------------------
; RAM Variables
RAM_Start:			equ	$FFFF0000		; 4 bytes

; ---------------------------------------------------------------------------
; Level variables
Chunk_Table:			equ	RAM_Start		; $8000 bytes
Level_Layout:			equ	$FFFF8000		; $1000 bytes
Block_Table:			equ	$FFFF9000		; $C00 bytes
TempArray_LayerDef:		equ	$FFFFA800		; $200 bytes
Decomp_Buffer:			equ	$FFFFAA00		; $200 bytes
Primary_Collision:		equ	$FFFFD000
Secondary_Collision:		equ	$FFFFD600
Collision_addr:			equ	$FFFFF796		; 4 bytes
Ring_amount:			equ 	$FFFFFE20		; 2 bytes - rings
Ring_byte:			equ 	v_rings+1		; low byte for rings
Time:				equ 	$FFFFFE22		; 4 bytes - time
Time_minute:			equ 	Time+1			; time - minutes ($FFFFFE23, listed like this in case of RAM shifting)
Time_seconds:			equ 	Time_minute+1		; time - seconds ($FFFFFE24, listed like this in case of RAM shifting)
Time_centisecond:		equ 	Time_seconds+1		; time - centiseconds ($FFFFFE25, listed like this in case of RAM shifting)
Score:				equ 	Time_centisecond+1	; 4 bytes - score ($FFFFFE26, listed like this in case of RAM shifting)

; ---------------------------------------------------------------------------
; Object variables
Sprite_Table_Input:		equ	$FFFFAC00		; $400 bytes
Ring_Positions:			equ	$FFFFE800		; $600 bytes
Object_RAM:			equ	$FFFFB000 		; through $FFFFD5FF, each object takes up $40 bytes of this RAM
MainCharacter:			equ	Object_RAM 		; Usually where the Sonic object is located - $FFFFB000, listed like this in case of RAM shifting
Sidekick:			equ	Object_RAM+$40 		; Usually where the Tails object is located - $FFFFB040, listed like this in case of RAM shifting
Tails_Tails:			equ	Sidekick+$40		; Usually where Tails' tail object is located - $FFFFB080, listed like this in case of RAM shifting

; ---------------------------------------------------------------------------
; Camera variables
Camera_RAM:			equ	$FFFFEE00		; 4 bytes
Camera_X_pos:			equ	$FFFFEE00		; 4 bytes - same as Camera_RAM but with different meaning
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
unk_EEC0:			equ	$FFFFEEC0		; 4 bytes - only written to once
unk_EEC4:			equ	$FFFFEEC4		; 2 bytes - written to once as a long-word (4 bytes) so it controls Camera_Max_Y_pos
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
unk_EEE0:			equ	$FFFFEEE0		; 2 bytes - referenced by an unused position recording routine...
Camera_X_pos_copy:		equ	$FFFFEEF0		; 4 bytes
Camera_X_pos_coarse:		equ 	$FFFFF7DA               ; 2 bytes - (Camera_X_pos - 128) / 256

; ---------------------------------------------------------------------------
; Misc variables
Block_cache:			equ	$FFFFEF00		; $80 bytes
SoundDriver_RAM:		equ	$FFFFF000		; $5C0 bytes
Game_Mode:			equ	$FFFFF600		; 1 byte
RNG_seed:			equ	$FFFFF636		; 4 bytes
Game_paused:			equ	$FFFFF63A		; 2 bytes
DMA_data_thunk:			equ	$FFFFF640		; 2 bytes
Hint_flag:			equ	$FFFFF644		; 2 bytes
Do_Updates_in_H_int:		equ	$FFFFF64F		; 1 byte
unk_F662:			equ	$FFFFF662		; 2 bytes - unused but cleared on the SEGA screen
Level_started_flag:		equ	$FFFFF711		; 1 byte - used to determine if the HUD should display or not
Screen_redraw_flag:		equ	$FFFFF720		; 1 byte
Shield_flag:			equ 	$FFFFFE2C		; 1 byte - shield status (00 = no; 01 = yes)
Invinc_flag:			equ 	$FFFFFE2D		; 1 byte - invinciblity status (00 = no; 01 = yes)
Shoes_flag:			equ 	$FFFFFE2E		; 1 byte - speed shoes status (00 = no; 01 = yes)

; ---------------------------------------------------------------------------
; Water variables
AmountOfAir:			equ 	$FFFFFE14		; 2 bytes - air remaining while underwater
WaterHeight:			equ	$FFFFF646		; 2 bytes
AverageWtrHeight:		equ	WaterHeight+2           ; 2 bytes - $FFFFF648, listed like this in case of RAM shifting
TargetWaterHeight:		equ	AverageWtrHeight+2	; 2 bytes - $FFFFF64A, listed like this in case of RAM shifting
Water_on:			equ	TargetWaterHeight+2	; 1 byte - $FFFFF64C, listed like this in case of RAM shifting
Water_routine:			equ	Water_on+1		; 1 byte - $FFFFF64D, listed like this in case of RAM shifting
Water_move:			equ 	Water_routine+1         ; 1 byte - $FFFFF64E, listed like this in case of RAM shifting
Water_flag:			equ	$FFFFF730		; 1 byte

; ---------------------------------------------------------------------------
; Some of Sonic's variables
Sonic_top_speed:		equ	$FFFFF760		; 2 bytes
Sonic_acceleration:		equ	Sonic_top_speed+2	; 2 bytes - $FFFFF762, listed like this in case of RAM shifting
Sonic_deceleration:		equ	Sonic_acceleration+2	; 2 bytes - $FFFFF764, listed like this in case of RAM shifting
Sonic_LastLoadedDPLC:		equ	Sonic_deceleration+2	; 2 bytes - $FFFFF766, listed like this in case of RAM shifting

; ---------------------------------------------------------------------------
; Tails' CPU variables
Tails_control_counter:		equ	$FFFFF702 ; 2 bytes - counter for how long until the CPU takes control
unk_F706:			equ	$FFFFF706 ; 2 bytes - only referenced in unused lines
Tails_CPU_routine:		equ	$FFFFF708 ; 2 bytes - used to determine what routine the CPU goes to

; ---------------------------------------------------------------------------
; Object placement variables
Sprite_Table:			equ	$FFFFF800		; $200 bytes
Sprite_Table_End:               equ	Sprite_Table+$200
Sprite_Table_2:			equ	$FFFFDD00 		; Sprite attribute table buffer for the bottom split screen in 2-player mode
Obj_placement_routine:		equ	$FFFFF76C		; 2 bytes
Camera_X_pos_last:		equ	$FFFFF76E		; 2 bytes
Obj_load_addr_right:		equ	$FFFFF770		; 4 bytes
Obj_load_addr_left:		equ	Obj_load_addr_right+4	; 4 bytes
Obj_load_addr_right_P2:		equ	Obj_load_addr_left+4	; 4 bytes
Obj_load_addr_left_P2:		equ	Obj_load_addr_right_P2+4; 4 bytes
Object_State:			equ 	$FFFFFC00		; $200 bytes - object state list

; ---------------------------------------------------------------------------
; Demo variables
Demo_button_index:		equ	$FFFFF790		; 2 bytes
Demo_press_counter:		equ	$FFFFF792		; 1 byte

; ---------------------------------------------------------------------------
; Misc variables
Boss_defeated_flag:		equ	$FFFFF7A7		; 1 byte
Current_Boss_ID:		equ	$FFFFF7AA		; 1 byte
BigRingGraphics:		equ	$FFFFF7BE		; 2 bytes
WindTunnel_flag:		equ	$FFFFF7C7		; 1 byte
WindTunnel_holding_flag:	equ	$FFFFF7C9		; 1 byte
Sonic_sliding:			equ	$FFFFF7CA		; 1 byte
Sonic_EnteredBigRing:		equ	$FFFFF7CD		; 1 byte
Chain_Bonus_counter:		equ	$FFFFF7D0		; 2 bytes

; ---------------------------------------------------------------------------
; Debug variables
LevelSelCheat_Flag:		equ	$FFFFFFE0		; 1 byte
SlowMoCheat_Flag:		equ	LevelSelCheat_Flag+1	; 1 byte - $FFFFFFE1, listed like this in case of RAM shifting
DebugCheat_Flag:		equ	SlowMoCheat_Flag+1	; 1 byte - $FFFFFFE2, listed like this in case of RAM shifting
S1JapaneseCredits_Flag:		equ	DebugCheat_Flag+1	; 1 byte - somewhat unused ($FFFFFFE3, listed like this in case of RAM shifting)
CorrectBtnPresses:		equ	S1JapaneseCredits_Flag+1; 2 bytes - used to detect correct button presses ($FFFFFFE4, listed like this in case of RAM shifting)
TitleScreenCpresses:		equ	CorrectBtnPresses+2	; 2 bytes - used to detect the C button on the title screen ($FFFFFFE6, listed like this in case of RAM shifting)
Debug_mode_flag:		equ	$FFFFFFFA		; 2 bytes
Debug_object:			equ	$FFFFFE06               ; 2 bytes - $FFFFFE06, listed like this in case of RAM shifting
Debug_placement_mode:		equ	Debug_object+2          ; 2 bytes - $FFFFFE08, listed like this in case of RAM shifting
Register_Buffer:		equ 	$FFFFFC00		; $40 bytes - stores registers d0-a7 during an error event
SP_Buffer:			equ 	Register_Buffer+$40	; 4 bytes - stores most recent sp address ($FFFFFC40, listed like this in case of RAM shifting)
Error_Type:			equ 	SP_Buffer+4		; 1 byte - error type - $FFFFFC44, listed like this in case of RAM shifting

; ---------------------------------------------------------------------------
; Joypad variables
Ctrl_1_Logical: 		equ 	$FFFFF602 		; 2 bytes
Ctrl_1_Held_Logical: 		equ 	Ctrl_1_Logical 		; 1 byte - $FFFFF602, listed like this in case of RAM shifting
Ctrl_1_Press_Logical: 		equ 	Ctrl_1_Logical+1 	; 1 byte - $FFFFF603, listed like this in case of RAM shifting
Ctrl_1: 			equ 	Ctrl_1_Press_Logical+1 	; 2 bytes - FFFFF604, listed like this in case of RAM shifting
Ctrl_1_Held: 			equ 	Ctrl_1 			; 1 byte - $FFFFF604, listed like this in case of RAM shifting
Ctrl_1_Press: 			equ 	Ctrl_1+1 		; 1 byte - $FFFFF605, listed like this in case of RAM shifting
Ctrl_2: 			equ 	Ctrl_1_Press+1 		; 2 bytes - $FFFFF606, listed like this in case of RAM shifting
Ctrl_2_Held: 			equ 	Ctrl_2 			; 1 byte - $FFFFF606, listed like this in case of RAM shifting
Ctrl_2_Press: 			equ 	Ctrl_2+1 		; 1 byte - $FFFFF607, listed like this in case of RAM shifting
Control_locked:			equ	$FFFFF7CC		; 1 byte
Object_control:			equ	$FFFFF7C8		; 1 byte

; ---------------------------------------------------------------------------
; Vertical/horizontal blanking variables
VDP_Command_Buffer:		equ	$FFFFDC00 		; 2 bytes - stores VDP commands to issue the next time ProcessDMAQueue is called
VDP_Reg0_Val:			equ	$FFFFF60C 		; 2 bytes
VDP_Command_Buffer_Slot:	equ	$FFFFDCFC 		; 4 bytes - stores the address of the next open slot for a queued VDP command
Horiz_Scroll_Buf:		equ	$FFFFE000               ; 2 bytes

Vscroll_Factor:			equ	$FFFFF616               ; 4 bytes
Hint_counter_reserve:		equ	$FFFFF624 		; 2 bytes - Must contain a VDP command word, preferably a write to register $0A. Executed every vertical blank.
Vint_routine:			equ	$FFFFF62A		; 1 byte

; ---------------------------------------------------------------------------
; Palette variables
Water_palette_dup:		equ 	$FFFFFA00 		; $80 bytes - duplicate underwater palette, used for transitions
Water_palette:			equ 	Water_palette_dup+$80	; $80 bytes - main underwater palette ($FFFFFA80, listed like this in case of RAM shifting)
Normal_palette:			equ	$FFFFFB00               ; 32 bytes
Normal_palette_line2:		equ	Normal_palette+$20	; 32 bytes - $FFFFFB20, listed like this in case of RAM shifting
Normal_palette_line3:		equ	Normal_palette_line2+$20; 32 bytes - $FFFFFB40, listed like this in case of RAM shifting
Normal_palette_line4:		equ	Normal_palette_line3+$20; 32 bytes - $FFFFFB60, listed like this in case of RAM shifting
Second_palette:			equ	Normal_palette_line4+$20; 32 bytes - $FFFFFB80, listed like this in case of RAM shifting
Second_palette_line2:		equ	Second_palette+$20	; 32 bytes - $FFFFFBA0, listed like this in case of RAM shifting
Second_palette_line3:		equ	Second_palette_line2+$20; 32 bytes - $FFFFFBC0, listed like this in case of RAM shifting
Second_palette_line4:		equ	Second_palette_line3+$20; 32 bytes - $FFFFFBE0, listed like this in case of RAM shifting
Palette_Offset_Counter:		equ	$FFFFF632		; 2 bytes
Palette_Wait_Counter:		equ	$FFFFF634		; 2 bytes
PalChangeSpeed:			equ	$FFFFF794		; 2 bytes
Palette_fadestart:		equ 	$FFFFF626		; 1 byte - used for palette fading, with the start position in bytes
Palette_fadesize:		equ 	Palette_fadestart+1	; 1 byte - the number of colors to fade in ($FFFFF627, listed like this in case of RAM shifting)
; Used in the palette cycles for the special stages
unk_F79A:			equ	$FFFFF79A		; 2 bytes
unk_F79C:			equ	unk_F79A+2		; 2 bytes - $FFFFF79C, listed like this in case of RAM shifting
unk_F79E:			equ	unk_F79C+2		; 2 bytes - $FFFFF79E, listed like this in case of RAM shifting
SpecialStage_BGMode:		equ	unk_F79E+2		; 2 bytes - $FFFFF7A0, listed like this in case of RAM shifting

; ---------------------------------------------------------------------------
; Misc variables
System_Stack:			equ	$FFFFFE00
Current_ZoneAndAct:		equ	$FFFFFE10		; covers Current_Zone and Current_Act, two bytes
Current_Zone:			equ	Current_ZoneAndAct	; $FFFFFE10, listed like this in case of RAM shifting
Current_Act:			equ	Current_ZoneAndAct+1	; $FFFFFE11, listed like this in case of RAM shifting
Two_player_mode:		equ	$FFFFFFE8
Demo_mode_flag:			equ	$FFFFFFF0
Graphics_Flags:			equ	$FFFFFFF8
Checksum_fourcc:		equ	$FFFFFFFC		; writes "init" here

; ---------------------------------------------------------------------------
; Sound Driver RAM variables; starts at $FFFFF000 and ends at $FFFFF5BF.
Size_of_SegaPCM:		equ 	$6978   		; Change this if you change the SEGA PCM sample.
PauseSound:			equ	3
QueueToPlay:			equ	9			; if NOT set to $80, means new index was requested by 68K
SFXToPlay:			equ	$A			; when Genesis wants to play "normal" sound, it writes it here
SFXSpecialToPlay:		equ	$B			; when Genesis wants to play "special" sound, it writes it here
SFXUnknownToPlay:		equ	$C			; when Genesis wants to play "unused" sound, it writes it here (unused and broken in normal gameplay)

; ---------------------------------------------------------------------------
; VDP addressses
VDP_data_port:			equ	$C00000 		; (8=r/w, 16=r/w)
VDP_control_port:		equ	$C00004 		; (8=r/w, 16=r/w)
PSG_input:			equ	$C00011

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses.
; VRAM Reserved regions.
VRAM_Plane_A_Name_Table = 		$C000			; Extends until $CFFF
VRAM_Plane_B_Name_Table = 		$E000			; Extends until $EFFF
VRAM_Plane_A_Name_Table_2P = 		$A000			; Extends until $AFFF
VRAM_Plane_B_Name_Table_2P = 		$8000			; Extends until $8FFF
VRAM_Plane_Table_Size = 		$1000			; 64 cells x 32 cells x 2 bytes per cell
VRAM_Sprite_Attribute_Table = 		$F800			; Extends until $FA7F
VRAM_Sprite_Attribute_Table_Size = 	$0280			; 640 bytes
VRAM_Horiz_Scroll_Table = 		$FC00			; Extends until $FF7F
VRAM_Horiz_Scroll_Table_Size = 		$0380			; 224 lines * 2 bytes per entry * 2 PNTs

; ---------------------------------------------------------------------------
; Art tile stuff
flip_x =      				(1<<11)
flip_y =      				(1<<12)
palette_bit_0 =      			5
palette_bit_1 =      			6
palette_line_0 =      			(0<<13)
palette_line_1 =      			(1<<13)
palette_line_2  =      			(2<<13)
palette_line_3 =      			(3<<13)
high_priority_bit =      		7
high_priority  =      			(1<<15)
palette_mask =      			$6000
tile_maskn=      			$07FF
nontile_mask =      			$F800
drawing_mask =      			$7FFF

; Joypad input
btnStart: 			equ 	%10000000 ; Start button ($80)
btnA: 				equ 	%01000000 ; A ($40)
btnC:				equ 	%00100000 ; C ($20)
btnB:				equ 	%00010000 ; B		($10)
btnR:				equ 	%00001000 ; Right		($08)
btnL:				equ 	%00000100 ; Left		($04)
btnDn:				equ 	%00000010 ; Down		($02)
btnUp:				equ 	%00000001 ; Up		($01)
btnDir:				equ 	%00001111 ; Any direction	($0F)
btnABC:				equ 	%01110000 ; A, B or C	($70)
bitStart:			equ 	7
bitA:				equ 	6
bitC:				equ 	5
bitB:				equ 	4
bitR:				equ 	3
bitL:				equ 	2
bitDn:				equ 	1
bitUp:				equ 	0

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM:			equ 	$A00000			; start of Z80 RAM
Z80_DAC3_Pitch:			equ 	$A000EA			; !! change this if you modify the Z80 driver
Z80_DAC_Status:			equ	$A01FFD
Z80_DAC_Sample:			equ 	$A01FFF
Z80_RAM_end:			equ 	$A02000			; end of non-reserved Z80 RAM
Z80_Version:			equ 	$A10001
Z80_Port_1_Data:		equ 	$A10002
Z80_Port_1_Control:		equ 	$A10008
Z80_Port_2_Control:		equ 	$A1000A
Z80_Expansion_Control:		equ 	$A1000C
Z80_Bus_Request:		equ 	$A11100
Z80_Reset:			equ 	$A11200
YM2612_a0:			equ 	$A04000
YM2612_d0:			equ 	$A04001
YM2612_a1:			equ 	$A04002
MY2612_d1:			equ 	$A04003