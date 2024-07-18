@echo off

REM Define variables
set repo_path=%cd%
set modified_folder=%repo_path%\modified_folder
set report_folder=%repo_path%\reports
set version1=version-1
set diff_function=%repo_path%\diff.m

REM Get list of modified .m files
for /F "tokens=*" %%A in ('git diff --name-only HEAD^ HEAD -- %modified_folder%\*.m') do (
    set modified_file=%%A

    REM Checkout the previous version of the file
    git checkout %version1% -- !modified_file!

    REM Run MATLAB diff function and generate the report
    matlab -batch "diff_report = diff('!modified_file!', fullfile('%modified_folder%', '!modified_file!')); save(fullfile('%report_folder%', ['report_' strrep('!modified_file!', '\', '_') '.mat']), 'diff_report'); exit;"

    REM Restore the modified file to its current state
    git checkout HEAD -- !modified_file!
)

REM Add and commit the generated reports
git add %report_folder%/*
git commit -m "Add diff reports for modified .m files"
