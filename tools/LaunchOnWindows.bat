:: TODO Check PROCESSOR_ARCHITEW6432.
@if %PROCESSOR_ARCHITECTURE% == x86 start lib\Windows_x86\game.exe exit
@if %PROCESSOR_ARCHITECTURE% == AMD64 start lib\Windows_x86_64\game.exe exit
@if %PROCESSOR_ARCHITECTURE% == IA64 start lib\Windows_x86_64\game.exe exit

