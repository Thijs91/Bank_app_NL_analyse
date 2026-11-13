#!/bin/bash

# Script om DEX bestanden van alle banks te extraheren
# Gebruikt dex_extract.py

BASE_DIR="/home/thijs/Downloads/Bank apps"
BANKS=("sns" "regio" "ing" "rabobank" "knab" "revolut" "trade_republic" "abnamro")
# Wero is verkeerd, dus skippen we die

echo "=== DEX Extractie voor Alle Banks ==="
echo "Starttijd: $(date)"
echo ""

for bank in "${BANKS[@]}"; do
    dex_dir="$BASE_DIR/extracted/$bank/app"
    output_dir="$BASE_DIR/extracted/$bank/dex_out"
    
    if [ ! -d "$dex_dir" ]; then
        echo "❌ $bank: DEX directory niet gevonden: $dex_dir"
        continue
    fi
    
    echo "📦 DEX Extractie: $bank"
    echo "   Input: $dex_dir"
    echo "   Output: $output_dir"
    
    mkdir -p "$output_dir"
    python3 "$BASE_DIR/dex_extract.py" "$dex_dir" "$output_dir" 2>&1
    echo ""
done

echo "=== DEX Extractie Voltooid ==="
echo "Eindtijd: $(date)"
