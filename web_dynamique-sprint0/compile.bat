@echo off
setlocal enabledelayedexpansion

set "projet_path=."
set "src=%projet_path%\src"
set "lib=%projet_path%\jar"
set "destination=D:\ITU\S6\Framework\Framework\avion\aeroport\lib"
set "jar_dest=%projet_path%\sprint_jar\classes"

echo ==========================================
echo    BUILD FRAMEWORK SPRINT - VERSION CORRIGEE COMPLETE
echo ==========================================
echo.

echo Creation des repertoires...
if exist ".\sprint_jar" rmdir /s /q ".\sprint_jar"
mkdir ".\sprint_jar\classes"
mkdir ".\sprint_jar\META-INF"

echo.
echo COMPILATION COMPLETE AVEC SOURCEPATH...
echo.

REM Utilisation de -sourcepath pour que javac compile automatiquement toutes les dépendances
echo Compilation de tout le framework via sourcepath...
javac -parameters -cp "%lib%\*" -sourcepath "%src%" -d "%jar_dest%" "%src%\mg\itu\sprint\FrontController.java"

if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo    COMPILATION AVEC SOURCEPATH ECHOUEE
    echo    TENTATIVE DE COMPILATION MANUELLE
    echo ==========================================
    echo.
    
    REM Si la compilation avec sourcepath échoue, on compile manuellement dans l'ordre
    echo ETAPE 1: Compilation des annotations type
    javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\annotation\type\*.java"
    if !errorlevel! neq 0 echo [ERREUR] Compilation des types d'annotation échouée
    
    echo.
    echo ETAPE 2: Compilation des annotations avec diagnostic complet
    echo ----------------------------------------------------------
    echo Fichiers annotation à compiler:
    for %%f in ("%src%\mg\itu\annotation\*.java") do echo   - %%~nxf
    echo.
    
    REM Compilation individuelle de chaque fichier annotation pour diagnostic
    for %%f in ("%src%\mg\itu\annotation\*.java") do (
        echo Compilation de %%~nxf...
        javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%%f"
        if !errorlevel! neq 0 (
            echo [ERREUR] Compilation de %%~nxf échouée
        ) else (
            echo [OK] %%~nxf compilé avec succès
        )
    )
    
    echo.
    echo VERIFICATION des classes annotation compilées:
    if exist "%jar_dest%\mg\itu\annotation" (
        dir "%jar_dest%\mg\itu\annotation\*.class" /b 2>nul
    ) else (
        echo [ATTENTION] Dossier annotation non créé!
    )
    
    echo.
    echo ETAPE 2b: Compilation explicite forcée de Get.java
    echo -------------------------------------------------
    if exist "%src%\mg\itu\annotation\Get.java" (
        echo Compilation forcée de Get.java...
        javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\annotation\Get.java"
        if !errorlevel! neq 0 (
            echo [ERREUR] Compilation forcée de Get.java échouée
        ) else (
            echo [OK] Get.java compilé avec succès (forcé)
            if exist "%jar_dest%\mg\itu\annotation\Get.class" (
                echo [VERIFICATION] Get.class créé avec succès
            ) else (
                echo [ERREUR] Get.class non créé malgré compilation réussie!
            )
        )
    ) else (
        echo [ERREUR] Get.java non trouvé!
    )
    
    echo.
    echo ETAPE 3: Compilation des exceptions
    javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\utils\exception\*.java"
    if !errorlevel! neq 0 echo [ERREUR] Compilation des exceptions échouée
    
    echo.
    echo ETAPE 4: Compilation des utils (sans Scanner)
    for %%f in ("%src%\mg\itu\utils\*.java") do (
        if exist "%%f" (
            if not "%%~nxf"=="Scanner.java" (
                echo Compilation %%~nxf...
                javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%%f"
                if !errorlevel! neq 0 echo [ERREUR] Compilation de %%~nxf échouée
            )
        )
    )
    
    echo.
    echo ETAPE 5: Compilation du Scanner (qui dépend des autres utils)
    javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\utils\Scanner.java"
    if !errorlevel! neq 0 echo [ERREUR] Compilation du Scanner échouée
    
    echo.
    echo ETAPE 6: Compilation finale du FrontController
    javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\sprint\FrontController.java"
    if !errorlevel! neq 0 (
        echo.
        echo ==========================================
        echo    ECHEC CRITIQUE DE COMPILATION
        echo ==========================================
        echo.
        echo Dernière tentative : compilation de tous les fichiers d'un coup
        
        REM Dernière tentative : compiler tous les fichiers Java d'un coup
        dir "%src%\mg\itu\*.java" /s /b > temp_java_files.txt
        javac -parameters -cp "%lib%\*" -d "%jar_dest%" @temp_java_files.txt
        del temp_java_files.txt
        
        if !errorlevel! neq 0 (
            echo ECHEC DEFINITIF DE LA COMPILATION
            pause
            exit /b 1
        )
    )
)

echo.
echo ==========================================
echo    VERIFICATION DETAILLEE POST-COMPILATION
echo ==========================================

REM Vérification spéciale pour Get.class
echo.
echo VERIFICATION SPECIALE POUR Get.class:
echo ------------------------------------
if exist "%jar_dest%\mg\itu\annotation\Get.class" (
    echo [OK] Get.class trouvé dans sprint_jar/classes/
    for %%F in ("%jar_dest%\mg\itu\annotation\Get.class") do echo     Taille: %%~zF octets, Date: %%~tF
) else (
    echo [PROBLEME] Get.class manquant dans sprint_jar/classes/!
    echo Tentative de recompilation d'urgence...
    javac -parameters -cp "%lib%\*;%jar_dest%" -d "%jar_dest%" "%src%\mg\itu\annotation\Get.java"
    if !errorlevel! neq 0 (
        echo [ECHEC] Impossible de compiler Get.java
    ) else (
        if exist "%jar_dest%\mg\itu\annotation\Get.class" (
            echo [SUCCES] Get.class créé par recompilation d'urgence
        ) else (
            echo [ECHEC] Get.class toujours manquant après recompilation
        )
    )
)

echo.
echo VERIFICATION DES CLASSES PRINCIPALES:
echo ----------------------------------

REM Vérification des classes principales
set "classes_ok=0"

if exist "%jar_dest%\mg\itu\sprint\FrontController.class" (
    echo [OK] FrontController.class créé
    for %%F in ("%jar_dest%\mg\itu\sprint\FrontController.class") do echo     Taille: %%~zF octets
    set /a classes_ok+=1
) else (
    echo [ERREUR] FrontController.class manquant!
)

if exist "%jar_dest%\mg\itu\utils\Scanner.class" (
    echo [OK] Scanner.class créé
    set /a classes_ok+=1
) else (
    echo [ERREUR] Scanner.class manquant!
)

if exist "%jar_dest%\mg\itu\utils\Mapping.class" (
    echo [OK] Mapping.class créé
    set /a classes_ok+=1
) else (
    echo [ERREUR] Mapping.class manquant!
)

if exist "%jar_dest%\mg\itu\utils\ModelView.class" (
    echo [OK] ModelView.class créé
    set /a classes_ok+=1
) else (
    echo [ERREUR] ModelView.class manquant!
)

if %classes_ok% lss 3 (
    echo.
    echo [ERREUR CRITIQUE] Classes principales manquantes!
    echo Compilation incomplète - JAR ne sera pas fonctionnel
    pause
    exit /b 1
)

echo.
echo VERIFICATION COMPLETE DES ANNOTATIONS:
echo -----------------------------------
if exist "%jar_dest%\mg\itu\annotation" (
    echo Classes annotation compilées:
    dir "%jar_dest%\mg\itu\annotation\*.class" /b 2>nul
    echo.
    echo Détail des annotations:
    for %%f in ("%jar_dest%\mg\itu\annotation\*.class") do (
        echo   [OK] %%~nxf - Taille: %%~zf octets
    )
) else (
    echo [ERREUR] Aucune classe annotation trouvée!
)

echo.
echo Décompte total des classes:
dir "%jar_dest%" /s /b | find ".class" | find /c ".class" > temp_count.txt
set /p class_count=<temp_count.txt
del temp_count.txt
echo Total: %class_count% classes compilées

if %class_count% lss 10 (
    echo [ATTENTION] Peu de classes compilées - vérifiez le résultat
)

echo.
echo.
echo Copie des classes vers le dossier bin...
if not exist "bin" mkdir "bin"
xcopy "%jar_dest%\mg" "bin\mg" /E /I /Y /Q
if %errorlevel% equ 0 (
    echo [OK] Classes copiees vers bin/
    
    REM Vérification spéciale de Get.class dans bin
    if exist "bin\mg\itu\annotation\Get.class" (
        echo [OK] Get.class aussi présent dans bin/
    ) else (
        echo [ATTENTION] Get.class absent de bin/ malgré la copie
    )
) else (
    echo [ATTENTION] Echec de la copie vers bin (non critique)
)

echo.
echo Creation du fichier manifest...
echo Manifest-Version: 1.0 > sprint_jar\META-INF\MANIFEST.MF
echo. >> sprint_jar\META-INF\MANIFEST.MF

echo.
echo Creation du fichier JAR...
if exist "sprint.jar" del "sprint.jar"
jar cvf sprint.jar -C .\sprint_jar\classes .

if %errorlevel% neq 0 (
    echo ERREUR: Echec de la creation du JAR!
    pause
    exit /b 1
)

echo.
echo Copie du jar vers la destination...
if not exist "%destination%" mkdir "%destination%"
copy "sprint.jar" "%destination%"

if %errorlevel% neq 0 (
    echo ERREUR: Echec de la copie du JAR!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo    BUILD TERMINE AVEC SUCCES!
echo ==========================================
echo.
echo JAR cree: sprint.jar
echo Copie vers: %destination%\sprint.jar
echo Classes aussi disponibles dans: bin\mg\itu\
echo.

REM Vérification finale du contenu du JAR
echo ==========================================
echo    VERIFICATION FINALE DU JAR
echo ==========================================
echo.
echo Classes principales dans le JAR:
jar tf sprint.jar | findstr "FrontController.class" && echo [OK] FrontController dans le JAR || echo [PROBLEME] FrontController manquant dans JAR
jar tf sprint.jar | findstr "Scanner.class" && echo [OK] Scanner dans le JAR || echo [PROBLEME] Scanner manquant dans JAR
jar tf sprint.jar | findstr "Mapping.class" && echo [OK] Mapping dans le JAR || echo [PROBLEME] Mapping manquant dans JAR

echo.
echo VERIFICATION SPECIALE Get.class dans le JAR:
jar tf sprint.jar | findstr "Get.class" && echo [OK] Get.class présent dans le JAR || echo [PROBLEME] Get.class manquant dans JAR

echo.
echo Toutes les annotations dans le JAR:
jar tf sprint.jar | findstr "mg/itu/annotation/"

jar tf sprint.jar | find /c ".class" > temp_jar_count.txt
set /p jar_class_count=<temp_jar_count.txt
del temp_jar_count.txt
echo.
echo Classes dans le JAR: %jar_class_count%

echo.
echo Liste complète des classes principales dans le JAR:
jar tf sprint.jar | findstr "mg/itu/" | findstr ".class"

echo.
echo ==========================================
echo    RESUME FINAL
echo ==========================================
if exist "%jar_dest%\mg\itu\annotation\Get.class" (
    echo [SUCCES] Get.class compilé et présent
) else (
    echo [ECHEC] Get.class toujours manquant!
)

jar tf sprint.jar | findstr "Get.class" >nul
if %errorlevel% equ 0 (
    echo [SUCCES] Get.class inclus dans le JAR final
) else (
    echo [ECHEC] Get.class absent du JAR final!
)

echo.
pause