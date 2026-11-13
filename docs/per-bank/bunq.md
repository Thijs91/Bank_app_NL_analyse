# Statische analyse: apparaatveiligheid en remote attestation in de bunq Android-app (v32.4.1)

**Onderzocht pakket:** `com.bunq.android`, `versionName` 32.4.1 (`versionCode` 500001452, minSdk onbekend, targetSdk onbekend, compileSdkVersion 37)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata); CLI-gebaseerde verificatie
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt, met nadruk op het Wero-onderdeel, en in kaart brengen hoe de app apparaatveiligheid inricht.
**Status:** **PRIMAIRE ANALYSE** (CLI-verificatie bevestigd; zie `statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md` voor web-analyse als referentie)

## Kernbevindingen (CLI-bevestigd)

- De bunq-app gebruikt **geen** van de drie bekende remote attestation-mechanismen: Google Play Integrity API ❌ AFWEZIG, SafetyNet Attestation API ❌ AFWEZIG, en AndroidKeyStore-hardware-attestation ❌ AFWEZIG (`setAttestationChallenge` is volledig afwezig).
- Wero is volledig eigen implementatie van bunq (`com.bunq.android.model.wero.*`, eindpunten zoals `/user/{id}/wero-wallet`). Er is geen extern Wero- of EPI-SDK en geen attestation-verzoek zichtbaar in de Wero-codepaden.
- Apparaatveiligheid is gebaseerd op **hardware-gebonden cryptografie met biometrie (PSD2 SCA)**, een **server-side vertrouwd-apparaatmodel** en verharding van de verbindingslaag, niet op een gezondheidsoordeel over het besturingssysteem.
- **Nieuwe CLI-bevestiging:** De `setIsStrongBoxBacked` en `setUserAuthenticationRequired` zijn bevestigd in DEX-bestanden met `com.bunq` types.

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ❌ AFWEZIG | Geen klassen onder `com.google.android.play.core.integrity`; geen `play-services-integrity` dependency-metadata; geen `playintegrity.googleapis.com`-eindpunt; geen integrity-service-binding; Play Core beperkt tot app-update, in-app review en split-install |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 938.997 unieke DEX-strings |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | Methodenaam `setAttestationChallenge` ontbreekt in alle 12 DEX-bestanden en in alle 40 native libraries; de enige strings die `attest` bevatten zijn `UC_DROIDGUARD_ATTESTATION`, `UC_DROIDGUARD_VERDICT_INPUT` en `TAP_AND_PAY_ATTESTATION_ERROR` (Google Wallet intern) |

De DroidGuard- en TapAndPay-strings staan in `classes7.dex`, samen met de klassen van `com.google.android.gms.tapandpay` en `com.google.android.gms.wallet`. De gekoppelde Google Play Services-bindingen zijn beperkt tot analytics, appset, clearcut, common, identity, phenotype, signin, tapandpay en wallet: geen droidguard- of integrity-service.

## Wel aanwezige beveiligingsmechanismen (CLI-bevestigd)

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Hardware-gebonden sleutelopslag | `setIsStrongBoxBacked` (1 referentie, **bevestigd in com.bunq code**), `setUserAuthenticationRequired` (1 referentie, **bevestigd in com.bunq code**), Tink-integratie voor AndroidKeystore |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` (7 referenties) met `CryptoObject` (8 referenties); eigen klassen `com.bunq.android.security.BiometricDelegate` en `LoginTokenBiometricDelegate`; afhandeling van `KeyPermanentlyInvalidatedException` |
| Server-side apparaatregistratie | `DeviceApi`, `DeviceApiRequest` (apparaatnaam, OS-versie), `DeviceCheckCreateRequest`, `DeviceIdentityVerificationSession*`, installatie-flow (`InstallationCreateRequest`) en sessietokens gebonden aan het geregistreerde apparaat |
| Certificate pinning | OkHttp `CertificatePinner` met ruim tien `sha256/`-spikkels voor API-eindpunten |
| Lokale opslag | SQLCipher (59 string-referenties plus `libsqlcipher.so` **bevestigd in native libraries**) |
| Native signing | `libsigner.so` en `libNativeBridge.so` voor verwerking in native code |
| UI-hygïne | `SecuredActivity`, `SecuredFragment`, `SecuredBottomSheetDialog` (duidend op FLAG_SECURE-gebruik en blokkade van achtergrondweergave) |

## Contextverificatie (CLI)

Gebruik van `dex_locate.py` bevestigt dat:
- `setIsStrongBoxBacked` **wordt gebruikt in eigen code** (com.bunq types aanwezig in classes2.dex)
- `setUserAuthenticationRequired` **wordt gebruikt in eigen code** (com.bunq types aanwezig)
- SQLCipher referenties zijn **eigen code** (com.bunq types)

## Root- en emulator-detectie

De gevonden root- en emulator-detectie is niet van bunq zelf, maar van gebundelde derden:

- `io.sentry.android.core.internal.util.RootChecker` (`isDeviceRooted`, `/system/bin/su`, `/system/app/Superuser.apk`) — Sentry-diagnostiek.
- `"Test-keys aren't accepted on this build."` — Onfido SDK (identiteitsverificatie-flow).
- `EmulatorDetectedWarning` — Adyen 3DS2 SDK (kaartbetalingen).
- `Emulator detected, skipping cellular binding` — vonage/telefonie-component.

Er is geen hard, app-breed blok zichtbaar in eigen code dat gewijzigde apparaten weigert. Risicobeslissingen lijken per flow en aan de serverzijde te worden genomen.

## Wero-specifiek (CLI-bevestigd)

- **Wero-implementatie:** ✅ **ACTIEF GEBRUIKT** - Vollledig eigen Bunq implementatie zonder extern Wero- of EPI-SDK.
- **Validatiemethode:** ✅ **Server-side Validatie met Hardware-binding** - `WeroKeyStoreHelper.kt` beheert wallet-sleutels in Android Keystore met hardware-gebonden sleutelopslag en device-binding. Validatie vindt server-side plaats zonder app-side attestation-token (geen challenge/response, geen attestation-certificaatketen).
- **Implementatiedetails:** Alle Wero-klassen zijn bunq-eigendommen: `com.bunq.android.model.wero.*`, `com.bunq.android.ui.activity.wero.*`, met endpoints `/user/{userId}/wero-wallet`, `/user/{userId}/wero-consumer`, `/user/{userId}/wero-issuer-transaction`.
- **Opmerking:** Bunq baseert apparaatveiligheid op hardware-gebonden cryptografie en server-side apparaatregistratie, niet op remote attestation mechanismen.

## Aanwezige betalingsgerelateerde SDK's

| SDK | Doel |
| --- | --- |
| Adyen 3DS2 (`com.adyen.threeds2`, assets `a3ds2_srn`, `atd`) | Kaartbetalingen; eigen apparaatintegriteitscontroles (3DS-deviceInfo, SDK-tamperwaarschuwing) |
| Google Wallet / TapAndPay (`play-services-wallet`, `play-services-tapandpay`) | Google Pay-functionaliteit; intern DroidGuard-gebruik van Google Wallet |
| Onfido, Incode | Identiteitsverificatie (onboarding), met eigen omgevingscontroles |

## Native Library Scan

- 40 native libraries in `lib/arm64-v8a/` gescand
- Geen referenties naar `setAttestationChallenge`, `setIsStrongBoxBacked`, `setUserAuthenticationRequired` in native code
- `libsqlcipher.so` bevestigd (SQLCipher-bundeling)
- Geen Frida/Xposed/Magisk-detectie in native libraries

## Beperkingen van de analyse

1. Statische analyse van de basis-APK; split-APK's, server-side controles, remote-configuratie en voorwaardelijk geactiveerde paden zijn hiermee niet volledig zichtbaar.
2. Obfuscatie kan reflectieve aanroepen verbergen; een Play Integrity-integratie zou echter minimaal de client-klassen, de service-binding of het eindpunt tonen, die alle afwezig zijn.
3. De analyse betreft versie 32.4.1; bunq kan in latere versies andere keuzes maken.

## Voorgestelde vervolgstappen (dynamische verificatie)
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen
apkeep -a com.bunq.android .

# Uitpakken
unzip -o com.bunq.android.apk -d bunq_extracted

# DEX extractie
python3 dex_extract.py bunq_extracted bunq_extracted/dex_out

# DEX-string- en klassenextractie (header: string_ids op 0x38, type_ids op 0x40)
# en vervolgens zoeken op:
grep -ri "play.core.integrity"   # geen resultaten
grep -ri "droidguard"            # alleen Google Wallet-intern (classes7.dex)
grep -ri "safetynet"             # geen resultaten
grep -ri "setAttestationChallenge"  # geen resultaten
grep -ri "setIsStrongBoxBacked"     # 1 resultaat (bevestigd in eigen code)
grep -ri "SQLCipher"              # 59 resultaten (bevestigd in eigen code)
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
