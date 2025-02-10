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
set SETUP_PATH=M:\{{SYSTEM}}\setup.exe

:: Run setup with or without unattend file
if exist "%UNATTEND_PATH%" (
    echo Running setup with unattended installation.
    !SETUP_PATH! /unattend:"%UNATTEND_PATH%"
) else (
    echo Running setup normally.
    !SETUP_PATH!
)
