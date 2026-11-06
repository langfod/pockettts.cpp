@echo off

set pocket=build\Release\pocket-tts.exe

REM F32 BF16 Q8_0 Q4_K_M
set type=F32
for %%b in (BF16 Q8_0 Q4_K_M) do (
    call :process_type %%b
)
goto :eof

:process_type
set type=%1
for %%f in ("models\community\pocket-tts-ru\russian-%type%.gguf" "models\community\xVibePocketTTS\*-%type%.gguf") do (
    echo [Processing] %%f
    if not exist "%%f" (
        continue
    )    
    call :clone %%f %type%

)
goto :eof

:clone
set model=%1
set type=%2
call set outname=%~nx1
call set out=%%outname:-%type%.gguf=-%type%%%
echo on

        %pocket% ^
        --device cpu ^
        --temp 0.3 ^
        --model %model% ^
        --voice examples\ru_audio.wav ^
        -o tests\output\%out%_3.wav < examples\prompt_ru.txt
@echo off

:eof
