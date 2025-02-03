#!/bin/bash

# Configuration des chemins de déploiement
webapps="/opt/tomcat/webapps"
tempApps="./target/build-file"
tempFolder="/home/zaphkiel/Documents/project/TEMP/aeroport"
SRC_NAME="./src"
APP_NAME="aeroport"
WEBINF="$tempFolder/WEB-INF"
LIB="./lib"
WEB="./web"

# Copie des librairies et des objets web dans le fichier temporaire
echo "copie"
mkdir -p "$tempFolder/WEB-INF"
mkdir -p "./TEMPCLASS"
cp -r "$LIB" "$tempFolder/WEB-INF"
cp -r "./web.xml" "$tempFolder/WEB-INF/web.xml"
cp -r "$WEB"/* "$tempFolder"
cp -r "config" "$WEBINF/classes"


echo "Compilation des classes vers le dossier temporaire"
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/admin/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/aeroport/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/aeroport/avion/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/aeroport/reservation/utils/"*.java
cp -r "$SRC_NAME/aeroport/reservation/"*.java "./TEMPCLASS"
cp -r "$SRC_NAME/aeroport/vol/"*.java "./TEMPCLASS"
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "./TEMPCLASS/"*.java
rmdir "./TEMPCLASS"
# javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/aeroport/vol/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/admin/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/controller/util/"*.java
javac -parameters -cp "$LIB/*:$WEBINF/classes" -d "$WEBINF/classes" "$SRC_NAME/controller/"*.java

echo "Déplacement vers le dossier temporaire"
cd "$tempFolder" || exit

echo "Conversion du projet en .war"
jar -cvf "$webapps/$APP_NAME.war" . .

echo "Retour au répertoire précédent"
cd .. || exit   

# Suppression du dossier temporaire


echo "Déploiement terminé"

