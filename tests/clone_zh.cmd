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
for %%f in ("models\community\pocketTTS-ZH-6L\*-%type%.gguf") do (
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
        --temp 0.7 ^
        --model %model% ^
        --voice examples\CHI_MAN_F_MaYue.wav ^
        -o tests\output\%out%_7.wav < examples\prompt_zh.txt

        %pocket% ^
        --device cpu ^
        --temp 0.5 ^
        --model %model% ^
        --voice examples\CHI_MAN_F_MaYue.wav ^
        -o tests\output\%out%_5.wav < examples\prompt_zh.txt

        %pocket% ^
        --device cpu ^
        --temp 0.3 ^
        --model %model% ^
        --voice examples\CHI_MAN_F_MaYue.wav ^
        -o tests\output\%out%_3.wav < examples\prompt_zh.txt
@echo off

:eof
