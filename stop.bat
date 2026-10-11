@echo off
setlocal enabledelayedexpansion
echo Stopping Apache Tomcat...

if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot"
    ) else if exist "C:\Program Files\Java\jdk-17*" (
        for /d %%i in ("C:\Program Files\Java\jdk-17*") do set "JAVA_HOME=%%i"
    )
)
set "JRE_HOME=%JAVA_HOME%"

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

if not "%CATALINA_HOME%"=="" (
    set "CATALINA_BASE=%CATALINA_HOME%"
    call "%CATALINA_HOME%\bin\shutdown.bat"
    echo Tomcat stopped.
) else (
    echo [NOTE] CATALINA_HOME is not set.
)
pause
