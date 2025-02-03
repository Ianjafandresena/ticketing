@echo off
echo ==========================================
echo    DIAGNOSTIC PROBLEME AEROPORT
echo ==========================================
echo.

set "aeroport_lib=D:\Framework\avion\aeroport\lib
set "sprint_jar=%aeroport_lib%\sprint.jar"

echo VERIFICATION 1: Existence du JAR
echo ---------------------------------
if exist "%sprint_jar%" (
    echo [OK] sprint.jar existe
    for %%F in ("%sprint_jar%") do echo     Taille: %%~zF octets - Date: %%~tF
) else (
    echo [ERREUR] sprint.jar n'existe pas dans %aeroport_lib%
    echo Contenu du dossier lib:
    if exist "%aeroport_lib%" (
        dir "%aeroport_lib%" /b
    ) else (
        echo     Le dossier lib n'existe pas!
    )
    goto :end
)

echo.
echo VERIFICATION 2: Contenu du JAR - Annotation Get
echo ----------------------------------------------
jar tf "%sprint_jar%" | findstr "Get.class"
if %errorlevel% equ 0 (
    echo [OK] Annotation Get trouvee dans le JAR
) else (
    echo [ERREUR] Annotation Get manquante!
)

echo.
echo VERIFICATION 3: Toutes les annotations
echo -------------------------------------
echo Annotations dans le JAR:
jar tf "%sprint_jar%" | findstr "annotation.*\.class"

echo.
echo VERIFICATION 4: Structure complete du JAR
echo ----------------------------------------
echo Structure mg/itu/ dans le JAR:
jar tf "%sprint_jar%" | findstr "^mg/itu/"

echo.
echo VERIFICATION 5: Test classpath
echo -----------------------------
echo Test de compilation d'une classe simple utilisant @Get:
echo.

REM Créer un fichier de test temporaire
echo import mg.itu.annotation.Get; > TestGet.java
echo public class TestGet { >> TestGet.java
echo     @Get >> TestGet.java
echo     public void test(){} >> TestGet.java
echo } >> TestGet.java

echo Compilation avec le JAR dans le classpath:
javac -cp "%sprint_jar%" TestGet.java

if %errorlevel% equ 0 (
    echo [OK] Test de compilation reussi
    if exist "TestGet.class" del "TestGet.class"
) else (
    echo [ERREUR] Test de compilation echoue
)

if exist "TestGet.java" del "TestGet.java"

echo.
echo VERIFICATION 6: Comparaison des dates
echo ------------------------------------
echo Date du JAR source:
if exist "D:\Framework\avion\web_dynamique-sprint0\sprint.jar" (
    for %%F in ("D:\Framework\avion\web_dynamique-sprint0\sprint.jar") do echo     Source: %%~tF
    for %%F in ("%sprint_jar%") do echo     Destination: %%~tF
) else (
    echo     JAR source introuvable
)

:end
echo.
echo ==========================================
echo    DIAGNOSTIC TERMINE
echo ==========================================
pause