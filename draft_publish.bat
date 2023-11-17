@echo off

rem Batch script that moves a draft file from the drafts folder to the one for
rem posts. It uses a relative path in order to do this.
rem
rem Usage: \.draft_publish.bat [FILENAME]
rem First, find the data necessary to perform the move operation.
set file_name=%1
set drafts_folder=_drafts
set posts_folder=_posts
rem Remember to use "\" for file paths OR YOU'LL HAVE TO COME ALL THE WAY BACK AGAIN
set source=%drafts_folder%\%file_name%
set destination=%posts_folder%\%file_name%
echo %source%
rem Then, actually perform the move and notify the user.
move %source% %destination%
echo Draft %source% published in %destination%
dir %posts_folder%