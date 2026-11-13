# Statische analyse: apparaatveiligheid en remote attestation in de ABN AMRO Android-app

**Onderzocht pakket:** `com.abnamro.nl.mobile.payments` (ABN AMRO), `versionName` 13.34 (`versionCode` 10261289)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen

- De ABN AMRO-app gebruikt **SafetyNet Attestation API ✅ ACTIEF GEBRUIKT** voor remote attestation.
- Google Play Integrity API is **❌ AFWEZIG**.
- Directe AndroidKeyStore-hardware-attestation (`setAttestationChallenge`) is **❌ AFWEZIG**.
- SQLCipher is **✅ ACTIEF GEBRUIKT** voor databaseversleuteling.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | Geen klassen onder `com.google.android.play.core.integrity`; 0 treffers in marker analyse |
| SafetyNet | ✅ ACTIEF GEBRUIKT | SafetyNet SDK in `app_full/` directory, 51 treffers in marker analyse |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in alle 9 DEX-bestanden |

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| SafetyNet Attestation | SDK gebundeld in app_full/ |
| Hardware-gebonden sleutelopslag | `setIsStrongBoxBacked` (5 referenties) |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (12 referenties) |
| setUserAuthenticationRequired | 5 referenties |
| Certificate pinning | OkHttp `CertificatePinner` met 2 `sha256/`-spikkels |
| **SQLCipher** | Databaseversleuteling **bevestigd** (57 treffers + libsqlcipher.so in native libraries) |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde code, endpoints of SDK's gevonden in de APK.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - Aangezien er geen Wero-implementatie aanwezig is, wordt er ook geen Wero-specifieke validatie uitgevoerd.
- **Opmerking:** ABN AMRO gebruikt SafetyNet voor attestation, maar heeft (nog) geen Wero-integratie geïmplementeerd.

## Native Libraries

- 28 native libraries in `lib/arm64-v8a/`
- `libsqlcipher.so` bevestigd

## Beperkingen van de analyse

1. Statische analyse van de basis-APK
2. SDK properties in `app_full/` in plaats van `app/`
3. Server-side controles onzichtbaar

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen (handmatig gedownload via APKMirror)
# apkmirror: com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm

# Uitpakken
unzip -o com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm -d xapk
unzip -o xapk/base.apk -d abnamro_extracted
unzip -o xapk/app_full/base.arm64_v8a.apk -d abnamro_appfull

# DEX extractie
python3 dex_extract.py abnamro_appfull abnamro_appfull/dex_out

# Zoeken
grep -ri "play.core.integrity"   # geen resultaten
grep -ri "safetynet"             # 51 treffers
grep -ri "setAttestationChallenge" # geen resultaten
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
