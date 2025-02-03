@echo off
setlocal enabledelayedexpansion

@REM Configuration des chemins de déploiement
set "SRC_NAME=.\src\mg\itu"
set "DESTINATION=D:\ITU\S6\Framework\Framework\avion\aeroport\lib"
set "LIB=.\jar"
set "JAR_DEST=.\sprint_jar\classes"

mkdir ".\sprint_jar\classes"
mkdir ".\sprint_jar\META-INF\"
type nul > ".\sprint_jar\META-INF/MANIFEST.MF"
type nul > "sprint.jar"

@REM Compilation des classes
echo Compilation
xcopy "%SRC_NAME%\annotation\type\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\annotation\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\utils\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\utils\exception\*.java" ".\TEMPCLASS\" /Y
xcopy "%SRC_NAME%\sprint\*.java" ".\TEMPCLASS\" /Y

dir /S /B ".\TEMPCLASS\*.java" > sources.txt

javac -parameters -cp "%LIB%\*;%JAR_DEST%" -d "%JAR_DEST%" @sources.txt
rmdir /S /Q ".\TEMPCLASS"

@REM Creation d'un fichier manifest
echo "Manifest-Version: 1.0" > sprint_jar/META-INF/MANIFEST.MF
echo "Main-Class: mg.itu.sprint" >> sprint_jar/META-INF/MANIFEST.MF

@REM Creation du fichier JAR
echo Creation du jar
cd sprint_jar\classes
jar cvf ..\..\sprint.jar .
cd ..\..\

echo copie du jar
copy /Y "sprint.jar" "%DESTINATION%"

pause
