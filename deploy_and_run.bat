@echo off
setlocal

:: --- Configuration ---
set "PROJECT_ROOT=D:\Vacation_Projects\NeuroSyncBCI"
set "WAR_FILE=D:\Vacation_Projects\NeuroSyncBCI\target\NeuroSyncBCI.war"
set "TOMCAT_WEBAPPS=D:\codes\apache-tomcat-10.1.55-windows-x64\apache-tomcat-10.1.55\webapps\"
set "TOMCAT_BIN=D:\codes\apache-tomcat-10.1.55-windows-x64\apache-tomcat-10.1.55\bin\"
set "JAVA_HOME=C:\Program Files\Java\latest\jdk-25"
set "MAVEN_HOME=D:\codes\apache-maven-3.9.16-bin\apache-maven-3.9.16"

echo [1/4] Setting up environment...
set "PATH=%JAVA_HOME%\bin;%MAVEN_HOME%\bin;%PATH%"

echo [2/4] Building project with Maven...
cd /d "%PROJECT_ROOT%"
call mvn clean package
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Maven build failed.
    pause
    exit /b %ERRORLEVEL%
)

echo [3/4] Deploying WAR to Tomcat...
copy /y "%WAR_FILE%" "%TOMCAT_WEBAPPS%"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to copy WAR file.
    pause
    exit /b %ERRORLEVEL%
)

echo [4/4] Starting Tomcat Server...
cd /d "%TOMCAT_BIN%"
start "" startup.bat

echo.
echo ======================================================
echo  NeuroSyncBCI Deployment Complete
echo  Access at: http://localhost:8080/NeuroSyncBCI/
echo ======================================================
echo.

pause
