@echo off
setlocal enabledelayedexpansion

:: Configuration des chemins de déploiement
set "webapps=C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps"
set "tempApps=.\target\build-file"
set "tempFolder=D:\Framework\avion\aeroport"
set "SRC_NAME=.\src"
set "APP_NAME=aeroport"
set "WEBINF=%tempFolder%\WEB-INF"
set "LIB=.\lib"
set "WEB=.\web"

:: Copie des librairies et objets web
echo Copie des fichiers...
rmdir "%WEBINF%"
mkdir "%WEBINF%"
mkdir ".\TEMPCLASS"
mkdir ".\TEMPCLASSCONTROLL"
xcopy "%LIB%" "%WEBINF%\lib\" /E /I /Y
copy ".\web.xml" "%WEBINF%\web.xml"
xcopy "%WEB%\*" "%tempFolder%\" /E /I /Y
xcopy "config" "%WEBINF%\classes\config" /E /I /Y

:: Compilation des classes
echo Compilation des classes vers le dossier temporaire...
xcopy "%SRC_NAME%\admin\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\aeroport\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\aeroport\avion\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\aeroport\reservation\utils\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\aeroport\reservation\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\aeroport\vol\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\tools\*.java" ".\TEMPCLASS\"

dir /S /B ".\TEMPCLASS\*.java" > sources.txt

javac -parameters -cp "%LIB%\*;%WEBINF%\classes" -d "%WEBINF%\classes" @sources.txt
rmdir /S /Q ".\TEMPCLASS"

xcopy "%SRC_NAME%\admin\*.java" ".\TEMPCLASSCONTROLL\" /Y
xcopy "%SRC_NAME%\controller\util\*.java" ".\TEMPCLASSCONTROLL\" /Y
xcopy "%SRC_NAME%\controller\*.java" ".\TEMPCLASSCONTROLL\" /Y
xcopy "%SRC_NAME%\controller\api\*.java" ".\TEMPCLASSCONTROLL\" /Y

dir /S /B ".\TEMPCLASSCONTROLL\*.java" > sources.txt

javac -parameters -cp "%LIB%\*;%WEBINF%\classes" -d "%WEBINF%\classes" @sources.txt
rmdir /S /Q ".\TEMPCLASSCONTROLL"

:: Création du fichier WAR
echo Création du fichier WAR...
pushd "%tempFolder%"

jar -cvf "%webapps%\%APP_NAME%.war" *
popd

rmdir /S /Q "%tempFolder%"

echo Déploiement terminé.
pause
