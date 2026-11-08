@echo off
rem Pocket TTS checkpoints from HuggingFace into
rem checkpoints\pocket-tts. Only conversion inputs are pulled (YAMLs, F32
rem safetensors at root and one level down, tokenizer.json / *.model).
rem Usage: download.cmd [repo ...]   (no args = all repos below)

setlocal enabledelayedexpansion
rem Anchor to the script's own folder so relative paths work from any CWD.
cd /d "%~dp0"
set "DIR=checkpoints"
rem Prefer a venv-local hf.exe ; fall back to hf.
if exist ".venv\Scripts\hf.exe" (set "HF=.venv\Scripts\hf.exe") else (set "HF=hf")
echo [hf] %HF%
if not exist "%DIR%" mkdir "%DIR%"

REM Repositories to download from HuggingFace

call :download "kyutai/pocket-tts"
goto :eof

:download
set "REPO=%~1"
for /f "tokens=*" %%a in ('echo %REPO%') do set "NAME=%%~na"
set "TARGET=%DIR%\%NAME%"
echo [Info] Processing %NAME%
set "HAVE_WEIGHTS="
if exist "%TARGET%\*.safetensors" set "HAVE_WEIGHTS=1"
if exist "%TARGET%\*.pt" set "HAVE_WEIGHTS=1"
if defined HAVE_WEIGHTS (
    echo   [OK] %NAME% -present
    exit /b 0
)
echo   [Download] %NAME% ^<-%REPO%
"%HF%" download %REPO% --local-dir "%TARGET%" --quiet
exit /b 0

 
:eof