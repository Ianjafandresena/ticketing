@echo off
setlocal

set "webapps=C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps"
set "tempFolder=D:\Framework\avion\aeroport"
set "SRC_NAME=.\src"
set "APP_NAME=aeroport"
set "WEBINF=%tempFolder%\WEB-INF"
set "LIB=.\lib"
set "WEB=.\web"

set "CURRENT_DIR=%CD%"

echo Copie des librairies et objets web dans le dossier temporaire
mkdir "%WEBINF%" 2>nul
mkdir "%WEBINF%\classes" 2>nul

xcopy /E /I /Y "%LIB%" "%WEBINF%\lib"
copy ".\web.xml" "%WEBINF%\web.xml"
xcopy /E /I /Y "%WEB%\*" "%tempFolder%\"

mkdir "%WEBINF%\classes\config" 2>nul
copy "src\config\app.conf" "%WEBINF%\classes\config\app.conf"


echo Compilation des classes vers le dossier temporaire
dir /b /s "%SRC_NAME%\*.java" > sources.txt
set "CLASSPATH=%CURRENT_DIR%\%LIB%\*;%WEBINF%\classes"

echo Compilation avec classpath: %CLASSPATH%
javac -parameters -cp "%CLASSPATH%" -d "%WEBINF%\classes" @sources.txt

if %ERRORLEVEL% neq 0 (
    echo ERREUR: Échec de la compilation !
    echo Vérifiez les erreurs ci-dessus
    del sources.txt 2>nul
    pause
    exit /b 1
)

echo Compilation réussie !

echo Déplacement vers le dossier temporaire
cd /D "%tempFolder%" || exit /b

echo Conversion du projet en .war
jar -cvf "%webapps%\%APP_NAME%.war" *

echo Retour au répertoire précédent
cd /D "%CURRENT_DIR%" || exit /b

echo Déploiement terminé avec succès !
del sources.txt 2>nul
endlocal
pause