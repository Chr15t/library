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

# Fonction pour télécharger un fichier
download_file() {
    local url=$1
    local save_dir=$2
    local filename=$(basename "$url")
    local save_path="$save_dir/$filename"

    # Vérifier si le fichier existe déjà
    if [ -f "$save_path" ]; then
        echo "Le fichier \"$filename\" existe déjà."
    else
        # Télécharger le fichier
        echo "Téléchargement de \"$filename\"..."
        wget -O "$save_path" "$url"
        if [ $? -eq 0 ]; then
            echo "Téléchargement réussi : \"$filename\""
        else
            echo "Erreur lors du téléchargement : \"$filename\""
        fi
    fi
}

export -f download_file

# Lire le fichier CSV et télécharger chaque fichier en parallèle
tail -n +2 "$CSV_FILE" | cut -d, -f3 | xargs -n 1 -P 8 -I {} bash -c 'download_file "$@"' _ {} "$DOWNLOAD_DIR"

echo "Téléchargements terminés."
