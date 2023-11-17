@echo off

rem Batch script that moves a draft file from the drafts folder to the one for
rem posts. It uses a relative path in order to do this.
rem
rem Usage: \.draft_publish.bat [FILENAME]
file_name=%1
drafts_folder=_drafts
posts_folder=_posts
source=%drafts_folder%/%file_name%
destination=%posts_folder%/%file_name%
mv %source% %destination%