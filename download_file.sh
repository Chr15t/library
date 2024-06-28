#!/bin/bash

# Vérifier que le fichier CSV est fourni en argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

CSV_FILE=$1

# Vérifier que le fichier CSV existe
if [ ! -f "$CSV_FILE" ]; then
    echo "Le fichier CSV \"$CSV_FILE\" n'existe pas."
    exit 1
fi

# Créer le répertoire de téléchargement s'il n'existe pas
DOWNLOAD_DIR="downloads"
mkdir -p "$DOWNLOAD_DIR"

# Lire le fichier CSV et préparer les commandes pour aria2c
tail -n +2 "$CSV_FILE" | cut -d, -f3 | while read -r url; do
    # Extraire le nom de fichier à partir de l'URL
    filename=$(basename "$url")
    
    # Chemin de sauvegarde local
    save_path="$DOWNLOAD_DIR/$filename"
    
    # Vérifier si le fichier existe déjà
    if [ -f "$save_path" ]; then
        echo "Le fichier \"$filename\" existe déjà."
    else
        echo "Téléchargement de \"$filename\"..."
        aria2c -x 16 -s 16 -d "$DOWNLOAD_DIR" "$url"
    fi
done

echo "Téléchargements terminés."
