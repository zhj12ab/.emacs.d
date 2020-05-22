@echo off&setlocal enabledelayedexpansion
for /r %%a in (*.*) do (
set fn=%%~nxa
set fn1=%%~nxa
set loc=%%~dpa
if "!fn!"=="decrypt.bat" (
@echo show name "!fn!"
) else (
set fn=!fn:.=_!
if "!fn!"=="!fn1!" (
copy "%%a" "!loc!!fn!.tmp"
del "%%a"
cd "!loc!"
ren "!fn!.tmp" "!fn1!"
) else (
copy "%%a" "!loc!!fn!"
del "%%a"
cd "!loc!"
ren "!fn!" "!fn1!"
)
)
)

