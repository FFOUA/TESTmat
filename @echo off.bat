@echo off
echo Waiting for report to be generated…
 
set MATLAB_EXEC=C:\Program Files\MATLAB\R2021a\bin\matlab.exe
set MATLAB_SCRIPT=file_comparison_driver
set MATLAB_PATH=C:\Users\VC05DTE\Desktop\20_hil_std\m_functions\Simulink_Difftool
 
 
# Get the list of changed files
changed_files=$(git diff --name-only HEAD~1 HEAD)
 
# Check each changed file
for file in $changed_files
do(
    # If the file is an .mdl file
    if [[ $file == *.mdl ]]
    then
        # Get the full path of the modified file
        modified_module_path=$(pwd)/$file
 
        # Get the full path of the base file in the repository
        base_module_path=$(git rev-parse --show-toplevel)/$file
		%MATLAB_EXEC% -wait -r "addpath('%MATLAB_PATH%'); %MATLAB_SCRIPT%('%modified_module_path%', '%base_module_path%'); exit;"
	)
 

:waitloop
if exist "C:\Users\VC05DTE\Desktop\20_hil_std\m_functions\Simulink_Difftool\comparison_report.pdf" (
    echo Report generated.
    goto commit
) else (
    timeout /t 5 >nul
    goto waitloop
)
:commit
echo Staging and committing the report...
:: Stage the report for commit
git add C:\Users\VC05DTE\Desktop\20_hil_std\m_functions\Simulink_Difftool\comparison_report.pdf
:: Commit the report
git commit -m "Automated commit: Added generated report"
echo Post-commit hook completed.