@echo off
setlocal enabledelayedexpansion

REM Create the "dist" directory if it doesn't exist
if not exist "dist" mkdir "dist"

REM Traverse all directories and rename/move files
for /R %%F in (*.jpg *.jpeg *.png *.gif *.bmp *.mp4) do (
    set "oldName=%%~nxF"
    set "extension=%%~xF"
    set "digits=8"

    set "isNumeric=true"
    for /F "delims=0123456789" %%A in ("!digits!") do set "isNumeric=false"

    if "!isNumeric!"=="true" (
        set "randomWord="
        set "symbols=0123456789"
        for /L %%C in (1,1,8) do (
            set /a "index=!random! %% 9"
            for /F %%S in ("!index!") do set "randomChar=!symbols:~%%S,1!"
            set "randomWord=!randomWord!!randomChar!"
        )
        set "newName=!randomWord!!extension!"

        echo Renaming and moving file: !oldName! to !newName!
        move "%%F" "dist\!newName!"
    ) else (
        set "randomWord="
        set "symbols=0123456789"
        for /L %%C in (1,1,8) do (
            set /a "index=!random! %% 62"
            for /F %%S in ("!index!") do set "randomChar=!symbols:~%%S,1!"
            set "randomWord=!randomWord!!randomChar!"
        )
        set "newName=!randomWord!!extension!"

        echo Renaming and moving file: !oldName! to !newName!
        move "%%F" "dist\!newName!"
    )
)

REM Delete empty subdirectories
for /d %%D in (*) do (
    rd "%%D" 2>nul
)

exit /b
