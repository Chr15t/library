#!/bin/bash

# Vérification du nombre d'arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <fichier_urls>"
    exit 1
fi

# Vérification si le fichier existe
if [ ! -f "$1" ]; then
    echo "Fichier $1 non trouvé."
    exit 1
fi

# Répertoire de téléchargement
download_dir="./downloads"
mkdir -p "$download_dir"

# Boucle pour télécharger chaque URL
while IFS= read -r url; do
    # Extraire le nom du fichier à partir de l'URL
    filename=$(basename "$url")
    filepath="$download_dir/$filename"

    # Télécharger le fichier
    echo "Téléchargement de $url ..."
    wget -q "$url" -O "$filepath"

    if [ $? -eq 0 ]; then
        echo "Téléchargé avec succès: $filename"
    else
        echo "Échec du téléchargement: $filename"
    fi
done < "$1"

echo "Téléchargement terminé."
