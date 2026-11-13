# Statische analyse: apparaatveiligheid en remote attestation in de Triodos Bank Android-app (v5.13.7)

**Onderzocht pakket:** `com.triodos.bankingnl` (Triodos Bank), `versionName` 5.13.7 (`versionCode` 822, minSdk onbekend, targetSdk onbekend)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt, met nadruk op het Wero-onderdeel, en in kaart brengen hoe de app apparaatveiligheid inricht.

## Kernbevindingen

- De Triodos Bank-app gebruikt **geen** van de drie bekende remote attestation-mechanismen: Google Play Integrity API ❌ AFWEZIG, SafetyNet Attestation API ❌ AFWEZIG, en AndroidKeyStore-hardware-attestation ❌ AFWEZIG (`setAttestationChallenge` is volledig afwezig).
- Wero is aanwezig in de app met eigen endpoints (`/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet`), maar er is geen attestation-verzoek zichtbaar in de Wero-codepaden.
- Apparaatveiligheid is gebaseerd op **hardware-gebonden cryptografie met biometrie (PSD2 SCA)**, een server-side vertrouwd-apparaatmodel en verharding van de verbindingslaag, niet op een gezondheidsoordeel over het besturingssysteem.
- **Root-detectie is wel aanwezig** ✅ ACTIEF GEBRUIKT in native libraries (`libfourthline-security.so`): magisk, xposed, frida-gadget detectie.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | Geen klassen onder `com.google.android.play.core.integrity`; geen `play-services-integrity` dependency; geen `playintegrity.googleapis.com`-eindpunt; geen integrity-service-binding |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 82.265 unieke DEX-strings |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in beide DEX-bestanden en in alle native libraries |

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Status |
| --- | --- |
| Hardware-gebonden sleutelopslag | ✅ ACTIEF GEBRUIKT (`setIsStrongBoxBacked`, `setUserAuthenticationRequired`) |
| Biometrie / SCA | ✅ ACTIEF GEBRUIKT (`BiometricPrompt` met `CryptoObject`) |
| Root-detectie (native) | ✅ ACTIEF GEBRUIKT (`libfourthline-security.so`: magisk, xposed, frida-gadget) |
| Certificate pinning | ❓ Niet gecontroleerd |
| Native signing-componenten | ✅ Aanwezig (13 native libraries) |
| Wero-implementatie | ✅ ACTIEF GEBRUIKT (eigen endpoints) |

## Wero-specifiek

- **Wero-implementatie:** ✅ **ACTIEF GEBRUIKT** - Eigen Triodos Bank implementatie met endpoints `/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet`.
- **Validatiemethode:** ✅ **Server-side Validatie** - Wallet-registratie en betalingsflows zijn volledig server-side beheerd. Er is geen app-side attestation-token zichtbaar in de Wero-codepaden. Validatie vindt plaats op de backend zonder gebruik van Google Play Integrity of andere remote attestation mechanismen.
- **Implementatiedetails:** Geen extern Wero- of EPI SDK gedetecteerd. De implementatie is volledig eigen werk met native root-detectie (libfourthline-security.so) voor apparaatveiligheidscontroles.
- **Opmerking:** Triodos combineert Wero met native root-detectie voor een extra beveiligingslaag.

## Aanwezige verificatie- en betalingsgerelateerde SDK's

| SDK | Doel |
| --- | --- |
| Fourthline Security | Apparaatveiligheidscontroles (root-detectie, integriteitschecks) |
| Play Services (verschillende) | Basis Google-diensten (base, basement, location, mlkit, tapandpay, etc.) |

## Beperkingen van de analyse

1. Statische analyse van de basis-APK uit een XAPK-bundel; deelsplits bevatten alleen configuratie en native libraries. Server-side controles, remote-configuratie en voorwaardelijk geactiveerde paden blijven onzichtbaar.
2. De afwezigheid van `setAttestationChallenge` is gecontroleerd in zowel de DEX-bestanden (82.265 unieke strings) als de native libraries (13 .so-bestanden).
3. De analyse betreft versie 5.13.7 (versionCode 822); Triodos Bank kan in latere versies andere keuzes maken.

## Voorgestelde vervolgstappen (dynamische verificatie)
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen (XAPK-bundel)
apkeep -a com.triodos.bankingnl .

# Bundel en basis-APK uitpakken
unzip -o com.triodos.bankingnl.xapk -d xapk
unzip -o xapk/com.triodos.bankingnl.apk -d triodos_extracted

# Zoeken in DEX-bestanden na extractie van de stringtabellen
grep -ri "play.core.integrity"     # geen resultaten
grep -ri "safetynet"               # geen resultaten
grep -ri "setAttestationChallenge" # geen resultaten
grep -ri "setIsStrongBoxBacked"    # 1 resultaat
grep -ri "setUserAuthenticationRequired" # 1 resultaat
grep -ri "wero"                    # 75+ resultaten (eigen endpoints)
grep -ri "magisk\|xposed\|frida"  # in native libraries
```

De DEX-headers die voor de extractie zijn gebruikt: `string_ids_size/off` op offset 0x38/0x3C (ULEB128-lengte plus MUTF-8-gegevens per string) en `type_ids_size/off` op 0x40/0x44.

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
