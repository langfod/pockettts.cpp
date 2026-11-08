REM @echo off

set VENV=.venv\Scripts\python.exe

REM config files from or from clone of https://github.com/kyutai-labs/pocket-tts
set POCKETTTS_CONFIGDIR="../../pocket-tts/pocket_tts/config"

echo Download main models...
call download.cmd

echo Download community models...
call download_community.cmd

echo Convert main models...
%VENV% .\convert.py --config-dir %POCKETTTS_CONFIGDIR% --skip-voices

echo Convert community models...
REM Run the community conversion script
%VENV% .\convert_community.py

echo Quantize main models...
call quantize.cmd

echo Quantize community models...
call quantize_community.cmd
