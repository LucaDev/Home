@echo off
setlocal enabledelayedexpansion

:: Initialize network
wpeutil InitializeNetwork

:CHECK_NETWORK
ping -n 1 homeserver >nul
if errorlevel 1 (
    echo Waiting for network...
    timeout /t 2 >nul
    goto CHECK_NETWORK
)

echo Network initialized.

:: Map network drive
net use M: \\homeserver.local\WindowsISOs /user:guest /persistent:no
if errorlevel 1 (
    echo Failed to map network drive.
    exit /b 1
)

echo Network drive M: mapped successfully.

:: Check for autounattend.xml
set UNATTEND_PATH=X:\Windows\System32\autounattend.xml

:: Locate setup.exe case-insensitively
for %%F in (setup.exe Setup.exe SETUP.exe setup.EXE Setup.EXE SETUP.EXE) do (
    if exist "M:\{{SYSTEM}}\%%F" (
        set SETUP_PATH=M:\{{SYSTEM}}\%%F
    )
)

if not defined SETUP_PATH (
    echo setup.exe not found in M:\{{SYSTEM}}\
    exit /b 1
)

echo Found setup executable: !SETUP_PATH!

:: Run setup with or without unattend file
if exist "%UNATTEND_PATH%" (
    echo Running setup with unattended installation.
    !SETUP_PATH! /unattend:"%UNATTEND_PATH%"
) else (
    echo Running setup normally.
    !SETUP_PATH!
)
