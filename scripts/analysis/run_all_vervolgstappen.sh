#!/bin/bash

# Script om alle vervolgstappen uit te voeren
# Gebruik: bash run_all_vervolgstappen.sh

BASE_DIR="/home/thijs/Downloads/Bank apps"

echo "=========================================="
echo "Vervolgstappen - Bank Apps Analyse"
echo "=========================================="
echo "Starttijd: $(date)"
echo ""

# Maak log directory aan
mkdir -p "$BASE_DIR/logs"

# ============================================
# Prioriteit 1: Contextverificatie
# ============================================
echo "=========================================="
echo "Prioriteit 1: Contextverificatie"
echo "=========================================="
echo ""

# Knab
echo "🔍 Knab - Play Integrity"
python3 "$BASE_DIR/dex_locate.py" extracted/knab/app play.core.integrity bvm > "$BASE_DIR/logs/context_knab_playintegrity.log" 2>&1
echo "✅ Opgeslagen in: logs/context_knab_playintegrity.log"
echo ""

echo "🔍 Knab - SafetyNet"
python3 "$BASE_DIR/dex_locate.py" extracted/knab/app safetynet bvm > "$BASE_DIR/logs/context_knab_safetynet.log" 2>&1
echo "✅ Opgeslagen in: logs/context_knab_safetynet.log"
echo ""

# Revolut
echo "🔍 Revolut - Play Integrity"
python3 "$BASE_DIR/dex_locate.py" extracted/revolut/app_full play.core.integrity revolut > "$BASE_DIR/logs/context_revolut_playintegrity.log" 2>&1
echo "✅ Opgeslagen in: logs/context_revolut_playintegrity.log"
echo ""

echo "🔍 Revolut - SafetyNet"
python3 "$BASE_DIR/dex_locate.py" extracted/revolut/app_full safetynet revolut > "$BASE_DIR/logs/context_revolut_safetynet.log" 2>&1
echo "✅ Opgeslagen in: logs/context_revolut_safetynet.log"
echo ""

# Trade Republic
echo "🔍 Trade Republic - Play Integrity"
python3 "$BASE_DIR/dex_locate.py" extracted/trade_republic/app play.core.integrity traderepublic > "$BASE_DIR/logs/context_trade_playintegrity.log" 2>&1
echo "✅ Opgeslagen in: logs/context_trade_playintegrity.log"
echo ""

echo "🔍 Trade Republic - Hardware Attestation"
python3 "$BASE_DIR/dex_locate.py" extracted/trade_republic/app setAttestationChallenge traderepublic > "$BASE_DIR/logs/context_trade_hardware.log" 2>&1
echo "✅ Opgeslagen in: logs/context_trade_hardware.log"
echo ""

echo "✅ Prioriteit 1: Contextverificatie VOLTOOID"
echo ""

# ============================================
# Prioriteit 2: Native Library Scan
# ============================================
echo "=========================================="
echo "Prioriteit 2: Native Library Scan"
echo "=========================================="
echo ""

for bank in sns regio ing rabobank knab revolut trade_republic abnamro; do
    echo "🔍 Native scan: $bank"
    python3 "$BASE_DIR/native_scan.py" "extracted/$bank/libs/lib/arm64-v8a/lib/arm64-v8a/" > "$BASE_DIR/logs/native_scan_${bank}.log" 2>&1
    echo "✅ Opgeslagen in: logs/native_scan_${bank}.log"
    echo ""
done

echo "✅ Prioriteit 2: Native Library Scan VOLTOOID"
echo ""

# ============================================
# Prioriteit 3: Dependency Metadata Check
# ============================================
echo "=========================================="
echo "Prioriteit 3: Dependency Metadata Check"
echo "=========================================="
echo ""

for bank in sns regio ing rabobank knab revolut trade_republic abnamro; do
    echo "🔍 Dependencies: $bank"
    ls -1 "extracted/$bank/app/*.properties" 2>/dev/null | grep -iE "(integrity|safetynet|fido|keystore|sqlcipher)" > "$BASE_DIR/logs/dependencies_${bank}.txt" 2>&1
    echo "✅ Opgeslagen in: logs/dependencies_${bank}.txt"
    echo ""
done

echo "✅ Prioriteit 3: Dependency Metadata Check VOLTOOID"
echo ""

# ============================================
# Samenvatting
# ============================================
echo "=========================================="
echo "Alle Vervolgstappen VOLTOOID"
echo "=========================================="
echo ""
echo "Logbestanden opgeslagen in: $BASE_DIR/logs/"
echo ""
echo "Volgende stap: Definitieve classificatie en rapportage"
echo "Zie: VERVOLGSTAPPEN.md voor instructies"
echo ""
echo "Eindtijd: $(date)"
