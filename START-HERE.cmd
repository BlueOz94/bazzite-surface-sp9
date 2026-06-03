@echo off
title Bazzite Surface Pro 9 Setup
echo Requesting Administrator for Windows prep + USB steps...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%USERPROFILE%\bazzite-surface-sp9\windows\RUN-ALL.ps1""'"
pause
