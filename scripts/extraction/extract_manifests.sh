#!/bin/bash

# Script om manifests van alle banks te extraheren
# Gebruikt axml_min.py

BASE_DIR="/home/thijs/Downloads/Bank apps"
BANKS=("sns" "regio" "ing" "rabobank" "knab" "revolut" "trade_republic" "abnamro" "wero")

echo "=== Manifest Extractie voor Alle Banks ==="
echo "Starttijd: $(date)"
echo ""

for bank in "${BANKS[@]}"; do
    manifest_path="$BASE_DIR/extracted/$bank/app/AndroidManifest.xml"
    
    if [ ! -f "$manifest_path" ]; then
        echo "❌ $bank: Manifest niet gevonden: $manifest_path"
        continue
    fi
    
    echo "📄 Extraheren: $bank"
    echo "   Pad: $manifest_path"
    python3 "$BASE_DIR/axml_min.py" "$manifest_path" 2>&1
    echo ""
done

echo "=== Manifest Extractie Voltooid ==="
echo "Eindtijd: $(date)"
