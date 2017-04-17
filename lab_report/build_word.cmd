@ECHO OFF
ECHO Building report...

SETLOCAL disableDelayedExpansion EnableExtensions
SET SOURCES=
FOR /F %%F in ('dir *.md /A-D /B /ON') DO CALL SET SOURCES=%%SOURCES%% "%%F"
REM set SOURCES=%SOURCES:~1%


ECHO Found sources: %SOURCES%

pandoc -sS --toc --filter pandoc-citeproc -o report.docx %SOURCES%
