@echo off

rem Batch script that creates a draft of a new post with front matter.
rem Usage: ./draft_new.bat [SLUG]
rem NOTE: It might be better to write a python tool for this purpose.
rem First, obtain the current date and store it in variables.
rem Source: https://stackoverflow.com/questions/19131029/how-to-get-date-in-bat-file
for /f "tokens=1-3 delims=/ " %%i in ("%date%") do (
    set month=%%i
    set day=%%j
    set year=%%k
)
rem Then, build the path for the destination file.
set drafts_folder=_drafts
set date_string=%year%-%month%-%day%
set title=%1
set extension=md
set file_path=%drafts_folder%/%date_string%-%title%.%extension%

rem Finally, output front matter to the file so it exists in the file system.
rem NOTE: Each subsequent call to `echo` after the first must use ">>"
echo --- > %file_path%
echo layout: title >> %file_path%
echo --- >> %file_path%

echo Created new draft at %file_path%