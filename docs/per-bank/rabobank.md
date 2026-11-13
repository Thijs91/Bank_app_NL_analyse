# Statische analyse: apparaatveiligheid en remote attestation in de Rabobank Android-app (v8.1.4)

**Onderzocht pakket:** `nl.rabomobiel` (Rabobank), `versionName` 8.1.4 (`versionCode` 80150170)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata); **CLI-gebaseerde contextverificatie uitgevoerd**
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen (CLI-bevestigd)

- De Rabobank-app gebruikt **geen** remote attestation-mechanismen: Google Play Integrity API ❌ AFWEZIG, SafetyNet Attestation API ❌ AFWEZIG, en AndroidKeyStore-hardware-attestation ❌ AFWEZIG.
- **Contextverificatie bevestigd:** SafetyNet SDK (versie 18.1.0) is gebundeld, maar **niet gebruikt in eigen code** (geen `nl.rabomobiel` types).
- **SQLCipher is ⚠️ AANWEZIG (NIET ACTIEF)** (SQLiteCipher klassen gevonden, maar geen `nl.rabomobiel` types).
- **Certificate pinning is ✅ ACTIEF GEBRUIKT** (`CertificatePinner.kt` bevestigd in eigen code).
- **BiometricPrompt is ✅ ACTIEF GEBRUIKT** (`BiometricPromptManager.kt` en `nl.rabobank.bankierenplus.authentication.*` types bevestigd).

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | Geen klassen onder `com.google.android.play.core.integrity`; 0 treffers in marker analyse |
| SafetyNet | ❌ AFWEZIG | `safetynet.properties` (versie 18.1.0) en 86 treffers in marker analyse, maar **geen `nl.rabomobiel` types** in contextverificatie via `dex_locate.py` (vals-positief; SDK gebundeld maar niet actief gebruikt) |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in alle 8 DEX-bestanden |

## Wel aanwezige beveiligingsmechanismen (CLI-bevestigd)

| Mechanisme | Status | Waarneming in de APK |
| --- | --- | --- |
| Hardware-gebonden sleutelopslag | ⚠️ AANWEZIG (NIET ACTIEF) | `setIsStrongBoxBacked` (32 referenties in DEX-strings), maar **geen `nl.rabomobiel` types** in contextverificatie |
| Biometrie / SCA | ✅ **ACTIEF GEBRUIKT** | `android.hardware.biometrics.BiometricPrompt` (43 referenties); **bevestigd in eigen code**: `BiometricPromptManager.kt`, `nl.rabobank.bankierenplus.authentication.fingerprint.logging.BiometricFailureTracker`, `nl.rabobank.bankierenplus.authentication.biometric.biometricprompt.BiometricCryptoObjectFactory`, `nl.rabobank.bankierenplus.authentication.biometric.biometricprompt.BiometricPromptFactory` |
| setUserAuthenticationRequired | ⚠️ AANWEZIG (NIET ACTIEF) | 32 referenties in DEX-strings, maar **geen `nl.rabomobiel` types** in contextverificatie |
| Certificate pinning | ✅ **ACTIEF GEBRUIKT** | OkHttp `CertificatePinner` met 23 `sha256/`-spikkels; **bevestigd in eigen code**: `CertificatePinner.kt` gevonden in classes8.dex |
| SQLCipher | ⚠️ AANWEZIG (NIET ACTIEF) | 50 referenties in DEX-strings (bv. `Lnet/zetetic/database/sqlcipher/SupportOpenHelperFactory;`), maar **geen `nl.rabomobiel` types** in contextverificatie |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde code of endpoints gevonden in de APK.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - Rabobank heeft geen Wero-implementatie en voert daarom geen Wero-specifieke validatie uit.
- **Opmerking:** Rabobank gebruikt **Certificate pinning ✅ ACTIEF GEBRUIKT** en **BiometricPrompt ✅ ACTIEF GEBRUIKT** voor beveiliging, maar heeft geen Wero-integratie geïmplementeerd.

## Contextverificatie (CLI)

Gebruik van `dex_locate.py` met type filter `nl.rabomobiel` bevestigt dat:
- **SafetyNet** (`safetynet`): Geen `nl.rabomobiel` types → **❌ AFWEZIG** (vals-positief)
- **setIsStrongBoxBacked**: Geen `nl.rabomobiel` types → **⚠️ AANWEZIG (NIET ACTIEF)**
- **setUserAuthenticationRequired**: Geen `nl.rabomobiel` types → **⚠️ AANWEZIG (NIET ACTIEF)**
- **CertificatePinner**: **`CertificatePinner.kt`** gevonden in eigen code → **✅ ACTIEF GEBRUIKT**
- **BiometricPrompt**: **`BiometricPromptManager.kt`** en `nl.rabobank.bankierenplus.authentication.*` types → **✅ ACTIEF GEBRUIKT**
- **SQLCipher**: SQLiteCipher klassen gevonden, maar geen `nl.rabomobiel` types → **⚠️ AANWEZIG (NIET ACTIEF)**

## Native Libraries

- Geen arm64-v8a native libraries in deze extractie

## Beperkingen van de analyse

1. Statische analyse van de basis-APK
2. Geen native libraries beschikbaar in arm64-v8a extractie
3. Contextverificatie uitgevoerd voor alle attestation-mechanismen: SafetyNet vals-positief, Certificate pinning en BiometricPrompt bevestigd in eigen code
4. Server-side controles onzichtbaar

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.

## Reproductie

```bash
# APK ophalen
apkeep -a nl.rabomobiel .

# Uitpakken
unzip -o nl.rabomobiel.xapk -d xapk
unzip -o xapk/nl.rabomobiel.apk -d rabobank_extracted

# DEX extractie
python3 dex_extract.py rabobank_extracted rabobank_extracted/dex_out

# Contextverificatie (CLI-bevestigd)
python3 dex_locate.py rabobank_extracted/dex_out safetynet nl.rabomobiel
python3 dex_locate.py rabobank_extracted/dex_out setIsStrongBoxBacked nl.rabomobiel
python3 dex_locate.py rabobank_extracted/dex_out setUserAuthenticationRequired nl.rabomobiel
python3 dex_locate.py rabobank_extracted/dex_out CertificatePinner nl.rabomobiel
python3 dex_locate.py rabobank_extracted/dex_out BiometricPrompt nl.rabomobiel
python3 dex_locate.py rabobank_extracted/dex_out SQLCipher nl.rabomobiel

# Zoeken (marker analyse)
grep -ri "play.core.integrity"   # geen resultaten
grep -ri "safetynet"             # 86 treffers (vals-positief)
grep -ri "setAttestationChallenge" # geen resultaten
grep -oE "sha256/[A-Za-z0-9+/=]{40,}"  # 23 certificate pins
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

*Dit document bevestigt en actualiseert de eerdere analyse met CLI-contextverificatie van 7 november 2026.*
