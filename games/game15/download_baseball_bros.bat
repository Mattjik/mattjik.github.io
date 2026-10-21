@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM  Baseball Bros asset downloader (run from inside games\gameN)
REM  Downloads only the files the game needs. Skips ads/analytics.
REM ============================================================

set "BASE=https://nealfun.app/game/baseball-bros/"
set "FAILED=0"

where curl >nul 2>nul
if errorlevel 1 (
  echo curl not found. Use Windows 10/11 or install curl.
  pause
  exit /b 1
)

echo Downloading into: %CD%
echo.

REM ---- Main page + scripts ----
call :dl "" "index.html"
call :dl "BaseballBros.js"
call :dl "firebase-app.js"
call :dl "firebase-auth.js"
call :dl "firebase-firestore.js"

REM ---- Images ----
for %%F in (loading4.png fbro.png bbbro.png sbro.png wbro.png kbro.png bbro.png favicon.png loading.jpg INGAME.png COURT.png) do call :dl "assets/%%F"

REM ---- Audio (root) ----
for %%F in (theme_arena theme theme_inplay theme_select vo_it_drops catch vo_hes_out organ vo_strikeout5 fb2 vo_out_at_the_plate whistle vo_he_got_him_looking bat_hit vo_strikeout4 vo_inningover1 vo_hithard1 land jump vo_strikeout1 vo_walk1 vo_inningover2 vo_strikeout3 vo_hithard2 vo_hithard3 vo_strikeout2 vo_inningover3 vo_walk2 vo_homerun4 announcer_slide vo_runscored2 vo_startgame2 vo_steal1 vo_startgame3 vo_runscored3 vo_error1 vo_homerun5 vo_hitbatter4 vo_error3 vo_runscored1 vo_startgame1 vo_steal2 vo_inside_the_park_homerun vo_strike_two vo_ground_ball vo_error2 vo_three_run_dinger vo_homerun2 vo_popped_up vo_hitbatter3 vo_runscored4 vo_startgame4) do call :dl "assets/audio/%%F.m4a"

for %%F in (firework_explode vo_double_play vo_base_hit countdown vo_hitbatter2 vo_homerun3 vo_called_strike_three bounce vo_homerun1 vo_grand_slam vo_he_walked_him vo_ball_one vo_hitbatter1 vo_error4 buzzer pop play_picked vo_hes_charging_the_mound vo_strike_one crowd_roar vo_ball_three chirp vo_out_at_first ball_hit_2 vo_stolen2 vo_pitch1 vo_he_beat_the_tag vo_triple_play touchdown shoots vo_running3 smash vo_stolen1 vo_pitch2 vo_ball_two vo_hes_staying_alive mitt vo_foul_ball vo_pitch3 intro_ramp crowd_human_score organic_whoosh_07 vo_he_goes_down_swinging vo_fight crowd_cpu_score slide crowd_clapping vo_he_beat_the_throw vo_drop1 vo_safe1 crowd_boo tip vo_the_payoff punch_headhit foot1 vo_safe2 punch select vo_off_the_wall vo_homerun ball_hit foot2) do call :dl "assets/audio/%%F.m4a"

REM ---- Audio (tmp) ----
for %%F in (vo_hes_out vo_strikeout5 vo_he_got_him_looking vo_strikeout4 vo_inningover1 vo_hithard1 vo_strikeout1 vo_walk1 vo_inningover2 vo_strikeout3 vo_safe vo_hithard2 vo_hithard3 vo_strikeout2 vo_inningover3 vo_walk2 vo_homerun4 vo_startgame2 vo_startgame3 vo_homerun5 vo_hitbatter4 vo_startgame1 vo_strike_two vo_ground_ball vo_three_run_dinger vo_homerun2 vo_popped_up vo_hitbatter3 vo_startgame4 vo_double_play vo_base_hit vo_hitbatter2 vo_homerun3 vo_called_strike_three vo_homerun1 vo_grand_slam vo_he_walked_him vo_ball_one vo_hitbatter1 vo_hes_charging_the_mound vo_strike_one vo_ball_three vo_out_at_first vo_stolen2 vo_he_beat_the_tag vo_triple_play vo_stolen1 vo_ball_two vo_hes_staying_alive vo_foul_ball vo_he_goes_down_swinging vo_fight vo_hes_safe vo_he_beat_the_throw vo_off_the_wall vo_homerun) do call :dl "assets/audio/tmp/%%F.m4a"

REM ---- Audio (tmp/tmp2/output) ----
for %%F in (vo_the_pitch vo_it_drops vo_he_crosses_the_plate vo_out_at_the_plate vo_delivers vo_oops vo_put_one_on_the_board vo_smacked2 vo_inside_the_park_homerun vo_smacked3 vo_he_scores vo_smacked4 vo_hes_going vo_smacked5 vo_hes_stealing vo_error vo_oh_no vo_run_scored vo_he_dropped_it vo_the_payoff vo_he_deals) do call :dl "assets/audio/tmp/tmp2/output/%%F.m4a"

REM ---- .gitattributes (stops Git from corrupting binary files) ----
if not exist "%CD%\.gitattributes" (
  >  .gitattributes echo *.png binary
  >> .gitattributes echo *.jpg binary
  >> .gitattributes echo *.m4a binary
  >> .gitattributes echo *.js  -text
)

echo.
if "%FAILED%"=="0" (echo Done. All files downloaded.) else (echo Done with %FAILED% failed download(s). See above.)
pause
exit /b 0

REM ---- Download helper: %1 = relative path, %2 = optional local filename ----
:dl
set "REL=%~1"
set "OUT=%~1"
if not "%~2"=="" set "OUT=%~2"
curl -sS -L --fail --create-dirs -o "%OUT%" "%BASE%%REL%"
if errorlevel 1 (
  echo [FAILED] %REL%
  set /a FAILED+=1
) else (
  echo [ok] %OUT%
)
exit /b 0
