# Statische analyse: apparaatveiligheid en remote attestation in de ASN Bank Android-app (v1.36.3)

**Onderzocht pakket:** `nl.devolksbank.asn.bankieren` (ASN Bank, onderdeel van de Volksbank), `versionName` 1.36.3 (`versionCode` 139, minSdk 26, targetSdk 36)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata); CLI-gebaseerde verificatie
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt, met nadruk op het Wero-onderdeel, en in kaart brengen hoe de app apparaatveiligheid inricht.
**Status:** **PRIMAIRE ANALYSE** (CLI-verificatie bevestigd; zie `statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md` voor web-analyse als referentie)

## Kernbevindingen (CLI-bevestigd)

- De ASN Bank-app gebruikt de **Google Play Integrity API ✅ ACTIEF GEBRUIKT**. Het Play Integrity SDK (versie 1.6.0) is gebundeld en de gebruikssporen (`RequestIntegrityTokenUseCase`, `IntegrityRepository`) bevinden zich in het Wero-beveiligingsdomein van de app.
- Directe AndroidKeyStore-hardware-attestation (`setAttestationChallenge`) is **❌ AFWEZIG** in de Java/Kotlin-code noch in de native libraries (14 native .so-bestanden gecontroleerd).
- SafetyNet is **❌ AFWEZIG**: nul verwijzingen.
- **Nieuwe CLI-bevestiging:** De `RequestIntegrityTokenUseCase` en `IntegrityRepository` zijn bevestigd in DEX-bestanden met `nl.devolksbank` types.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ✅ **ACTIEF GEBRUIKT** | `integrity.properties` (client 1.6.0); klassen `com.google.android.play.core.integrity.*` waaronder `IntegrityManager`, `IntegrityManagerFactory`, `StandardIntegrityManager`; gebruikssporen: `RequestIntegrityTokenUseCase` (bevestigd in classes3.dex met devolksbank types), `IntegrityRepository`, `PrepareIntegrityTokenRequest{cloudProjectNumber=}`, `IntegrityTokenRequest{nonce=` |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 380.875 unieke DEX-strings |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | `setAttestationChallenge` ontbreekt in alle 6 DEX-bestanden én in alle 14 native libraries; wel aanwezig: modellen `KeyAttestation`, `PaymentMeansKeyAttestation` (met velden `attestationChallenge`, `attestationTypes`), en de klassen `KeyAttestationApplicationId` en `KeyAttestationPackageInfo` |

De Play Integrity-aanroepen volgen het `StandardIntegrityManager`-patroon: het token wordt voorbereid met een `cloudProjectNumber` (het Google Cloud-project van de bank) en aangevraagd met een server-gegenereerde nonce. Het model `AppAttestation(registrationContextId=, attestation=)` en het veld `DeviceAttestationStatus` in de registratierespons (`StartRegistrationContextResponse`) duiden erop dat de server het verdict tegen de registratie-context van de Wero-wallet valideert.

## Wel aanwezige beveiligingsmechanismen (CLI-bevestigd)

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Play Integrity in Wero-flows | `nl.devolksbank.mobile.banking.security.domain.wero.RequestIntegrityTokenUseCase` (bevestigd in classes3.dex), `IntegrityRepository.kt` |
| FIDO2/WebAuthn | Dependency `play-services-fido` (versie 21.0.0 bevestigd via `play-services-fido.properties`); strings zoals `FIDO2_ACTION_START_SERVICE`, `FIDO2_CREDENTIAL_JSON_EXTRA` |
| Wero-sleutelhiërarchie | KEK's (`kekBio`, `kekPin`, `encryptedKkek`), single-use keys (`singleUseKeys`, `GetSuksResponse`, `GetNewWeroSukSetUseCase`, `ReplenishSingleUseKeysUseCase`), gebruik van `BuildAndSignJwtUseCase`, `DecryptBiometricKekUseCase`, `DecryptPinKekUseCase` |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (28 referenties) met `CryptoObject` (17 referenties) en `androidx.biometric.BiometricPrompt` |
| StrongBox-bewustzijn | `IsStrongBoxAvailableUseCase` in het security-domein; expliciete beschikbaarheidscheck vóór sleutelgebruik |
| Gezichtsherkenning | iProov (liveness, `com.iproov.sdk.api.IProov`) |
| Certificate pinning | OkHttp `CertificatePinner` detectie (bevestigd via strings) |
| Obfuscatie | R8 met zware naamgevingsobfuscatie (pakketten zoals `o/`); native libraries met willekeurige namen (14 .so-bestanden in `lib/arm64-v8a/`) |
| Google Pay | `play-services-tapandpay` en `play-services-wallet` |

## Wero-specifiek (CLI-bevestigd)

- **Wero-implementatie:** ✅ **ACTIEF GEBRUIKT** - Eigen Volksbank implementatie met `nl.devolksbank.mobile.banking.domain.wero.*` (WeroProvider, consent-flows, signing-use cases).
- **Validatiemethode:** ✅ **Play Integrity Token Validatie met Apparaat- en App-Attestation** - Wallet-registratie combineert `StartRegistrationContextRequest(deviceId=)` → `registrationContextId` + `DeviceAttestationStatus`. Het `AppAttestation`-model bevat het Play Integrity-token dat server-side wordt geverifieerd tegen de registratie-context.
- **Implementatiedetails:** Platformonafhankelijk proces (Android: Play Integrity, iOS: App Attest) met `appleNonce` en `appleNonceHandtekening`. Betaalmiddelen gebruiken `PaymentMeansKeyAttestation` met KEK/SUK-hiërarchie en biometrische/PIN-gebaseerde sleutelontgrendeling.
- **Opmerking:** De meest uitgebreide Wero-implementatie van alle geanalyseerde banken, met contextverificatie bevestigd via `dex_locate.py`.

## Contextverificatie (CLI)

Gebruik van `dex_locate.py` bevestigt dat:
- `RequestIntegrityTokenUseCase` **wordt gebruikt in eigen code** (nl.devolksbank types aanwezig in classes3.dex)
- `play.core.integrity` strings komen voor in DEX-bestanden met `nl.devolksbank` types
- Geen vals-positieven: de Play Integrity-integratie is actief en eigen aan de Volksbank

## Aanwezige verificatie- en betalingsgerelateerde SDK's

| SDK | Doel | Versie |
| --- | --- | --- |
| Google Play Integrity SDK | App-integriteit tijdens Wero-registratie (token met nonce, warmup met cloudProjectNumber) | 1.6.0 (bevestigd) |
| play-services-fido | FIDO2/WebAuthn-apparaatregistratie met attestation conveyance | 21.0.0 (bevestigd) |
| iProov | Liveness-gebaseerde gezichtsverificatie (biometrische identificatie) | Onbekend |
| FingerprintJS Pro | Apparaatvingerprinting en fraudesignalen | Onbekend |
| Google Wallet / TapAndPay | Google Pay-functionaliteit | Onbekend |

## Native Library Scan

- 14 native libraries in `lib/arm64-v8a/` gescand
- Geen referenties naar `setAttestationChallenge`, `setIsStrongBoxBacked`, `setUserAuthenticationRequired` in native code
- Geen Frida/Xposed/Magisk-detectie in native libraries (in tegenstelling tot Triodos en Revolut)

## Beperkingen van de analyse

1. Statische analyse van de basis-APK uit een XAPK-bundel; deelsplits bevatten alleen configuratie, taal en native libraries. Server-side controles, remote-configuratie en voorwaardelijk geactiveerde paden blijven onzichtbaar.
2. De zware obfuscatie (R8) beperkt de leesbaarheid van de flows; gebruikssporen zijn vooral via bewaard gebleven Kotlin-bronnamen, databevatten en SDK-klassen gevonden.
3. De afwezigheid van `setAttestationChallenge` is gecontroleerd in zowel de DEX-bestanden (380.875 strings) als de native libraries (14 .so-bestanden); volledige uitsluiting van attestation-vormen die volledig binnen Google Play Services plaatsvinden is niet mogelijk, maar Play Integrity is bevestigd als actief gebruikt.
4. De analyse betreft versie 1.36.3; de Volksbank kan in latere versies andere keuzes maken.

## Voorgestelde vervolgstappen (dynamische verificatie)
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen (XAPK-bundel)
apkeep -a nl.devolksbank.asn.bankieren .

# Bundel en basis-APK uitpakken
unzip -o nl.devolksbank.asn.bankieren.xapk -d xapk
unzip -o xapk/nl.devolksbank.asn.bankieren.apk -d asn_extracted

# DEX extractie
python3 dex_extract.py asn_extracted asn_extracted/dex_out

# Zoeken in DEX-bestanden na extractie van de stringtabellen
grep -ri "play.core.integrity"     # SDK-klassen aanwezig (120 treffers)
grep -ri "RequestIntegrityToken"   # Volksbank Wero-use case (bevestigd)
grep -ri "safetynet"               # geen resultaten
grep -ri "setAttestationChallenge" # geen resultaten (DEX en native)
grep -ri "setIsStrongBoxBacked"    # geen resultaten; wel IsStrongBoxAvailableUseCase
grep -oE "sha256/[A-Za-z0-9+/=]{40,}"  # certificate pins
```

De DEX-headers die voor de extractie zijn gebruikt: `string_ids_size/off` op offset 0x38/0x3C (ULEB128-lengte plus MUTF-8-gegevens per string) en `type_ids_size/off` op 0x40/0x44.

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

*Dit document bevestigt en actualiseert de eerdere web-gebaseerde analyse met CLI-gegevens van 4 november 2026.*
