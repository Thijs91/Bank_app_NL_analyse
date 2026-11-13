#!/bin/bash

# Script om handmatig de ontbrekende APK's te downloaden
# Deze APK's konden niet via apkeep worden gedownload van APKPure
# Probeer de volgende methoden:

echo "=== Ontbrekende APK's Download Script ==="
echo ""
echo "De volgende APK's moeten handmatig worden gedownload:"
echo ""
echo "1. ABN AMRO (com.abnamro.nl.mobile.payments)"
echo "2. N26 (de.number26.android)"
echo "3. Wero (eu.epicompany.wero.wallet)"
echo ""
echo "=== Optie 1: APKMirror ==="
echo ""
echo "Bezoek de volgende URL's in je browser:"
echo ""
echo "ABN AMRO: https://www.apkmirror.com/apk/abn-amro-bank-n-v/abn-amro/"
echo "N26: https://www.apkmirror.com/apk/n26-gmbh/n26-bank/"
echo "Wero: https://www.apkmirror.com/apk/european-payments-initiative-epi/wero/"
echo ""
echo "Download de nieuwste versie en plaats de APK/XAPK in deze directory."
echo ""
echo "=== Optie 2: Aptoide ==="
echo ""
echo "Bezoek: https://en.aptoide.com/"
echo "Zoek op: ABN AMRO, N26, Wero"
echo ""
echo "=== Optie 3: apkeep met Google Play (vereist authenticatie) ==="
echo ""
echo "Voor Google Play downloads zijn credentials nodig:"
echo "  ./apkeep -a com.abnamro.nl.mobile.payments -d google-play -e <email> --oauth-token <token> ."
echo ""
echo "Zie: https://github.com/EFForg/apkeep voor authenticatie-instructies"
echo ""
echo "=== Huidige status ==="
echo ""
cd "/home/thijs/Downloads/Bank apps"
for pkg in com.abnamro.nl.mobile.payments de.number26.android eu.epicompany.wero.wallet; do
    if [ -f "$pkg.apk" ] || [ -f "$pkg.xapk" ] || [ -f "$pkg.apkm" ]; then
        echo "✅ $pkg - GEDOWNLOAD"
    else
        echo "❌ $pkg - ONTBREEKT"
    fi
done
echo ""
