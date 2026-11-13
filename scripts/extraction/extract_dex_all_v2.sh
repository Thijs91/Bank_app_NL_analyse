#!/bin/bash

# Verbeterd script om DEX bestanden van alle banks te extraheren
# Controleert op app_full directory (voor splits) en app directory

BASE_DIR="/home/thijs/Downloads/Bank apps"
BANKS=("sns" "regio" "ing" "rabobank" "knab" "revolut" "trade_republic" "abnamro")
# Wero is verkeerd, dus skippen we die

echo "=== DEX Extractie v2 voor Alle Banks ==="
echo "Starttijd: $(date)"
echo ""

for bank in "${BANKS[@]}"; do
    # Check of app_full directory bestaat (met splits)
    if [ -d "$BASE_DIR/extracted/$bank/app_full" ]; then
        dex_dir="$BASE_DIR/extracted/$bank/app_full"
    # Check of app directory bestaat
    elif [ -d "$BASE_DIR/extracted/$bank/app" ]; then
        dex_dir="$BASE_DIR/extracted/$bank/app"
    else
        echo "❌ $bank: Geen app of app_full directory gevonden"
        continue
    fi
    
    output_dir="$BASE_DIR/extracted/$bank/dex_out"
    
    echo "📦 DEX Extractie: $bank"
    echo "   Input: $dex_dir"
    echo "   Output: $output_dir"
    
    mkdir -p "$output_dir"
    python3 "$BASE_DIR/dex_extract.py" "$dex_dir" "$output_dir" 2>&1
    echo ""
done

echo "=== DEX Extractie Voltooid ==="
echo "Eindtijd: $(date)"
