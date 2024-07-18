@echo off
echo Waiting for report to be generated…

set MATLAB_EXEC=C:\Program Files\MATLAB\R2021a\bin\matlab.exe
set MATLAB_SCRIPT=file_comparison_driver
set MATLAB_PATH=C:\Users\VC05DTE\Desktop\20_hil_std\m_functions\Simulink_Difftool

REM Define the paths to the modified model
set MODIFIED_MODEL=C:\Users\VC05DTE\Desktop\20_hil_std\Test_ModifSimulink\Test_diff_modified.mdl

REM Define a temporary directory to checkout the old version of the model
set TEMP_DIR=C:\Users\VC05DTE\Desktop\20_hil_std\Test_ModifSimulink\temp
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Navigate to the directory where the models are stored
pushd C:\Users\VC05DTE\Desktop\20_hil_std\Test_ModifSimulink

REM Checkout the previous version of the model into the temporary directory
git show HEAD~1:Test_diff.mdl > %TEMP_DIR%\Test_diff.mdl

REM Define the path to the checked out previous version
set VERSION_1_MODEL=%TEMP_DIR%\Test_diff.mdl

REM Run MATLAB comparison script
%MATLAB_EXEC% -wait -r "addpath('%MATLAB_PATH%'); %MATLAB_SCRIPT%('%MODIFIED_MODEL%', '%VERSION_1_MODEL%'); exit;"

REM Clean up temporary files
del %TEMP_DIR%\Test_diff.mdl
rmdir %TEMP_DIR%

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

REM Navigate back to the original directory
popd
