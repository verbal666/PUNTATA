@echo off
:: -------------------------------------------------------------------
:: GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV
:: PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA
:: BY VerbaL 2015
:: -------------------------------------------------------------------
set VERSION=2.4


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
wmic os get Caption|find "Windows 11">nul
if errorlevel 1 (mode con: cols=100 lines=50)
::WINDOWS 11 CHECK TERMINAL OR CMD (IF TERMINAL DEFAULT LAYOUT, IF CMD 100X50)
if not defined WT_SESSION (mode con: cols=100 lines=50)
rem mode con: cols=120 lines=50&cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 3F
cls&title GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV&color 0F
echo [103m[30m*****************************************************************************
echo *           GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV                    *
echo *       PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA           *
echo *                      %VERSION% BY VerbaL 2015-%date:~6,4%                              *
echo *****************************************************************************[0m
echo.
set myself=%0
set mydata=METADATA
set tempfileplayer=%USERPROFILE%\%~n0.player

::YOU ARE HERE
echo [7mDIRECTORY CORRENTE:[0m %cd%&echo.


::CONTROLLO PRESENZA FILE CHE CREANO CONFLITTO
::STRINGA DI PROBABILE CONFLITTO:
::-EXCLUDE REGEX: "[.]srt$ [.]sub$ [.]idx$ x[0-9][0-9][0-9]"
::-INCLUDE REGEX: "[0-9].[0-9][0-9].*[0-9][0-9]"
rem set exclude="[.]srt$ [.]sub$ [.]idx$ x[0-9][0-9][0-9] 576 720 1080 264 265 [0-9][0-9][0-9][0-9] 5.1"
rem set include="[0-9].[0-9][0-9].*[0-9][0-9]"
rem dir /b /a-d|findstr /vi %exclude%|findstr /i %include% >nul
rem if %errorlevel% equ 0 (color CF&echo.&echo =-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=&echo.&echo LA DIRECTORY PRESENTA DEI FILE SOSPETTI CON NUMERI CHE CREANO CONFLITTO!&echo RINOMINARE IL FILE SOSTITUENDO IL NUMERO O INSERENDO DEGLI SPAZI!&echo.&echo =-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=ATTENZIONE=-=-=-=-=&echo.&echo.&echo DI SEGUITO I FILE SOSPETTI:&dir /b /a-d|findstr /vi %exclude%|findstr /i %include%&echo.&pause&exit /b 1)


::ELENCO I FILE DISPONIBILI
echo [7mELENCO DELLE PUNTATE:[0m[93m
::CONTROLLA TIPO PUNTATE 0x00 0e00 0ep00 0.00 .00. 00
echo.>"%TEMP%\puntate_type.dat"
echo "[0-9]x[0-9][0-9]";x>>"%TEMP%\puntate_type.dat"
echo "[0-9].e[0-9][0-9]";e>>"%TEMP%\puntate_type.dat"
echo "[0-9]ep[0-9][0-9]";ep>>"%TEMP%\puntate_type.dat"
echo "[0-9][.][0-9][0-9]";.>>"%TEMP%\puntate_type.dat"
echo "[.][0-9][0-9][.]";.>>"%TEMP%\puntate_type.dat"
echo "^[0-9][0-9]..";*>>"%TEMP%\puntate_type.dat"
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%t in (%TEMP%\puntate_type.dat) do (
dir /b /a-d|findstr /vi "[.]srt$ [.]sub$ [.]idx$"|findstr /i %%t
if !errorlevel! equ 0 (endlocal&set puntata=%%u&for /f %%a in ('dir /b /a-d^|findstr /vi "[.]srt$"^|findstr /vi "[.]sub$"^|findstr /vi "[.]idx$"^|findstr /i %%t^|find /c "."') do (set npuntate=%%a&goto ok)))


:ok
if "%puntata%"=="" echo Nessuna puntata presente in questa directory. & goto END
endlocal
echo.&echo [0m-----------------------------------------------------------------------------&echo|set /p=[7mTIPO PUNTATE:[0m %puntata%   [7mNUMERO PUNTATE:[0m %npuntate%


::REPORT + PLAYER DA TEMPFILES / METADATA
::PUNTATA
echo.&echo -----------------------------------------------------------------------------&echo [7mULTIMA PUNTATA VISTA:[0m[93m

REM Estrae i metadata dallo script e verifica dati validi
for /f %%a in ('type %myself%^|find /v /c ""') do (set myline=%%a)
set /a myline=%myline% - 1
for /f "tokens=1,2,3 delims=;" %%a in ('more +%myline% %myself%^|findstr "%mydata%"') do (set mymetadata=%%b)
if not "%mymetadata%"=="%mydata%" (
for /f "tokens=1,2,3 delims=;" %%a in ('more +%myline% %myself%^|findstr "%mydata%"') do (
set lastp=%%b
set lastpn=%%c
echo ^(%%c^) %%b
	if "%%c"=="08" (set proxpn=9&set proxpn2=10&goto player)
	if "%%c"=="09" (set proxpn=10&set proxpn2=11&goto player)
set /a proxpn=%%c + 1 >nul
set /a proxpn2=%%c + 2 >nul
)
) else (echo NESSUNA PUNTATA ANCORA VISTA!&set proxpn=1&set proxpn2=2)


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
::SELECTOR
echo [0m-----------------------------------------------------------------------------&echo.
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
if %errorlevel% equ 1 (echo.&echo PUNTATA NON CORRETTA!&timeout /t 5&goto inizio)
::CHECK EXIST
if not exist *%puntata%%pp%* (echo.&echo PUNTATA INESISTENTE!&timeout /t 5&goto inizio)
::calcola l'estensione
for %%e in (.avi .mkv .mp4 .m4v) do (if exist "*%puntata%%pp%*%%e" set ext=%%e)
::CHECK SINGOLA PUNTATA
for /f %%a in ('forfiles /m "*%puntata%%pp%*%ext%"^|find /c "%pp%"') do set nn=%%a
if %nn% gtr 1 (echo TROVATI PIU' FILE CON DENOMINAZIONE "%pp%"&timeout /t 10&goto inizio)

REM SEASON FINALE?
for /f "delims=" %%a in ('powershell " %pp% + 0 "') do (set ppfinale=%%a)
if "%ppfinale%" == "%npuntate%" for /l %%a in (1,1,25) do (echo.|set /p x=%SF%)
if "%ppfinale%" == "%npuntate%" echo.&echo.

echo Vuoi visionare la Puntata:[93m
dir /b /a-d *%puntata%%pp%*%ext%
rem echo.[0m

set /p cc=[0m[[7mS[0m/[7mn[0m]
if /i "%cc%"=="n" goto inizio


::MEMORIZZA ULTIMA PUNTATA
for /f "tokens=*" %%a in ('dir /b /a-d *%puntata%%pp%*%ext%') do (echo %mydata%;%%a;%pp%>>%myself%)


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
echo MPC;D:\Utility\Audio-Video\Players\MPC-BE.x64\mpc-be64.exe>%tempfileplayer%
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


REM !!!!!!!!!!!!!!!!!!!!!!! SEZIONE METADATA - NECESSARIA PER L'ESECUZIONE E MEMORIZZAZIONE DATI !!!!!!!!!!!!!!!!!!!!!!!
METADATA;METADATA;METADATA
