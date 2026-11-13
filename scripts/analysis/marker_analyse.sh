#!/bin/bash

# Marker Analyse Script
# Zoekt naar attestatie markers in DEX strings_all.txt bestanden

BASE_DIR="/home/thijs/Downloads/Bank apps"
BANKS=("sns" "regio" "ing" "rabobank" "knab" "revolut" "trade_republic" "abnamro")
# Wero is verkeerd, dus skippen we die

# Markers per categorie
declare -A MARKERS=(
    ["Play Integrity"]="play.core.integrity|playintegrity|IntegrityManager|StandardIntegrityManager|requestIntegrityToken|cloudProjectNumber"
    ["SafetyNet"]="safetynet|SafetyNetClient"
    ["Hardware Attestation"]="setAttestationChallenge|attestationChallenge|attestationTypes|KeyAttestation"
    ["Android Keystore"]="AndroidKeyStore|setIsStrongBoxBacked|IsStrongBoxAvailable|setUserAuthenticationRequired"
    ["Biometrie"]="BiometricPrompt|CryptoObject|KeyPermanentlyInvalidatedException"
    ["Certificate Pinning"]="CertificatePinner"
    ["FIDO2"]="play-services-fido|FIDO2_|attestationConveyancePreference"
    ["SQLCipher"]="SQLCipher|libsqlcipher"
)

echo "=== Marker Analyse voor Alle Banks ==="
echo "Starttijd: $(date)"
echo ""

echo "# Marker Analyse Resultaten" > "$BASE_DIR/marker_results.log"
echo "Datum: $(date)" >> "$BASE_DIR/marker_results.log"
echo "" >> "$BASE_DIR/marker_results.log"

for bank in "${BANKS[@]}"; do
    strings_file="$BASE_DIR/extracted/$bank/dex_out/strings_all.txt"
    
    if [ ! -f "$strings_file" ]; then
        echo "❌ $bank: strings_all.txt niet gevonden"
        echo "" >> "$BASE_DIR/marker_results.log"
        continue
    fi
    
    echo "🔍 Analyseren: $bank"
    echo "   Bestandsgrootte: $(du -h "$strings_file" | cut -f1)"
    echo "   Pad: $strings_file"
    echo "" >> "$BASE_DIR/marker_results.log"
    echo "## $bank" >> "$BASE_DIR/marker_results.log"
    echo "" >> "$BASE_DIR/marker_results.log"
    
    for category in "${!MARKERS[@]}"; do
        pattern=${MARKERS[$category]}
        count=$(grep -iE "$pattern" "$strings_file" | wc -l)
        
        if [ "$count" -gt 0 ]; then
            echo "   ✅ $category: $count treffers"
            echo "   - $category: $count treffers" >> "$BASE_DIR/marker_results.log"
            
            # Toon eerste 3 treffers
            echo "      Voorbeeld treffers:" >> "$BASE_DIR/marker_results.log"
            grep -iE "$pattern" "$strings_file" | head -3 | sed 's/^/         /' >> "$BASE_DIR/marker_results.log"
        else
            echo "   ❌ $category: 0 treffers"
            echo "   - $category: 0 treffers" >> "$BASE_DIR/marker_results.log"
        fi
    done
    
    echo "" >> "$BASE_DIR/marker_results.log"
    echo ""
done

echo "=== Marker Analyse Voltooid ==="
echo "Eindtijd: $(date)"
echo ""
echo "Resultaten opgeslagen in: $BASE_DIR/marker_results.log"
