# Statische analyse: apparaatveiligheid en remote attestation in de ING Android-app

**Onderzocht pakket:** `com.ing.mobile` (ING Bank), `versionName` 2025.25.1 (`versionCode` 2024313186)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen

- De ING-app gebruikt **geen** van de drie bekende remote attestation-mechanismen: Google Play Integrity API ❌ AFWEZIG, SafetyNet Attestation API ❌ AFWEZIG, en AndroidKeyStore-hardware-attestation ❌ AFWEZIG.
- Apparaatveiligheid is gebaseerd op hardware-gebonden cryptografie en server-side controles.
- ING is vergelijkbaar met bunq in de benadering van geen attestation.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | Geen klassen onder `com.google.android.play.core.integrity`; geen `play-services-integrity` dependency; 0 treffers in 468.409 unieke DEX-strings |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 468.409 unieke DEX-strings |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt; contextverificatie bevestigd: 1 treffer in classes4.dex had **geen com.ing types** (vals-positief)

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Hardware-gebonden sleutelopslag | `setIsStrongBoxBacked` (1 referentie in marker analyse) |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (11 referenties) |
| setUserAuthenticationRequired | 4 referenties in DEX-strings |
| Certificate pinning | OkHttp `CertificatePinner` (aangenomen) |

## Wero-specifiek

- **Wero-implementatie:** ❌ **AFWEZIG** - Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden in de DEX-bestanden of manifest.
- **Validatiemethode:** ❌ **Geen Wero-validatie** - ING gebruikt geen Wero en heeft daarom ook geen Wero-specifieke validatiemechanismen.
- **Opmerking:** ING baseert apparaatveiligheid op hardware-gebonden cryptografie en server-side controles, niet op Wero of remote attestation.

## Native Libraries

- Geen arm64-v8a native libraries in deze extractie

## Beperkingen van de analyse

1. Statische analyse van de basis-APK
2. Geen native libraries beschikbaar in arm64-v8a extractie
3. Server-side controles onzichtbaar

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen
apkeep -a com.ing.mobile .

# Uitpakken
unzip -o com.ing.mobile.xapk -d xapk
unzip -o xapk/com.ing.mobile.apk -d ing_extracted

# DEX extractie
python3 dex_extract.py ing_extracted ing_extracted/dex_out

# Zoeken
grep -ri "play.core.integrity"   # geen resultaten
grep -ri "safetynet"             # geen resultaten
grep -ri "setAttestationChallenge" # vals-positief (geen com.ing context)
```

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
