# Statische analyse: apparaatveiligheid en remote attestation in de Revolut Android-app

**Onderzocht pakket:** `com.revolut.revolut` (Revolut), `versionName` 10.153.1 (`versionCode` 1030153111)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen

- De Revolut-app gebruikt **zowel Google Play Integrity API ✅ ACTIEF GEBRUIKT als SafetyNet Attestation API ✅ ACTIEF GEBRUIKT** actief.
- Revolut heeft **native root-detectie ✅ ACTIEF GEBRUIKT** in `libfourthline-security.so`.
- SQLCipher is **✅ ACTIEF GEBRUIKT** voor databaseversleuteling.
- Revolut heeft de meest robuuste beveiligingsbenadering van alle geanalyseerde banken.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ✅ ACTIEF GEBRUIKT | 17 treffers in marker analyse, **met revolut.analytics.integrity types** in contextverificatie |
| SafetyNet | ✅ ACTIEF GEBRUIKT | 3 treffers in marker analyse, `ClientLifecycleSafetyNet` **met revolut types** in contextverificatie |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in alle 22 DEX-bestanden |

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Play Integrity | Actief gebruikt in revolut.analytics.integrity |
| SafetyNet | Actief gebruikt (ClientLifecycleSafetyNet) |
| Hardware-gebonden cryptografie | `setIsStrongBoxBacked` (5 referenties) |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (23 referenties) |
| setUserAuthenticationRequired | 5 referenties |
| Certificate pinning | OkHttp `CertificatePinner` |
| **Root-detectie (native)** | `libfourthline-security.so` bevat detectie voor magisk, xposed, frida-gadget |
| **SQLCipher** | Databaseversleuteling **bevestigd** (20 treffers + libsqlcipher.so) |
| FIDO2/WebAuthn | 20 treffers in marker analyse |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde code, endpoints of SDK's gevonden in de APK.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - Revolut heeft geen Wero-implementatie, ondanks het gebruik van zowel Play Integrity als SafetyNet voor attestation.
- **Opmerking:** Revolut heeft een eigen wallet-implementatie met native root-detectie, maar gebruikt niet het Wero/EPI-systeem.

## Native Libraries

- 21+ native libraries in `app_full/lib/arm64-v8a/`
- `libfourthline-security.so`: Root-detectie (magisk, xposed, frida-gadget)
- `libsqlcipher.so`: SQLCipher databaseversleuteling

## Beperkingen van de analyse

1. Statische analyse van de basis-APK uit een XAPK-bundel
2. Native libraries bevinden zich in `app_full/` directory
3. Server-side controles onzichtbaar

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen
apkeep -a com.revolut.revolut .

# Uitpakken (XAPK bundel)
unzip -o com.revolut.revolut.xapk -d xapk
unzip -o xapk/com.revolut.revolut.apk -d revolut_extracted
unzip -o xapk/app_full/base.arm64_v8a.apk -d revolut_appfull

# DEX extractie (uit app_full)
python3 dex_extract.py revolut_appfull revolut_appfull/dex_out

# Zoeken
grep -ri "play.core.integrity"   # 17 treffers (bevestigd in eigen code)
grep -ri "safetynet"             # 3 treffers (bevestigd in eigen code)
grep -ri "setAttestationChallenge" # geen resultaten
grep -ri "magisk\|xposed\|frida" # in libfourthline-security.so
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
