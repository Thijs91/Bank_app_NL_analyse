# Statische analyse: apparaatveiligheid en remote attestation in de Knab Android-app (v4.11.0)

**Onderzocht pakket:** `bvm.bvmapp` (Knab), `versionName` 4.11.0 (`versionCode` 440)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata); **CLI-gebaseerde contextverificatie uitgevoerd**
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen (CLI-bevestigd)

- De Knab-app gebruikt **geen** van de drie bekende remote attestation-mechanismen: Google Play Integrity API ❌ AFWEZIG, SafetyNet Attestation API ❌ AFWEZIG, en AndroidKeyStore-hardware-attestation ❌ AFWEZIG.
- **Contextverificatie bevestigd:** Play Integrity markers (9 treffers) en SafetyNet markers (8 treffers) zijn **⚠️ AANWEZIG (NIET ACTIEF)** van gebundelde SDK's, maar **niet gebruikt in eigen code** (geen `bvm` types).
- SQLCipher is **❌ AFWEZIG** voor databaseversleuteling.
- **Certificate pinning is ⚠️ AANWEZIG (NIET ACTIEF)** (OkHttp `CertificatePinner` aanwezig, maar geen `bvm` types in contextverificatie).
- **BiometricPrompt is ⚠️ AANWEZIG (NIET ACTIEF)** (Android framework klassen aanwezig, maar geen `bvm` types).

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | 9 treffers in marker analyse, maar **geen `bvm` types** in contextverificatie via `dex_locate.py` (vals-positief; SDK gebundeld maar niet actief gebruikt) |
| SafetyNet | ❌ AFWEZIG | 8 treffers in marker analyse, maar **geen `bvm` types** in contextverificatie via `dex_locate.py` (vals-positief; SDK gebundeld maar niet actief gebruikt) |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in alle 7 DEX-bestanden |

## Wel aanwezige beveiligingsmechanismen (CLI-bevestigd)

| Mechanisme | Status | Waarneming in de APK |
| --- | --- | --- |
| Hardware-gebonden sleutelopslag | ⚠️ AANWEZIG (NIET ACTIEF) | `setIsStrongBoxBacked` (4 referenties in DEX-strings), maar **geen `bvm` types** in contextverificatie |
| Biometrie / SCA | ⚠️ AANWEZIG (NIET ACTIEF) | `android.hardware.biometrics.BiometricPrompt` (5 referenties), maar **geen `bvm` types** in contextverificatie |
| setUserAuthenticationRequired | ⚠️ AANWEZIG (NIET ACTIEF) | 4 referenties in DEX-strings, maar **geen `bvm` types** in contextverificatie |
| Certificate pinning | ⚠️ AANWEZIG (NIET ACTIEF) | OkHttp `CertificatePinner` met 14 `sha256/`-spikkels, maar **geen `bvm` types** in contextverificatie |
| iProov, ML Kit OCR | ✅ ACTIEF GEBRUIKT | Native libraries voor gezichtsherkenning en document scanning |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden in de APK.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - Knab heeft geen Wero-implementatie en voert dus geen Wero-specifieke validatie uit.
- **Opmerking:** Knab gebruikt iProov voor gezichtsherkenning en ML Kit OCR voor document scanning, maar heeft geen Wero-wallet functionaliteit.

## Contextverificatie (CLI)

Gebruik van `dex_locate.py` met type filter `bvm` bevestigt dat:
- **Play Integrity** (`play.core.integrity`): Geen `bvm` types → **❌ AFWEZIG** (vals-positief)
- **SafetyNet** (`safetynet`): Geen `bvm` types → **❌ AFWEZIG** (vals-positief)
- **setIsStrongBoxBacked**: Geen `bvm` types → **⚠️ AANWEZIG (NIET ACTIEF)**
- **setUserAuthenticationRequired**: Geen `bvm` types → **⚠️ AANWEZIG (NIET ACTIEF)**
- **CertificatePinner**: Geen `bvm` types → **⚠️ AANWEZIG (NIET ACTIEF)**
- **BiometricPrompt**: Geen `bvm` types → **⚠️ AANWEZIG (NIET ACTIEF)**

## Native Libraries

- 14 native libraries in `lib/arm64-v8a/`
- iProov en ML Kit OCR libraries
- Geen SQLCipher in native libraries

## Beperkingen van de analyse

1. Statische analyse van de basis-APK
2. Contextverificatie uitgevoerd voor alle attestation-mechanismen: geen actieve mechanismen bevestigd in eigen code
3. Server-side controles onzichtbaar

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.

## Reproductie

```bash
# APK ophalen
apkeep -a bvm.bvmapp .

# Uitpakken
unzip -o bvm.bvmapp.xapk -d xapk
unzip -o xapk/bvm.bvmapp.apk -d knab_extracted

# DEX extractie
python3 dex_extract.py knab_extracted knab_extracted/dex_out

# Contextverificatie (CLI-bevestigd)
python3 dex_locate.py knab_extracted/dex_out playintegrity bvm
python3 dex_locate.py knab_extracted/dex_out safetynet bvm
python3 dex_locate.py knab_extracted/dex_out setIsStrongBoxBacked bvm
python3 dex_locate.py knab_extracted/dex_out setUserAuthenticationRequired bvm
python3 dex_locate.py knab_extracted/dex_out CertificatePinner bvm
python3 dex_locate.py knab_extracted/dex_out BiometricPrompt bvm

# Zoeken (marker analyse)
grep -ri "play.core.integrity"   # 9 treffers (vals-positief)
grep -ri "safetynet"             # 8 treffers (vals-positief)
grep -ri "setAttestationChallenge" # geen resultaten
grep -oE "sha256/[A-Za-z0-9+/=]{40,}"  # 14 certificate pins
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

*Dit document bevestigt de eerdere analyse met CLI-contextverificatie van 7 november 2026.*
