@echo off

rem Batch script that commits a push to the current Git branch quickly.
rem Usage: .\quicommit.bat [COMMENT]
rem
rem NOTE: This used to have a major bug in it where "$0" was used, like in bash.
rem       if you're looking at the repo this comes from in the future and are
rem       wondering why there are two days of commits like this, that's why.
git add -A
git commit -m %1
git push