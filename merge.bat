@echo off
setlocal enabledelayedexpansion

echo Creating the "dist" directory if it doesn't exist
if not exist "%%~dpI\dist" mkdir "%%~dpI\dist"

REM Loop through every folder starting with "images."
for /D %%I in ("images.*") do (
    echo Processing files in directory: %%I
    echo.
    echo Traverse all directories and rename/move files
    pushd "%%I"
    for /R %%F in (*.jpg *.jpeg *.png *.gif *.bmp *.mp4) do (
        echo Processing file: %%F
        set "oldName=%%~nxF"
        set "extension=%%~xF"
        set "digits=0123456789"

        set "randomWord="
        set "symbols=0123456789"
        for /L %%C in (1,1,8) do (
            set /a "index=!random! %% 62"
            for /F %%S in ("!index!") do set "randomChar=!symbols:~%%S,1!"
            set "randomWord=!randomWord!!randomChar!"
        )
        set "newName=!randomWord!!extension!"

        echo Renaming and moving file: !oldName! to !newName!
        move "%%F" "..\dist\!newName!"
    )
    popd

    echo.
    echo Checking directory contents...

    REM Check if the directory only contains .tmp and .html files
    set "fileCount=0"
    for %%A in ("%%I\*.*") do (
        set /a "fileCount+=1"
        if "%%A" neq "*.tmp" if "%%A" neq "*.html" (
            set "notEmpty=true"
        )
    )

    REM Delete the directory if it only contains .tmp and .html files
    if not defined notEmpty (
        if !fileCount! equ 0 (
            echo Deleting empty directory: %%I
            rd "%%I"
        ) else (
            echo Notice: Directory %%I contains files other than .tmp and .html files.
        )
    )

    echo.
)

exit /b
