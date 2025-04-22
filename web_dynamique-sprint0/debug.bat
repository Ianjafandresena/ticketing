@echo off
echo ==========================================
echo    VERIFICATION ANNOTATION GET
==========================================
echo.

set "src_path=D:\ITU\S6\Framework\Framework\avion\web_dynamique-sprint0\src"
set "get_file=%src_path%\mg\itu\annotation\Get.java"

echo ETAPE 1: Verification du fichier Get.java
echo -----------------------------------------
if exist "%get_file%" (
    echo [OK] Get.java existe
    for %%F in ("%get_file%") do echo     Taille: %%~zF octets - Date: %%~tF
    echo.
    echo Contenu du fichier Get.java:
    echo ============================
    type "%get_file%"
    echo ============================
) else (
    echo [ERREUR] Get.java n'existe pas!
    echo.
    echo Fichiers dans le dossier annotation:
    if exist "%src_path%\mg\itu\annotation" (
        dir "%src_path%\mg\itu\annotation\*.java" /b
    )
    goto :create_get
)

echo.
echo ETAPE 2: Test de compilation Get.java seul
echo ------------------------------------------
javac -d "test_get" "%get_file%"
if %errorlevel% equ 0 (
    echo [OK] Get.java se compile correctement
    if exist "test_get\mg\itu\annotation\Get.class" (
        echo [OK] Get.class créé avec succès
    ) else (
        echo [ERREUR] Get.class non créé
    )
    if exist "test_get" rmdir /s /q "test_get"
) else (
    echo [ERREUR] Erreur de compilation de Get.java
)

echo.
echo ETAPE 3: Verification dans bin et sprint_jar
echo --------------------------------------------
if exist "D:\ITU\S6\Framework\Framework\avion\web_dynamique-sprint0\bin\mg\itu\annotation\Get.class" (
    echo [OK] Get.class trouvé dans bin/
) else (
    echo [MANQUANT] Get.class absent de bin/
)

if exist "D:\ITU\S6\Framework\Framework\avion\web_dynamique-sprint0\sprint_jar\classes\mg\itu\annotation\Get.class" (
    echo [OK] Get.class trouvé dans sprint_jar/
) else (
    echo [MANQUANT] Get.class absent de sprint_jar/
)

goto :end

:create_get
echo.
echo ETAPE 4: Creation du fichier Get.java manquant
echo ----------------------------------------------
echo Le fichier Get.java semble manquer. Voulez-vous que je le crée ?
echo Contenu typique d'une annotation @Get:
echo.
echo package mg.itu.annotation;
echo import java.lang.annotation.*;
echo @Target(ElementType.METHOD)
echo @Retention(RetentionPolicy.RUNTIME)
echo public @interface Get {
echo     String value() default "";
echo }
echo.
echo Créer ce fichier ? (O/N)
set /p response=
if /i "%response%"=="O" (
    if not exist "%src_path%\mg\itu\annotation" mkdir "%src_path%\mg\itu\annotation"
    (
        echo package mg.itu.annotation;
        echo import java.lang.annotation.*;
        echo @Target^(ElementType.METHOD^)
        echo @Retention^(RetentionPolicy.RUNTIME^)
        echo public @interface Get {
        echo     String value^(^) default "";
        echo }
    ) > "%get_file%"
    echo [OK] Fichier Get.java créé !
)

:end
echo.
echo ==========================================
pause