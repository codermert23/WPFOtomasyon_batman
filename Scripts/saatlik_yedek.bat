@echo off
set DBNAME=WPFDatabase
set INSTANCE=.\SQLEXPRESS
set BACKUPDIR=C:\Users\%USERNAME%\Drive'ım\Yedekler

if not exist "%BACKUPDIR%" mkdir "%BACKUPDIR%"

set TARIH=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%
set TARIH=%TARIH: =0%

sqlcmd -S %INSTANCE% -E -Q "BACKUP DATABASE [%DBNAME%] TO DISK='%BACKUPDIR%\%DBNAME%_%TARIH%.bak' WITH INIT"

for /f "skip=3 delims=" %%F in ('dir /b /o-d "%BACKUPDIR%\%DBNAME%_*.bak"') do del "%BACKUPDIR%\%%F"
