@echo off
:: =================================================================
:: ========== GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV =========
:: === PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA ===
:: ========================= BY VerbaL 2015 ========================
:: =================================================================
set VERSION=3.2

:inizio
chcp 65001 >nul
set "margin=  "
set "cc="
set "p="
set "pp="
set "lastp="
set "lastpn="
set "proxpn="
set "plname="
set "plpath="
set "file="
set SF=[103;30m║                S E A S O N   F I N A L E   S E A S O N   F I N A L E                ║[0m
	::CHECK OS & STARTUP
	powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption" | find "Windows 11" >nul
	if errorlevel 1 (mode con: cols=100 lines=50)
	::WINDOWS 11 CHECK TERMINAL OR CMD (IF TERMINAL DEFAULT LAYOUT, IF CMD 100X50)
	if not defined WT_SESSION (mode con: cols=100 lines=50)
	rem mode con: cols=120 lines=50&cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 3F
cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 0F&echo(
echo %margin%[103;30m╔═════════════════════════════════════════════════════════════════════════════════════╗[0m
echo %margin%[103;30m║                     GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV                    ║[0m
echo %margin%[103;30m║              PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA              ║[0m
echo %margin%[103;30m║                               %VERSION% BY VerbaL 2015-%date:~6,4%                               ║[0m
echo %margin%[103;30m╚═════════════════════════════════════════════════════════════════════════════════════╝[0m
echo(
echo(
set myself="%~f0"
set mydata=METADATA
set myhelp=#HELP#
set "tempfileplayer=%USERPROFILE%\%~n0.player"
set tmp_puntata=%TEMP%\tmp_puntata.batch
set "media=[.]avi$ [.]mkv$ [.]mp4$ [.]m4v$ [.]mov$ [.]wmv$ [.]flv$ [.]webm$ [.]mpg$ [.]mpeg$ [.]ts$ [.]m2ts$ [.]mts$ [.]vob$ [.]ogv$ [.]3gp$"
set "subs=[.]srt$ [.]ass$ [.]ssa$ [.]vtt$ [.]sub$ [.]idx$ [.]sup$ [.]sbv$ [.]ttml$ [.]dfxp$ [.]smi$ [.]sami$ [.]stl$ [.]itt$"

::YOU ARE HERE
echo %margin%[7mDIRECTORY CORRENTE:[0m %cd%&echo(

::ELENCO I FILE DISPONIBILI
echo %margin%[7mELENCO DELLE PUNTATE:[0m[93m
::CONTROLLA TIPO PUNTATE 0x00 0e00 0ep00 0.00 .00. 00
type nul>"%TEMP%\puntate_type.dat"
echo [0-9]x[0-9][0-9]*;x>>"%TEMP%\puntate_type.dat"
echo [0-9]e[0-9][0-9]*;e>>"%TEMP%\puntate_type.dat"
echo [0-9]ep[0-9][0-9]*;ep>>"%TEMP%\puntate_type.dat"
echo [0-9].e[0-9][0-9]*;e>>"%TEMP%\puntate_type.dat"
echo [0-9][.][0-9][0-9]*;.>>"%TEMP%\puntate_type.dat"
echo [.][0-9][0-9]*[.];.>>"%TEMP%\puntate_type.dat"
echo ^^[0-9][0-9]*..;*>>"%TEMP%\puntate_type.dat"
setlocal enabledelayedexpansion
for /f "usebackq tokens=1,2 delims=;" %%t in ("%TEMP%\puntate_type.dat") do (
    set "found="
    for /f "delims=" %%A in ('dir /b /a-d ^| findstr /R /I "%media%" ^| findstr /R /I "%%t" ^| findstr /vi "%subs%"') do (
        set "line=%%A"
        echo(%margin%!line:~0,85!..
        set found=1
    )
    if defined found (
        endlocal & set puntata=%%u
        for /f %%a in ('dir /b /a-d ^| findstr /vi "[.]srt$" ^| findstr /vi "[.]sub$" ^| findstr /vi "[.]idx$" ^| findstr /i %%t ^| find /c "."') do (
            set npuntate=%%a
            goto ok
        )
    )
)

:ok
::validatore e note
REM CONTROLLO PATH/FILE SOSPETTI (SAFE MODE) ......
:: []
cd|findstr "[[] []]" >nul && (
echo(&echo(
echo %margin%[0;7m╔═════════════════════════════════════════════════════════════════════════════════════╗[0m
echo %margin%[0;7m║ NOTE UTENTE                                                                         ║[0m
echo %margin%[0;7m╠═════════════════════════════════════════════════════════════════════════════════════╣[0m
echo %margin%[0;7m║ L'UTILIZZO DI CARATTERI SPECIALI [ ] NEI PATH POTREBBE PORTARE                      ║[0m
echo %margin%[0;7m║ A PROBLEMI DI RUN DELLO SCRIPT                                                      ║[0m
echo %margin%[0;7m╚═════════════════════════════════════════════════════════════════════════════════════╝[0m
echo(
)
REM CONTROLLO PATH/FILE SOSPETTI (SAFE MODE) ......

::validatore finale
if "%puntata%"=="" (
	setlocal disabledelayedexpansion
	echo %margin%Nessuna puntata presente in questa directory.&echo(
	for /f "tokens=2* delims=#" %%a in ('type %myself%^|findstr "^%myhelp%"') do @echo(%margin%%%a
	echo(&pause&goto END
)
endlocal
set "add="
if %npuntate% lss 10 (set "add= ") else (set "add=")
echo(&echo %margin%[0m╔═════════════════════════════════════════════════════════════════════════════════════╗&echo %margin%║ [0m[7mTIPO PUNTATE:[0m %puntata%   [7mNUMERO PUNTATE:[0m %npuntate%                                                %add%║
echo %margin%[0m╚═════════════════════════════════════════════════════════════════════════════════════╝

	REM INIT --- INIZIO NORMALIZZAZIONE NOMI FILE (VMAX v3.3 FINAL ONE-LINER) --- FAST.PS
	:: Estrae le estensioni dalle tue variabili %media% e %subs% e pulisce i nomi
	powershell -NoProfile -Command "$vid = '%media%' -split ' ' -replace '\[\.\]', '.' -replace '\$', ''; $sub = '%subs%' -split ' ' -replace '\[\.\]', '.' -replace '\$', ''; Get-ChildItem -LiteralPath . -File | Where-Object { $e = $_.Extension; ($vid + $sub) | Where-Object { $e -match $_ } } | ForEach-Object { $n = $PSItem.Name; $new = $n -replace '[&!%%%%^();, ]+', '.'; $new = $new -replace '\.{2,}', '.'; if ($n -ne $new -and -not (Test-Path -LiteralPath $new)) { Rename-Item -LiteralPath $n -NewName $new -ErrorAction SilentlyContinue } }" 2>nul
	REM INIT --- FINE NORMALIZZAZIONE --- FAST.PS

::REPORT + PLAYER DA TEMPFILES / METADATA
echo(
echo %margin%[90m╔═════════════════════════════════════════════════════════════════════════════════════╗[0m
echo %margin%[90m║[0m [96mULTIMA PUNTATA VISTA[0m                                                                [90m║[0m
echo %margin%[90m╠═════════════════════════════════════════════════════════════════════════════════════╝[0m

REM Estrae i metadata dallo script
set "lastp="
set "lastpn="
for /f "usebackq tokens=1,2,3 delims=;" %%a in (`findstr /b "%mydata%;" %myself%`) do (
    if not "%%c"=="" (
        set "lastp=%%b"
        set "lastpn=%%c"
    )
)
if defined lastp (
    echo %margin%[90m║[0m Num  : [93m%lastpn%[0m
	echo %margin%[90m║[0m File : [92m"%lastp:~,73%"[0m
    set /a proxpn=100+%lastpn%+1-100 2>nul
) else (
    echo %margin%[90m║[0m [91mNESSUNA PUNTATA ANCORA VISTA[0m
    set proxpn=1
)
echo %margin%[90m╚═════════════════════════════════════════════════════════════════════════════════════╝[0m

:player
::PLAYER
if exist "%tempfileplayer%" (
    for /f "tokens=1,2 delims=;" %%a in ('type "%tempfileplayer%"') do (
        set plname=%%a
        set plpath=%%b
    )
) else (
    REM VLC 32/64 - INSTALLED
    if exist "%ProgramFiles(x86)%\VideoLAN\VLC\vlc.exe" (echo VLC;C:\Program Files ^(x86^)\VideoLAN\VLC\vlc.exe>"%tempfileplayer%")
	if exist "%ProgramFiles%\VideoLAN\VLC\vlc.exe" (echo VLC;C:\Program Files\VideoLAN\VLC\vlc.exe>"%tempfileplayer%")
    goto inizio
)

:selector
echo(
set /p "p=%margin: =═% Puntata da vedere n.[[7mx[0m] [[7m+[0m=Puntata+1] [[7mU[0m=Ultima vista] [[7mP[0mlayer=[93m%plname%[0m] [[7mQ[0m=ESCE] ? "
if "%p%"=="" goto inizio
if /i "%p%"=="q" exit /b 1
if /i "%p%"=="p" goto setplayer
if /i "%p%"=="u" (if not "%lastp%"=="" (set pp=%lastpn%&goto check) else (goto inizio))
if "%p%"=="+" (set pp=%proxpn% & goto check)
echo %p%|findstr "^[0-9][0-9]*$" >nul && set pp=%p%

:check
::CHECK SYNTAX
echo(
set pp=%pp: =%
set /a pp=100+%pp%-100 2>nul
echo %pp%|findstr "^[0-9][0-9]*$" >nul
if errorlevel 1 (echo(&echo %margin%[91mPUNTATA NON CORRETTA![0m&timeout /t 5&goto inizio)

::CHECK EXIST
set "file="
for /f "delims=" %%f in ('dir /b /a-d "*%puntata%0%pp%*" 2^>nul ^| findstr /R /I "%puntata%0%pp%[^0-9]"') do (set "file=%%f" & goto play_it)
for /f "delims=" %%f in ('dir /b /a-d "*%puntata%%pp%*" 2^>nul ^| findstr /R /I "%puntata%%pp%[^0-9]"') do (set "file=%%f" & goto play_it)
echo(&echo %margin%[91mPUNTATA %pp% NON TROVATA![0m&timeout /t 5 >nul&goto inizio

:play_it
::calcola l'estensione
set pp=%pp: =%
set ext=
for %%e in (.avi .mkv .mp4 .m4v) do (if not defined ext if exist "*%puntata%0%pp%*%%e" set ext=%%e)
for %%e in (.avi .mkv .mp4 .m4v) do (if not defined ext if exist "*%puntata%%pp%*%%e" set ext=%%e)
if not defined ext (echo %margin%[91mEstensione non trovata![0m&pause&goto inizio)

	REM SEASON FINALE?
	rem for /f "delims=" %%a in ('powershell " %pp% + 0 "') do (set ppfinale=%%a)
	set /a ppfinale=100+%pp%-100 2>nul
	if "%ppfinale%" == "%npuntate%" (
	echo %margin%[103;30m╔═════════════════════════════════════════════════════════════════════════════════════╗[0m
	rem for /l %%a in (1,1,25) do <nul set /p x=%SF%
	for /l %%a in (1,1,5) do echo %margin%%SF%
	echo %margin%[103;30m╚═════════════════════════════════════════════════════════════════════════════════════╝[0m
	echo(
	)

echo %margin% Vuoi visionare la Puntata:[93m
echo(|set /p=%margin: =═% &dir /b /a-d "%file%" 2>nul
if errorlevel 1 (echo(&echo %margin% [91mPUNTATA NON CORRETTA![0m&timeout /t 5&goto inizio)
echo(|set /p p="%margin: =═% "&set /p cc=[0m[[7mS[0m/[7mn[0m] 
if /i "%cc%"=="n" goto inizio

::MEMORIZZA ULTIMA PUNTATA
REM RIMUOVE METADATA VECCHI
del "%tmp_puntata%" 2>nul
findstr /v /b /c:"%mydata%;" %myself% >"%tmp_puntata%"
REM AGGIUNGE NUOVO
>>"%tmp_puntata%" echo %mydata%;%file:"=%;%pp%
REM RISCRIVE SCRIPT
move /y "%tmp_puntata%" %myself% >nul

:play
::START PLAYING
if not exist "%plpath%" (echo %margin% !!!IL LETTORE NON E' PRESENTE NEL SISTEMA NEL PATH INDICATO!!!&pause&exit /b 1)
echo( & echo %margin% [7mINIZIO RIPRODUZIONE PUNTATA:[0m[93m
if /i "%p%"=="u" (echo(|set /p="%margin: =═% %lastp%[0m" & call start /I /WAIT "" "%plpath%" "%~dp0%lastp%") else (echo(|set /p="%margin: =═% %file%[0m" & call start /I /WAIT "" "%plpath%" "%~dp0%file:"=%")
exit /b 0

:setplayer
:: SELEZIONA IL PLAYER DA UTILIZZARE - VLC [default] - MPC/BE - SM
echo(&set /p player=[7m1[0m)VLC [7m2[0m)SM [7m3[0m)MPC [7m4[0m)Custom ? 
if "%player%"=="" goto inizio
if "%player%"=="1" (
    REM VLC 32/64 - INSTALLED
    if exist "%ProgramFiles(x86)%\VideoLAN\VLC\vlc.exe" (echo VLC;C:\Program Files ^(x86^)\VideoLAN\VLC\vlc.exe>"%tempfileplayer%")
	if exist "%ProgramFiles%\VideoLAN\VLC\vlc.exe" (echo VLC;C:\Program Files\VideoLAN\VLC\vlc.exe>"%tempfileplayer%")
)
if "%player%"=="2" (
    REM SMPLAYER
    >"%tempfileplayer%" echo SM;D:\Utility\Audio-Video\Players\smplayer-portable.x64\smplayer.exe
)
if "%player%"=="3" (
    REM MEDIAPLAYER-CLASSIC-BE
    >"%tempfileplayer%" echo MPC;D:\Utility\Audio-Video\Players\MPC-HC.x64\mpc-hc64.exe
)
if "%player%"=="4" (
    REM CUSTOM PLAYER
    echo(&set /p Name=Name ? 
    set /p Path_To_Exe=Path_To_Exe ? 
    if exist "%Path_To_Exe%" (
        >"%tempfileplayer%" echo %Name%;"%Path_To_Exe%"
    ) else (
        echo Path to exe errato.&timeout /t 10
    )
)
goto inizio

:END
timeout /t 30 & exit /b 1

exit /b 0

REM ================================================ HELP ====================================================
#HELP#[103m[30m╔═════════════════════════════════════════════════════════════════════════════════════╗[0m
#HELP#[103m[30m║                               FORMATO NOMI PUNTATE                                  ║[0m
#HELP#[103m[30m╚═════════════════════════════════════════════════════════════════════════════════════╝[0m
#HELP# #
#HELP#[96mSTAGIONE:[0m
#HELP#  [90m- 1 o 2 cifre[0m
#HELP#  [90m- Esempi:[0m [93mS1  S01  ST1  ST01[0m
#HELP# #
#HELP#[96mSEPARATORE:[0m
#HELP#  [93mx   e   ep   .[0m
#HELP# #
#HELP#[96mNUMERO PUNTATA:[0m
#HELP#  [90m- 1 o 2 cifre[0m
#HELP#  [90m- Esempi:[0m [93m1  02  10[0m
#HELP# #
#HELP#[90m---------------------------------------------------------------------------------------[0m
#HELP#[95mESEMPI VALIDI:[0m
#HELP#[90m---------------------------------------------------------------------------------------[0m
#HELP#  [92m- 1x1[0m
#HELP#  [92m- 1x01[0m
#HELP#  [92m- 1e1[0m
#HELP#  [92m- 1e01[0m
#HELP#  [92m- 1ep1[0m
#HELP#  [92m- 1ep01[0m
#HELP#  [92m- 1.e1[0m
#HELP#  [92m- 1.e01[0m
#HELP#  [92m- 1.1[0m
#HELP#  [92m- 1.01[0m
#HELP#  [92m- 01[0m
#HELP#[90m---------------------------------------------------------------------------------------[0m
REM ================================================ HELP ====================================================

REM !!!!!!!!!!!!!!!!!!!!!!! SEZIONE METADATA - NECESSARIA PER L'ESECUZIONE E MEMORIZZAZIONE DATI !!!!!!!!!!!!!!!!!!!!!!!
