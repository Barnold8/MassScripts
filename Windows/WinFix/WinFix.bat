@echo off

goto start

:check_Permissions
    echo Administrative permissions required for certain health checks. Detecting permissions...
    echo ---------------------------------------------------------------------------------------
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        set /p IGNORE=Press enter to continue
        cls
        goto proceed
    ) else (
        echo Failure: Current permissions inadequate.
        echo If you want to have all health checks run, please close this script and run it as administrator
        set /p IGNORE=Press enter to continue
        cls
        goto proceed
    )

:start

echo Gathering system information

echo CPU
echo ---
wmic cpu get name, status

echo GPU
echo ------
wmic path win32_videocontroller get name, status

echo Drives
echo ------
wmic diskdrive get model,status

echo Memory
echo ------
wmic memorychip get capacity, speed, totalphysicalmemory

echo BIOS
echo ----
wmic bios get manufacturer, smbiosbiosversion

set /p IGNORE=Press enter to continue with the health check
cls

goto check_Permissions

:proceed

echo Running CheckHealth...
echo ---------------------
DISM /Online /Cleanup-Image /CheckHealth
set /p IGNORE=Press enter to continue
cls

echo Running ScanHealth...
echo ---------------------
DISM /Online /Cleanup-Image /ScanHealth
set /p IGNORE=Press enter to continue
cls

echo Running RestoreHealth...
echo ------------------------
DISM /Online /Cleanup-Image /RestoreHealth
cls

echo Running Check disk...
echo ---------------------
chkdsk
cls

echo Running MemCheck...
echo -------------------

echo This will be the last step for checking overall system health. Click the restart option and let it run. If an issue is found, you will know when the system is booted up again.
set /p IGNORE=Press enter to continue
mdsched
cls


