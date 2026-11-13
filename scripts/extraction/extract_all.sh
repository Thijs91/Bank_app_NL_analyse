#!/bin/bash

# Script om alle APK's uit te pakken voor analyse
# Gemaakt op: 4 Nov 2026

BASE_DIR="/home/thijs/Downloads/Bank apps"
EXTRACTED_DIR="$BASE_DIR/extracted"

echo "=== APK Extractie Script ==="
echo "Starttijd: $(date)"
echo ""

# Functie om XAPK uit te pakken
extract_xapk() {
    local pkg_name="$1"
    local xapk_file="$2"
    local extract_dir="$EXTRACTED_DIR/$pkg_name"
    
    echo "📦 Pak uit: $pkg_name ($xapk_file)"
    
    # Maak directories aan
    mkdir -p "$extract_dir/app" "$extract_dir/libs/lib/arm64-v8a" "$extract_dir/xapk"
    
    # Pak XAPK bundel uit
    unzip -o "$xapk_file" -d "$extract_dir/xapk" > /dev/null 2>&1
    
    # Vind basis APK
    local base_apk=$(find "$extract_dir/xapk" -maxdepth 1 -name "*.apk" ! -name "config.*" | head -1)
    
    if [ -z "$base_apk" ]; then
        echo "  ❌ Geen basis APK gevonden in $extract_dir/xapk"
        return 1
    fi
    
    # Pak basis APK uit
    unzip -o "$base_apk" -d "$extract_dir/app" > /dev/null 2>&1
    
    # Pak config.arm64_v8a.apk uit voor native libraries
    local config_apk="$extract_dir/xapk/config.arm64_v8a.apk"
    if [ -f "$config_apk" ]; then
        unzip -o "$config_apk" -d "$extract_dir/libs/lib/arm64-v8a" > /dev/null 2>&1
    fi
    
    echo "  ✅ Uitgepakt naar $extract_dir/"
    echo "     - App: $extract_dir/app/"
    echo "     - Libs: $extract_dir/libs/"
    echo ""
}

# Functie om APKM uit te pakken (zip format)
extract_apkm() {
    local pkg_name="$1"
    local apkm_file="$2"
    local extract_dir="$EXTRACTED_DIR/$pkg_name"
    
    echo "📦 Pak uit: $pkg_name ($apkm_file)"
    
    mkdir -p "$extract_dir/app" "$extract_dir/libs/lib/arm64-v8a"
    
    # APKM is eigenlijk een ZIP met APK's
    unzip -o "$apkm_file" -d "$extract_dir/xapk" > /dev/null 2>&1
    
    # Vind basis APK
    local base_apk=$(find "$extract_dir/xapk" -maxdepth 1 -name "*.apk" ! -name "config.*" | head -1)
    
    if [ -z "$base_apk" ]; then
        echo "  ❌ Geen basis APK gevonden in $extract_dir/xapk"
        return 1
    fi
    
    # Pak basis APK uit
    unzip -o "$base_apk" -d "$extract_dir/app" > /dev/null 2>&1
    
    # Pak config.arm64_v8a.apk uit
    local config_apk="$extract_dir/xapk/config.arm64_v8a.apk"
    if [ -f "$config_apk" ]; then
        unzip -o "$config_apk" -d "$extract_dir/libs/lib/arm64-v8a" > /dev/null 2>&1
    fi
    
    echo "  ✅ Uitgepakt naar $extract_dir/"
    echo ""
}

# Functie om APK uit te pakken
extract_apk() {
    local pkg_name="$1"
    local apk_file="$2"
    local extract_dir="$EXTRACTED_DIR/$pkg_name"
    
    echo "📦 Pak uit: $pkg_name ($apk_file)"
    
    mkdir -p "$extract_dir/app" "$extract_dir/libs/lib/arm64-v8a"
    
    # Pak APK uit
    unzip -o "$apk_file" -d "$extract_dir/app" > /dev/null 2>&1
    
    # Controleer of er native libraries in zitten
    if [ -d "$extract_dir/app/lib" ]; then
        # Verplaats native libraries
        if [ -d "$extract_dir/app/lib/arm64-v8a" ]; then
            mv "$extract_dir/app/lib/arm64-v8a" "$extract_dir/libs/lib/"
        fi
    fi
    
    echo "  ✅ Uitgepakt naar $extract_dir/"
    echo ""
}

# Hoofdscript
echo "Maak extracted directory aan..."
mkdir -p "$EXTRACTED_DIR"
echo ""

# XAPK bestanden
extract_xapk "sns" "$BASE_DIR/nl.devolksbank.sns.bankieren.xapk"
extract_xapk "regio" "$BASE_DIR/nl.devolksbank.regio.bankieren.xapk"
extract_xapk "ing" "$BASE_DIR/com.ing.mobile.xapk"
extract_xapk "rabobank" "$BASE_DIR/nl.rabomobiel.xapk"
extract_xapk "knab" "$BASE_DIR/bvm.bvmapp.xapk"
extract_xapk "revolut" "$BASE_DIR/com.revolut.revolut.xapk"
extract_xapk "trade_republic" "$BASE_DIR/de.traderepublic.app.xapk"

# APKM bestand
extract_apkm "abnamro" "$BASE_DIR/com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm"

# APK bestand
extract_apk "wero" "$BASE_DIR/wero.apk"

echo "=== Extractie Voltooid ==="
echo "Eindtijd: $(date)"
echo ""
echo "Uitgepakte directories:"
ls -1 "$EXTRACTED_DIR/"
