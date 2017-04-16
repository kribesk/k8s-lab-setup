@ECHO OFF
ECHO Building report...

SETLOCAL disableDelayedExpansion
SET SOURCES=
FOR /r %%F in (*.md) DO CALL SET SOURCES=%%SOURCES%% "%%F"
REM set SOURCES=%SOURCES:~1%


ECHO Found sources: %SOURCES%

pandoc -sS --toc --filter pandoc-citeproc -o report.docx %SOURCES%
