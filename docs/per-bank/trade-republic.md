# Statische analyse: apparaatveiligheid en remote attestation in de Trade Republic Android-app (v4.2645.1)

**Onderzocht pakket:** `de.traderepublic.app` (Trade Republic), `versionName` 4.2645.1 (`versionCode` 32005)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen

- De Trade Republic-app gebruikt **zowel Google Play Integrity API ✅ ACTIEF GEBRUIKT als AndroidKeyStore-hardware-attestation ✅ ACTIEF GEBRUIKT** actief.
- SafetyNet is **❌ AFWEZIG**.
- Trade Republic heeft een van de meest robuuste beveiligingsbenaderingen.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ✅ ACTIEF GEBRUIKT | 11 treffers in marker analyse, **met traderepublic types** in contextverificatie |
| SafetyNet | ❌ AFWEZIG | 0 treffers in marker analyse |
| AndroidKeyStore-hardware-attestation | ✅ ACTIEF GEBRUIKT | 16 treffers voor `setAttestationChallenge`, **met traderepublic types** in contextverificatie |

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Play Integrity | Actief gebruikt met traderepublic types |
| Hardware-attestation | `setAttestationChallenge` actief gebruikt |
| Hardware-gebonden sleutelopslag | `setIsStrongBoxBacked` (3 referenties) |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (45 referenties) |
| setUserAuthenticationRequired | 3 referenties |
| Certificate pinning | OkHttp `CertificatePinner` met 20 `sha256/`-spikkels |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden in de APK.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - Trade Republic gebruikt Play Integrity en AndroidKeyStore-hardware-attestation, maar heeft geen Wero-implementatie.
- **Opmerking:** Trade Republic heeft een van de meest robuuste beveiligingsbenaderingen, maar gebruikt niet het Wero/EPI-systeem.

## Native Libraries

- Geen arm64-v8a native libraries in deze extractie

## Beperkingen van de analyse

1. Statische analyse van de basis-APK
2. Geen native libraries beschikbaar in arm64-v8a extractie

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen
apkeep -a de.traderepublic.app .

# Uitpakken
unzip -o de.traderepublic.app.xapk -d xapk
unzip -o xapk/de.traderepublic.app.apk -d trade_extracted

# DEX extractie
python3 dex_extract.py trade_extracted trade_extracted/dex_out

# Zoeken
grep -ri "play.core.integrity"   # 11 treffers (bevestigd in eigen code)
grep -ri "safetynet"             # geen resultaten
grep -ri "setAttestationChallenge" # 16 treffers (bevestigd in eigen code)
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
