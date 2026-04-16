@echo off
:: -------------------------------------------------------------------
:: GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV
:: PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA
:: BY VerbaL 2015
:: -------------------------------------------------------------------
set VERSION=3.0

:inizio
set cc=
set p=
set pp=
set lastp=
set lastpn=
set proxpn=
set proxpn2=
set plname=
set plpath=
set SF=[1;4;103m[30m************************ SEASON FINALE [0m
::CHECK OS & STARTUP
powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption" | find "Windows 11" >nul
if errorlevel 1 (mode con: cols=100 lines=50)
::WINDOWS 11 CHECK TERMINAL OR CMD (IF TERMINAL DEFAULT LAYOUT, IF CMD 100X50)
if not defined WT_SESSION (mode con: cols=100 lines=50)
rem mode con: cols=120 lines=50&cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 3F
cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 0F
echo [103m[30m+-------------------------------------------------------------------------------------+
echo ^|              GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV                           ^|
echo ^|          PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA                  ^|
echo ^|                           %VERSION% BY VerbaL 2015-%date:~6,4%                                   ^|
echo +-------------------------------------------------------------------------------------+[0m
echo.
echo.
set myself="%~f0"
set mydata=METADATA
set myhelp=#HELP#
set tempfileplayer=%USERPROFILE%\%~n0.player
set tmp_puntata=%TEMP%\tmp_puntata.batch
set "media=[.]avi$ [.]mkv$ [.]mp4$ [.]m4v$ [.]mov$ [.]wmv$ [.]flv$ [.]webm$ [.]mpg$ [.]mpeg$ [.]ts$ [.]m2ts$ [.]mts$ [.]vob$ [.]ogv$ [.]3gp$"
set "subs=[.]srt$ [.]ass$ [.]ssa$ [.]vtt$ [.]sub$ [.]idx$ [.]sup$ [.]sbv$ [.]ttml$ [.]dfxp$ [.]smi$ [.]sami$ [.]stl$ [.]itt$"

::YOU ARE HERE
echo [7mDIRECTORY CORRENTE:[0m %cd%&echo.

::ELENCO I FILE DISPONIBILI
echo [7mELENCO DELLE PUNTATE:[0m[93m
::CONTROLLA TIPO PUNTATE 0x00 0e00 0ep00 0.00 .00. 00
echo.>"%TEMP%\puntate_type.dat"
echo "[0-9]x[0-9][0-9]";x>>"%TEMP%\puntate_type.dat"
echo "[0-9]e[0-9][0-9]";e>>"%TEMP%\puntate_type.dat"
echo "[0-9]ep[0-9][0-9]";ep>>"%TEMP%\puntate_type.dat"
echo "[0-9].e[0-9][0-9]";e>>"%TEMP%\puntate_type.dat"
echo "[0-9][.][0-9][0-9]";.>>"%TEMP%\puntate_type.dat"
echo "[.][0-9][0-9][.]";.>>"%TEMP%\puntate_type.dat"
echo "^[0-9][0-9]..";*>>"%TEMP%\puntate_type.dat"
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%t in (%TEMP%\puntate_type.dat) do (
    set "found="
    for /f "delims=" %%A in ('dir /b /a-d ^| findstr /R /I "%media%" ^| findstr /R /I "%%t" ^| findstr /vi "%subs%"') do (
        set "line=%%A"
        echo(!line:~0,75!..
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
REM CONTROLLO FILE SOSPETTI (SAFE MODE) ...... TO FIX
rem dir /b | findstr /r "[0-9][0-9]" >nul && echo File sospetti con numerazione presenti nella cartella.
REM CONTROLLO FILE SOSPETTI (SAFE MODE) ...... TO FIX
if "%puntata%"=="" (
setlocal disabledelayedexpansion
echo Nessuna puntata presente in questa directory.&echo.
for /f "tokens=2* delims=#" %%a in ('type %myself%^|findstr "^%myhelp%"') do @echo(%%a
echo.&pause&goto END
)
endlocal
echo.&echo [0m+-------------------------------------------------------------------------------------+&echo|set /p=[7mTIPO PUNTATE:[0m %puntata%   [7mNUMERO PUNTATE:[0m %npuntate%
echo.&echo [0m+-------------------------------------------------------------------------------------+

::REPORT + PLAYER DA TEMPFILES / METADATA
echo.
echo [90m+-------------------------------------------------------------------------------------+[0m
echo [90m^|[0m [96mULTIMA PUNTATA VISTA[0m                                                                [90m^|[0m
echo [90m+-------------------------------------------------------------------------------------+[0m

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
    echo [90m^|[0m Num  : [93m%lastpn%[0m
    echo [90m^|[0m File : [92m%lastp:~,75%..[0m
    set /a proxpn=1%lastpn% - 99 >nul
    set /a proxpn2=1%lastpn% - 98 >nul
) else (
    echo [90m^|[0m  [91mNESSUNA PUNTATA ANCORA VISTA[0m
    set proxpn=1
    set proxpn2=2
)
echo [90m+-------------------------------------------------------------------------------------+[0m

:player
::PLAYER
if exist %tempfileplayer% (
for /f "tokens=1,2 delims=;" %%a in ('type %tempfileplayer%') do (
set plname=%%a
set plpath=%%b
)
) else (
rem echo No %tempfileplayer%, creo il file... VLC verra' impostato come Mediaplayer di default.
REM VLC 32/64 - INSTALLED - per versioni portable settare a mano il path a vlc.exe
if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" echo VLC;C:\Program Files ^(x86^)\VideoLAN\VLC\vlc.exe>%tempfileplayer%
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" echo VLC;C:\Program Files\VideoLAN\VLC\vlc.exe>%tempfileplayer%
goto inizio
)

:selector
echo.
set /p p=Puntata da vedere n.[[7mxx[0m] [[7m+[0m=Puntata+1] [[7m++[0m=Puntata+2] [[7mU[0m=Ultima vista] [[7mP[0mlayer=[93m%plname%[0m] [[7mQ[0m=ESCE] ? 
if "%p%"=="" goto inizio
if /i "%p%"=="q" exit /b 1
if /i "%p%"=="p" goto setplayer
if /i "%p%"=="u" (if not "%lastp%"=="" (set pp=%lastpn%&goto check) else (goto inizio))
if "%p%"=="+" (if %proxpn% lss 10 (set pp=0%proxpn%) else (set pp=%proxpn%) & goto check)
if "%p%"=="++" (if %proxpn2% lss 10 (set pp=0%proxpn2%) else (set pp=%proxpn2%) & goto check)
if %p% geq 0 set pp=%p%


:check
::CHECK SYNTAX
echo.
echo %pp%|findstr "^[0-9][0-9]" >nul
if errorlevel 1 (echo.&echo [91mPUNTATA NON CORRETTA![0m&timeout /t 5&goto inizio)
::CHECK EXIST
if not exist *%puntata%%pp%* (echo.&echo [91mPUNTATA %pp% NON TROVATA![0m&timeout /t 5 >nul&goto inizio)
::calcola l'estensione
set ext=
for %%e in (.avi .mkv .mp4 .m4v) do (if not defined ext if exist "*%puntata%%pp%*%%e" set ext=%%e)
if not defined ext (echo [91mEstensione non trovata![0m&pause&goto inizio)
::CHECK SINGOLA PUNTATA
for /f %%a in ('forfiles /m "*%puntata%%pp%*%ext%"^|find /c "%pp%"') do set nn=%%a
if %nn% gtr 1 (echo TROVATI PIU' FILE CON DENOMINAZIONE "%pp%"&timeout /t 10&goto inizio)

REM SEASON FINALE?
	rem for /f "delims=" %%a in ('powershell " %pp% + 0 "') do (set ppfinale=%%a)
	set /a ppfinale=1%pp%-100 2>nul
	rem if "%ppfinale%" == "%npuntate%" for /l %%a in (1,1,25) do (echo.|set /p x=%SF%)
	if "%ppfinale%" == "%npuntate%" for /l %%a in (1,1,25) do <nul set /p x=%SF%
if "%ppfinale%" == "%npuntate%" echo.&echo.

echo Vuoi visionare la Puntata:[93m
dir /b /a-d *%puntata%%pp%*%ext%
rem echo.[0m

set /p cc=[0m[[7mS[0m/[7mn[0m]
if /i "%cc%"=="n" goto inizio

::MEMORIZZA ULTIMA PUNTATA
REM RIMUOVE METADATA VECCHI
del "%tmp_puntata%" 2>nul
findstr /v /b /c:"%mydata%;" %myself% >"%tmp_puntata%"
REM AGGIUNGE NUOVO
set "file="
for /f "delims=" %%a in ('dir /b /a-d *%puntata%%pp%*%ext%') do (if not defined file set "file=%%a")
if not defined file (
    echo [91mFile non trovato![0m&pause
    goto inizio
)
setlocal disabledelayedexpansion
for %%F in ("%file%") do (
    >>"%tmp_puntata%" echo %mydata%;%%~nxF;%pp%
)
endlocal
REM RISCRIVE SCRIPT
move /y "%tmp_puntata%" %myself% >nul

:play
::START PLAYING
if not exist "%plpath%" (echo !!!IL LETTORE NON E' PRESENTE NEL SISTEMA NEL PATH INDICATO!!!&pause&exit /b 1)
rem echo %plname% - %plpath% - %~d0%~p0 & pause
echo. & echo [7mINIZIO RIPRODUZIONE PUNTATA:
if /i "%p%"=="u" (echo|set /p ="[93m%lastp%[0m" & call start /I /WAIT "" "%plpath%" "%~d0%~p0%lastp%") else (for %%a in (*%puntata%%pp%*%ext%) do (echo|set /p ="[93m%%a[0m" & call start /I /WAIT "" "%plpath%" "%~d0%~p0%%a"))
exit /b 0

:setplayer
:: SELEZIONA IL PLAYER DA UTILIZZARE - VLC [default] - MPC/BE - SM
echo.&set /p player=[7m1[0m)VLC [7m2[0m)SM [7m3[0m)MPC [7m4[0m)Custom ? 
	if "%player%"=="" goto inizio
	if "%player%"=="1" (
REM VLC 32/64 - INSTALLED - per versioni portable settare a mano il path a vlc.exe
if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" echo VLC;C:\Program Files ^(x86^)\VideoLAN\VLC\vlc.exe>%tempfileplayer%
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" echo VLC;C:\Program Files\VideoLAN\VLC\vlc.exe>%tempfileplayer%
	)
	if "%player%"=="2" (
REM SMPLAYER
echo SM;D:\Utility\Audio-Video\Players\smplayer-portable.x64\smplayer.exe>%tempfileplayer%
	)
	if "%player%"=="3" (
REM MEDIAPLAYER-CLASSIC-BE
echo MPC;D:\Utility\Audio-Video\Players\MPC-HC.x64\mpc-hc64.exe>%tempfileplayer%
	)
	if "%player%"=="4" (
REM CUSTOM PLAYER
echo.&set /p Name=Name ? &set /p Path_To_Exe=Path_To_Exe ? 
if exist "%Path_To_Exe%" (echo %Name%;%Path_To_Exe%>%tempfileplayer%) else (echo Path to exe errato.&timeout /t 10)
	)
REM ---------------------------------------------------------------------------------- PLAYERS
REM ---------------------------------------------------------------------------------- PLAYERS CHECK
goto inizio

:END
timeout /t 30 & exit /b 1

exit /b 0
REM ================================================ HELP ====================================================
#HELP#[103m[30m=======================================================================================[0m
#HELP#[103m[30m                        FORMATO NOMI PUNTATE                                           [0m
#HELP#[103m[30m=======================================================================================[0m
#HELP#
#HELP#[96mSTAGIONE:[0m
#HELP#  [90m- 1 o 2 cifre                                                                       [0m
#HELP#  [90m- Esempi:[0m [93mS1  S01  ST1  ST01                                                       [0m
#HELP#
#HELP#[96mSEPARATORE:[0m
#HELP#  [93mx   e   ep   .                                                                       [0m
#HELP#
#HELP#[96mNUMERO PUNTATA:[0m
#HELP#  [90m- sempre 2 cifre                                                                    [0m
#HELP#  [90m- Esempi:[0m [93m01  02  10                                                                [0m
#HELP#
#HELP#[90m---------------------------------------------------------------------------------------[0m
#HELP#[95mESEMPI VALIDI:[0m
#HELP#[90m---------------------------------------------------------------------------------------[0m
#HELP#  [92m- 1x01                                                                              [0m
#HELP#  [92m- 1e01                                                                              [0m
#HELP#  [92m- 1ep01                                                                             [0m
#HELP#  [92m- 1.e01                                                                             [0m
#HELP#  [92m- 1.01                                                                              [0m
#HELP#  [92m- 01                                                                                [0m
#HELP#[90m---------------------------------------------------------------------------------------[0m
REM ================================================ HELP ====================================================

REM !!!!!!!!!!!!!!!!!!!!!!! SEZIONE METADATA - NECESSARIA PER L'ESECUZIONE E MEMORIZZAZIONE DATI !!!!!!!!!!!!!!!!!!!!!!!
