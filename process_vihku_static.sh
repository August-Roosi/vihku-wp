#!/bin/bash

# Process Vihku Static Build Script
# This script automates the process of:
# 1. Extracting a vihku_staatiline_X.zip file
# 2. Running the fix_paths.sh script
# 3. Adding all files to git
# 4. Committing with Estonian message
# 5. Pushing to remote repository

echo "🚀 Vihku staatiline töötluse skript"
echo "=================================="

# Check if folder number is provided as argument
if [ $# -eq 0 ]; then
    # Prompt for folder number if not provided
    read -p "Sisesta kausta number (nt. 5 kausta vihku_staatiline_5 jaoks): " FOLDER_NUM
else
    FOLDER_NUM=$1
fi

# Validate input
if ! [[ "$FOLDER_NUM" =~ ^[0-9]+$ ]]; then
    echo "❌ Viga: Palun sisesta kehtiv number"
    exit 1
fi

# Define variables
ZIP_FILE="vihku_staatiline_${FOLDER_NUM}.zip"
FOLDER_NAME="vihku_staatiline_${FOLDER_NUM}"

echo ""
echo "📂 Töötlen: $ZIP_FILE"
echo "📁 Sihtkausta: $FOLDER_NAME"

# Check if zip file exists
if [ ! -f "$ZIP_FILE" ]; then
    echo "❌ Viga: Fail $ZIP_FILE ei leitud!"
    exit 1
fi

# Check if fix_paths.sh exists
if [ ! -f "fix_paths.sh" ]; then
    echo "❌ Viga: fix_paths.sh skript ei leitud!"
    exit 1
fi

echo ""
echo "📦 Lahendan ZIP faili..."

# Extract zip file to folder (overwrite if exists)
if ! unzip -o "$ZIP_FILE" -d "$FOLDER_NAME/"; then
    echo "❌ Viga ZIP faili lahendamisel!"
    exit 1
fi

echo "✅ ZIP fail lahendatud kausta $FOLDER_NAME"

echo ""
echo "🔧 Jooksutan tee parandamise skripti..."

# Run fix_paths.sh in the extracted folder
cd "$FOLDER_NAME" || {
    echo "❌ Viga: Ei saanud kausta $FOLDER_NAME siseneda!"
    exit 1
}

if ! bash ../fix_paths.sh; then
    echo "❌ Viga tee parandamise skripti jooksutamisel!"
    cd ..
    exit 1
fi

echo "✅ Teed parandatud edukalt"

# Go back to main directory
cd ..

echo ""
echo "📝 Lisan failid Git'i..."

# Add all files to git
if ! git add .; then
    echo "❌ Viga failide Git'i lisamisel!"
    exit 1
fi

echo "✅ Failid lisatud Git'i"

echo ""
echo "💾 Teen commit'i..."

# Commit with Estonian message
COMMIT_MSG="Lisasin ${FOLDER_NAME} koos parandatud teedega"
if ! git commit -m "$COMMIT_MSG"; then
    echo "❌ Viga commit'i tegemisel!"
    exit 1
fi

echo "✅ Commit tehtud: $COMMIT_MSG"

echo ""
echo "🚀 Lükkan muudatused remote'i..."

# Push to remote
if ! git push; then
    echo "❌ Viga push'i tegemisel!"
    exit 1
fi

echo "✅ Muudatused edukalt pushed!"

echo ""
echo "🎉 Kõik valmis!"
echo "📊 Töödeldud kaust: $FOLDER_NAME"
echo "🔗 Muudatused on Git'is ja remote'is"
echo "💡 Saad nüüd vaadata index.html faili lokaalses kaustas või GitHub Pages'is"
