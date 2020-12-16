@echo off
IF EXIST s2built.bin move /Y s2built.bin s2built.prev.bin >NUL
asm68k /k /m /c /p /o ae- s2.asm, s2built.bin , , s2.lst >s2.log