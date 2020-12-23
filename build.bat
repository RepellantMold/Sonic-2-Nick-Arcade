@echo off
echo Making s2built.prev.bin...
IF EXIST s2built.bin move /Y s2built.bin s2built.prev.bin >NUL
echo Done.
cls
cd mappings/128x128
kc-compress.exe "GHZ (Uncompressed).bin" GHZ.bin
cd..
cd..
echo Building the ROM...
asm68k /c /q /p /o l+ /o ae- s2.asm, s2built.bin , , s2.lst >error.log
cls
IF NOT EXIST s2built.bin goto LABLERR
echo Build successful!
goto LABLDONE
:LABLERR
echo Build failed, look below for why.
type error.log
:LABLDONE
pause