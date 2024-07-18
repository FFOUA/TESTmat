@echo off
echo Waiting for report to be generated…
 
set MATLAB_EXEC=C:\Program Files\MATLAB\R2021a\bin\matlab.exe
set MATLAB_SCRIPT=file_comparison_driver
set MATLAB_PATH=C:\Users\VC05DTE\Desktop\20_hil_std\m_functions\Simulink_Difftool
 
 
REM Define the paths to the old and new models (replace with actual paths)
set MODEL1=C:\Users\VC05DTE\Desktop\20_hil_std\Test_ModifSimulink\Test_diff.mdl
set MODEL2=C:\Users\VC05DTE\Desktop\20_hil_std\Test_ModifSimulink\Test_diff_modified.mdl
 
REM Run MATLAB comparison script
 
%MATLAB_EXEC% -wait -r "addpath('%MATLAB_PATH%'); %MATLAB_SCRIPT%('%MODEL1%', '%MODEL2%'); exit;"
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