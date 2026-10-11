@echo off
setlocal enabledelayedexpansion
echo ========================================================
echo  Digital Student Grievance and Feedback Portal
echo ========================================================

:: 1. Detect or set JAVA_HOME
if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot"
    ) else if exist "C:\Program Files\Java\jdk-17*" (
        for /d %%i in ("C:\Program Files\Java\jdk-17*") do set "JAVA_HOME=%%i"
    )
)

if "%JAVA_HOME%"=="" (
    echo [ERROR] JAVA_HOME is not set. Please install Java 17 or set JAVA_HOME.
    pause
    exit /b 1
)

set "JRE_HOME=%JAVA_HOME%"
echo Using Java: %JAVA_HOME%

:: 2. Build WAR if not present
if not exist "%~dp0target\student-grievance-portal.war" (
    echo.
    echo Building student-grievance-portal.war...
    if exist "%~dp0mvnw.cmd" (
        call "%~dp0mvnw.cmd" clean package -DskipTests
    ) else (
        call mvn clean package -DskipTests
    )
    if not exist "%~dp0target\student-grievance-portal.war" (
        echo [ERROR] Build failed. Please check Java and Maven.
        pause
        exit /b 1
    )
)

:: 3. Detect or set CATALINA_HOME
if "%CATALINA_HOME%"=="" (
    if exist "C:\Users\ushaa\.gemini\antigravity\scratch\tools\apache-tomcat-10.1.20" (
        set "CATALINA_HOME=C:\Users\ushaa\.gemini\antigravity\scratch\tools\apache-tomcat-10.1.20"
    ) else if exist "%~dp0..\tools\apache-tomcat-10.1.20" (
        set "CATALINA_HOME=%~dp0..\tools\apache-tomcat-10.1.20"
    ) else if exist "C:\apache-tomcat-10*" (
        for /d %%i in ("C:\apache-tomcat-10*") do set "CATALINA_HOME=%%i"
    ) else if exist "C:\Program Files\Apache Software Foundation\Tomcat 10*" (
        for /d %%i in ("C:\Program Files\Apache Software Foundation\Tomcat 10*") do set "CATALINA_HOME=%%i"
    )
)

if "%CATALINA_HOME%"=="" (
    echo.
    echo [NOTE] CATALINA_HOME is not set.
    echo To run on Tomcat:
    echo 1. Install or extract Apache Tomcat 10.1
    echo 2. Set CATALINA_HOME or place Tomcat 10 in C:\apache-tomcat-10.1
    echo.
    echo Or deploy target\student-grievance-portal.war to Tomcat webapps!
    pause
    exit /b 1
)

set "CATALINA_BASE=%CATALINA_HOME%"
echo Using Tomcat: %CATALINA_HOME%

:: 4. Deploy WAR
echo Deploying WAR to Tomcat...
copy "%~dp0target\student-grievance-portal.war" "%CATALINA_HOME%\webapps\" /Y >nul

:: 5. Start Tomcat
echo Starting Apache Tomcat in dedicated window...
start "Tomcat - Student Grievance Portal" "%CATALINA_HOME%\bin\catalina.bat" run

echo Waiting 5 seconds for portal to start...
ping 127.0.0.1 -n 6 >nul

echo Opening Portal in default browser...
start http://localhost:8080/student-grievance-portal/

echo.
echo ========================================================
echo  Portal is running!
echo  Keep the Tomcat console window open while using the app.
echo  To stop Tomcat, run stop.bat or close the Tomcat window.
echo ========================================================
pause
