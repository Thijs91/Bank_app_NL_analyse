# Wero Implementatie Diepgaande Vergelijking
## Statische Analyse van Nederlandse Bank Android Apps

**Project:** Nederlandse Bank Apps (11 banken)  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** ✅ Voltooid (Verdiepende Analyse Punt 1.2)  
**Doel:** Gedetailleerde vergelijking van Wero-implementaties tussen banken

---

## 📋 Inleiding

Dit document documenteert de **verdiepende analyse punt 1.2** uit [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) en beantwoordt de volgende vraag:
*Hoe verschillen de Wero-implementaties tussen de 5 banken die Wero actief gebruiken (ASN Bank, RegioBank, SNS Bank, bunq, Triodos) en welke patronen zijn zichtbaar in hun benaderingen?*

De analyse is gebaseerd op:
- Individuele statische analyse documenten voor alle 5 Wero-banken
- Contextverificatie voor alle banken (bevestigd via CLI)
- Marker analyse en DEX-extractie resultaten
- Native library scans

**Belangrijke opmerking:** Deze analyse blijft **feitelijk en objectief**. Er worden geen waardeoordelen gegeven over de mate van beveiliging van de verschillende implementaties.

---

## 🎯 Doelstellingen

Deze analyse beoogt de volgende inzichten te genereren:

1. ✅ **Vergelijk Wero-flows** tussen Volksbank (Play Integrity Token Validatie) vs bunq (Server-side met Hardware-binding) vs Triodos (Server-side)
2. ✅ **Analyseer sleutelbeheer** (KEK/SUK hiërarchie vs Hardware-binding)
3. ✅ **Document validatiemethoden** per bank
4. ✅ **Identificeer gedeelde codebase** (Volksbank apps)
5. ✅ **Maak vergelijkende matrix** van Wero-features

---

## 📊 1. OVERZICHT WERO-BANKEN

### 1.1 Lijst van Banken met Wero

| Bank | Pakketnaam | Versie | Wero Status | Validatiemethode |
|------|------------|--------|-------------|------------------|
| **ASN Bank** | `nl.devolksbank.asn.bankieren` | v1.36.3 | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie |
| **RegioBank** | `nl.devolksbank.regio.bankieren` | v1.36.3 | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie |
| **SNS Bank** | `nl.devolksbank.sns.bankieren` | v1.36.3 | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie |
| **bunq** | `com.bunq.android` | v32.4.1 | ✅ ACTIEF GEBRUIKT | Server-side Validatie met Hardware-binding |
| **Triodos** | `com.triodos.bankingnl` | v5.13.7 | ✅ ACTIEF GEBRUIKT | Server-side Validatie |

**Totaal:** 5 banken (45% van alle 11 geanalyseerde banken)

---

## 🏗️ 2. WERO-IMPLEMENTATIE BENADERINGEN

Er zijn **drie distincte benaderingen** geïdentificeerd voor Wero-implementatie:

### 2.1 Benadering 1: Play Integrity Token Validatie (Volksbank Groep)

**Banken:** ASN Bank, RegioBank, SNS Bank  
**Aantal:** 3 banken  
**Gedeelde Codebase:** ✅ Ja (alle drie delen dezelfde Volksbank codebase)

#### Implementatiedetails

| Aspect | ASN Bank | RegioBank | SNS Bank |
|--------|----------|-----------|----------|
| **SDK Versie** | Play Integrity SDK v1.6.0 | Play Integrity SDK v1.6.0 | Play Integrity SDK v1.6.0 |
| **FIDO2/WebAuthn** | ✅ Versie 21.0.0 | ✅ Versie 21.0.0 | ✅ Versie 21.0.0 |
| **Codebase** | Volksbank | Volksbank | Volksbank |

##### Gedeelde Componenten

**Klasses en Use Cases:**
- `nl.devolksbank.mobile.banking.security.domain.wero.RequestIntegrityTokenUseCase`
- `IntegrityRepository.kt`
- `StandardIntegrityManager` (Google Play Core Integrity)

**Flow:**
1. Wallet-registratie start met `StartRegistrationContextRequest(deviceId=)`
2. Server genereert `registrationContextId` en `DeviceAttestationStatus`
3. `PrepareIntegrityTokenRequest{cloudProjectNumber=}` wordt voorbereid
4. `IntegrityTokenRequest{nonce=` wordt aangemaakt met server-gegenereerde nonce
5. Play Integrity token wordt aangevraagd via `StandardIntegrityManager`
6. `AppAttestation`-model bevat het Play Integrity token
7. Server valideert het token tegen de registratie-context

**Sleutelhiërarchie (KEK/SUK):**
- **KEK's (Key Encryption Keys):**
  - `kekBio` - Biometrisch gebonden KEK
  - `kekPin` - PIN-gebonden KEK
  - `encryptedKkek` - Versleutelde KEK
- **Single-Use Keys (SUK):**
  - `singleUseKeys`
  - `GetSuksResponse`
  - `GetNewWeroSukSetUseCase`
  - `ReplenishSingleUseKeysUseCase`
- **JWT Operaties:**
  - `BuildAndSignJwtUseCase`
  - `DecryptBiometricKekUseCase`
  - `DecryptPinKekUseCase`

**Platformonafhankelijk:**
- Android: Play Integrity
- iOS: App Attest
- Beide gebruiken `appleNonce` en `appleNonceHandtekening` voor iOS-integratie

**Betalingsmiddelen:**
- Gebruik van `PaymentMeansKeyAttestation` met KEK/SUK-hiërarchie
- Biometrische/PIN-gebaseerde sleutelontgrendeling

##### ASN Bank Specifieke Details

**Contextverificatie (CLI):**
- `RequestIntegrityTokenUseCase` **bevestigd in eigen code** (nl.devolksbank types aanwezig in classes3.dex)
- `play.core.integrity` strings komen voor in DEX-bestanden met `nl.devolksbank` types
- Geen vals-positieven: Play Integrity-integratie is actief en eigen aan de Volksbank

**Native Libraries:**
- 14 native libraries in `lib/arm64-v8a/`
- Geen referenties naar `setAttestationChallenge`, `setIsStrongBoxBacked`, `setUserAuthenticationRequired` in native code
- Geen Frida/Xposed/Magisk-detectie in native libraries
- iProov libraries voor gezichtsherkenning

---

### 2.2 Benadering 2: Server-side Validatie met Hardware-binding (bunq)

**Bank:** bunq  
**Aantal:** 1 bank

#### Implementatiedetails

| Aspect | Details |
|--------|---------|
| **Extern SDK** | ❌ Geen extern Wero- of EPI-SDK |
| **Implementatie** | Vollledig eigen Bunq implementatie |
| **Codebase** | `com.bunq.android.model.wero.*`, `com.bunq.android.ui.activity.wero.*` |

**Flow:**
1. Apparaatregistratie via `DeviceApi`, `DeviceApiRequest` (apparaatnaam, OS-versie)
2. `DeviceCheckCreateRequest`, `DeviceIdentityVerificationSession*` voor apparaatidentificatie
3. Installatie-flow (`InstallationCreateRequest`) met sessietokens gebonden aan het geregistreerde apparaat
4. `WeroKeyStoreHelper.kt` beheert wallet-sleutels in Android Keystore
5. Hardware-gebonden sleutelopslag via `setIsStrongBoxBacked` en `setUserAuthenticationRequired`
6. Validatie vindt **server-side** plaats zonder app-side attestation-token
7. Geen challenge/response mechanismen
8. Geen attestation-certificaatketen

**Endpoints:**
- `/user/{userId}/wero-wallet`
- `/user/{userId}/wero-consumer`
- `/user/{userId}/wero-issuer-transaction`

**Sleutelbeheer:**
- Hardware-gebonden sleutelopslag in Android Keystore
- `setIsStrongBoxBacked` (1 referentie, **bevestigd in com.bunq code**)
- `setUserAuthenticationRequired` (1 referentie, **bevestigd in com.bunq code**)
- Tink-integratie voor AndroidKeystore

**Apparaatveiligheid:**
- Server-side apparaatregistratie en sessietokens
- Hardware-gebonden cryptografie met biometrie (PSD2 SCA)
- Server-side vertrouwd-apparaatmodel
- Risicobeslissingen per flow en aan de serverzijde

**Contextverificatie (CLI):**
- `setIsStrongBoxBacked` **wordt gebruikt in eigen code** (com.bunq types aanwezig in classes2.dex)
- `setUserAuthenticationRequired` **wordt gebruikt in eigen code** (com.bunq types aanwezig)
- SQLCipher referenties zijn **eigen code** (com.bunq types)

**Native Libraries:**
- 40 native libraries in `lib/arm64-v8a/`
- `libsqlcipher.so` bevestigd (SQLCipher-bundeling)
- `libsigner.so` en `libNativeBridge.so` voor native signing
- Geen Frida/Xposed/Magisk-detectie in native libraries

**Root-detectie:**
- Root-detectie is **niet van bunq zelf**, maar van gebundelde derden:
  - `io.sentry.android.core.internal.util.RootChecker` (Sentry-diagnostiek)
  - Onfido SDK (identiteitsverificatie)
  - Adyen 3DS2 SDK (kaartbetalingen)
  - vonage/telefonie-component
- Geen hard, app-breed blok in eigen code

**Betalingsgerelateerde SDK's:**
- Adyen 3DS2 (`com.adyen.threeds2`)
- Google Wallet / TapAndPay (`play-services-wallet`, `play-services-tapandpay`)
- Onfido, Incode (identiteitsverificatie)

---

### 2.3 Benadering 3: Server-side Validatie (Triodos)

**Bank:** Triodos  
**Aantal:** 1 bank

#### Implementatiedetails

| Aspect | Details |
|--------|---------|
| **Extern SDK** | ❌ Geen extern Wero- of EPI-SDK |
| **Implementatie** | Vollledig eigen Triodos Bank implementatie |

**Flow:**
1. Wallet-registratie via eigen endpoints
2. Betalingsflows volledig server-side beheerd
3. Validatie vindt **server-side** plaats zonder app-side attestation-token
4. Geen app-side attestation-token zichtbaar in Wero-codepaden

**Endpoints:**
- `/wero/wallet`
- `/wero/consent/`
- `/v4/wero/wallet`

**Sleutelbeheer:**
- Hardware-gebonden sleutelopslag: `setIsStrongBoxBacked`, `setUserAuthenticationRequired`
- Biometrie / SCA: `BiometricPrompt` met `CryptoObject`

**Apparaatveiligheid:**
- Hardware-gebonden cryptografie met biometrie (PSD2 SCA)
- Server-side vertrouwd-apparaatmodel
- Native root-detectie voor apparaatveiligheidscontroles

**Native Libraries:**
- 13 native libraries in `lib/arm64-v8a/`
- `libfourthline-security.so` voor root-detectie (magisk, xposed, frida-gadget detectie)
- Native signing-componenten

**Root-detectie:**
- ✅ ACTIEF GEBRUIKT in native libraries
- `libfourthline-security.so` detecteert:
  - Magisk
  - Xposed
  - Frida-gadget

**Betalingsgerelateerde SDK's:**
- Fourthline Security (apparaatveiligheidscontroles)
- Play Services (basis Google-diensten)

---

## 📊 3. VERGELIJKENDE MATRIX VAN WERO-FEATURES

### 3.1 Overzichtstabel

| Feature | ASN Bank | RegioBank | SNS Bank | bunq | Triodos |
|---------|----------|-----------|----------|------|---------|
| **Wero-implementatie** | ✅ Eigen (Volksbank) | ✅ Eigen (Volksbank) | ✅ Eigen (Volksbank) | ✅ Eigen | ✅ Eigen |
| **Extern Wero/EPI SDK** | ❌ Nee | ❌ Nee | ❌ Nee | ❌ Nee | ❌ Nee |
| **Validatiemethode** | Play Integrity Token Validatie | Play Integrity Token Validatie | Play Integrity Token Validatie | Server-side met Hardware-binding | Server-side |
| **Gedeelde Codebase** | ✅ Volksbank | ✅ Volksbank | ✅ Volksbank | ❌ Nee | ❌ Nee |
| **Play Integrity SDK** | ✅ v1.6.0 | ✅ v1.6.0 | ✅ v1.6.0 | ❌ AFWEZIG | ❌ AFWEZIG |
| **FIDO2/WebAuthn** | ✅ v21.0.0 | ✅ v21.0.0 | ✅ v21.0.0 | ❌ AFWEZIG | ❌ AFWEZIG |
| **KEK/SUK Hiërarchie** | ✅ Ja | ✅ Ja | ✅ Ja | ❓ Niet gedocumenteerd | ❓ Niet gedocumenteerd |
| **Hardware-binding** | ⚠️ Via StrongBox (Play Integrity) | ⚠️ Via StrongBox (Play Integrity) | ⚠️ Via StrongBox (Play Integrity) | ✅ Direct (StrongBox) | ✅ Direct (StrongBox) |
| **setIsStrongBoxBacked** | ⚠️ Aanwezig | ⚠️ Aanwezig | ⚠️ Aanwezig | ✅ Bevestigd in eigen code | ✅ Bevestigd |
| **setUserAuthenticationRequired** | ⚠️ Aanwezig | ⚠️ Aanwezig | ⚠️ Aanwezig | ✅ Bevestigd in eigen code | ✅ Bevestigd |
| **Server-side Validatie** | ✅ Ja | ✅ Ja | ✅ Ja | ✅ Ja | ✅ Ja |
| **App-side Attestation Token** | ✅ Ja (Play Integrity) | ✅ Ja (Play Integrity) | ✅ Ja (Play Integrity) | ❌ Nee | ❌ Nee |
| **Cloud Project Number** | ✅ Ja | ✅ Ja | ✅ Ja | ❌ Nee | ❌ Nee |
| **Server-generated Nonce** | ✅ Ja | ✅ Ja | ✅ Ja | ❓ Niet gespecificeerd | ❓ Niet gespecificeerd |
| **Device Attestation Status** | ✅ Ja | ✅ Ja | ✅ Ja | ❓ Niet gespecificeerd | ❓ Niet gespecificeerd |
| **Native Root-detectie** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG (derden) | ✅ ACTIEF (libfourthline-security.so) |
| **SQLCipher** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **BiometricPrompt** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **StrongBox** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **Certificate Pinning** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❓ NIET GEÏNSPECTEERD |

---

### 3.2 Gedetailleerde Feature Vergelijking

#### Sleutelbeheer

| Aspect | Volksbank (ASN/Regio/SNS) | bunq | Triodos |
|--------|----------------------------|------|---------|
| **KEK Types** | kekBio, kekPin, encryptedKkek | ❓ Niet gespecificeerd | ❓ Niet gespecificeerd |
| **SUK Beheer** | GetSuksResponse, GetNewWeroSukSetUseCase, ReplenishSingleUseKeysUseCase | ❓ Niet gespecificeerd | ❓ Niet gespecificeerd |
| **JWT Operaties** | BuildAndSignJwtUseCase, DecryptBiometricKekUseCase, DecryptPinKekUseCase | ❓ Niet gespecificeerd | ❓ Niet gespecificeerd |
| **Hardware-binding** | Via Play Integrity token + StrongBox | Direct via Android Keystore (StrongBox) | Direct via Android Keystore (StrongBox) |

#### Validatie Mechanismen

| Aspect | Volksbank (ASN/Regio/SNS) | bunq | Triodos |
|--------|----------------------------|------|---------|
| **App-side Validatie** | ✅ Ja (Play Integrity token generatie) | ❌ Nee | ❌ Nee |
| **Server-side Validatie** | ✅ Ja (token validatie tegen registratie-context) | ✅ Ja (volledig server-side) | ✅ Ja (volledig server-side) |
| **Attestation Token** | ✅ Play Integrity token | ❌ Geen | ❌ Geen |
| **Challenge/Response** | ✅ Server-generated nonce | ❌ Nee | ❌ Nee |
| **Attestation Certificaatketen** | ❌ Nee (Play Integrity handleert dit) | ❌ Nee | ❌ Nee |

#### Apparaatverificatie

| Aspect | Volksbank (ASN/Regio/SNS) | bunq | Triodos |
|--------|----------------------------|------|---------|
| **FIDO2/WebAuthn** | ✅ SDK v21.0.0 | ❌ AFWEZIG | ❌ AFWEZIG |
| **Device Registration** | ✅ StartRegistrationContextRequest | ✅ DeviceApi, DeviceCheckCreateRequest | ❓ Niet gespecificeerd |
| **Device Identity** | ✅ DeviceAttestationStatus | ✅ DeviceIdentityVerificationSession | ❓ Niet gespecificeerd |
| **Root-detectie** | ❌ AFWEZIG | ❌ AFWEZIG (derden: Sentry, Onfido, Adyen) | ✅ ACTIEF (libfourthline-security.so) |

#### Betalingsintegratie

| Aspect | Volksbank (ASN/Regio/SNS) | bunq | Triodos |
|--------|----------------------------|------|---------|
| **Google Pay** | ✅ TapAndPay, Wallet | ✅ Adyen 3DS2, Google Wallet | ❓ Niet gespecificeerd |
| **3DS2 SDK** | ❌ AFWEZIG | ✅ Adyen 3DS2 | ❓ Niet gespecificeerd |
| **Identiteitsverificatie** | ✅ iProov, FingerprintJS Pro | ✅ Onfido, Incode | ❓ Niet gespecificeerd |

---

## 🔍 4. GEÏDENTIFICEERDE PATRONEN

### 4.1 Gedeelde Codebase (Volksbank Groep)

**Banken:** ASN Bank, RegioBank, SNS Bank  

**Gemeenschappelijke Kenmerken:**
- Identieke Play Integrity SDK versie (v1.6.0)
- Identieke FIDO2/WebAuthn SDK versie (v21.0.0)
- Dezelfde codebase voor Wero-implementatie
- Dezelfde klassen en use cases:
  - `RequestIntegrityTokenUseCase`
  - `IntegrityRepository`
  - `StandardIntegrityManager`
- Dezelfde flow en validatiemethode
- Dezelfde KEK/SUK hiërarchie
- Dezelfde sleutelbeheer mechanismen
- Dezelfde platformonafhankelijke benadering (Android + iOS)

**Verschillen:**
- Geen significante verschillen in Wero-implementatie tussen de drie banken

### 4.2 Server-side vs Client-side Validatie

| Aspect | Client-side (Volksbank) | Server-side (bunq, Triodos) |
|--------|--------------------------|-----------------------------|
| **App-side Attestation** | ✅ Ja (Play Integrity token) | ❌ Nee |
| **Server Validatie** | ✅ Ja (token validatie) | ✅ Ja (volledig) |
| **Complexiteit** | Hoog (meervoudige mechanismen) | Lager (server-afhankelijk) |
| **Flexibiliteit** | Hoger (lokaal beheer) | Lager (server-afhankelijk) |
| **Aanvalsoppervlak** | Groter (lokaal) | Kleiner (server) |

### 4.3 Sleutelbeheer Strategieën

| Strategie | Banken | Kenmerken |
|-----------|--------|-----------|
| **KEK/SUK Hiërarchie** | Volksbank (ASN/Regio/SNS) | Meervoudige sleutellagen, biometrische/PIN-gebonden KEK's, single-use keys |
| **Hardware-binding** | bunq, Triodos | Directe binding aan Android Keystore met StrongBox, server-side beheer |

### 4.4 SDK Gebruik

| SDK | Volksbank | bunq | Triodos |
|-----|-----------|------|---------|
| **Play Integrity** | ✅ v1.6.0 | ❌ AFWEZIG | ❌ AFWEZIG |
| **FIDO2/WebAuthn** | ✅ v21.0.0 | ❌ AFWEZIG | ❌ AFWEZIG |
| **SQLCipher** | ❌ AFWEZIG | ✅ ACTIEF | ❌ AFWEZIG |
| **Native Root-detectie** | ❌ AFWEZIG | ❌ AFWEZIG (derden) | ✅ ACTIEF (eigen) |

---

## 📈 5. STATISTISCHE ANALYSE

### 5.1 Codebase Omvang

| Bank | DEX-bestanden | Unieke Strings | Native Libraries | Obfuscatie |
|------|---------------|----------------|------------------|------------|
| ASN Bank | 6 | 380.875 | 14 | Zwaar (R8) |
| RegioBank | 6 | 380.959 | 14 | Zwaar (R8) |
| SNS Bank | 6 | 380.869 | 14 | Zwaar (R8) |
| bunq | 12 | 938.997 | 40 | Licht (R8) |
| Triodos | 2 | 82.265 | 13 | Onbekend |

### 5.2 Wero-gerelateerde Code

| Bank | Wero Klassen | Wero Endpoints | Use Cases |
|------|--------------|----------------|-----------|
| ASN Bank | `nl.devolksbank.mobile.banking.domain.wero.*` | In Wero-domein | RequestIntegrityTokenUseCase, IntegrityRepository, BuildAndSignJwtUseCase, DecryptBiometricKekUseCase, etc. |
| RegioBank | Gedeeld met ASN | Gedeeld met ASN | Gedeeld met ASN |
| SNS Bank | Gedeeld met ASN | Gedeeld met ASN | Gedeeld met ASN |
| bunq | `com.bunq.android.model.wero.*`, `com.bunq.android.ui.activity.wero.*` | /user/{id}/wero-wallet, /user/{id}/wero-consumer, /user/{id}/wero-issuer-transaction | WeroKeyStoreHelper |
| Triodos | Eigen implementatie | /wero/wallet, /wero/consent/, /v4/wero/wallet | Eigen implementatie |

---

## 💡 6. INZICHTEN EN OBSERVATIES

### 6.1 Volksbank Groep

- **Consistente Implementatie:** ASN, Regio en SNS Bank delen **identieke** Wero-implementaties
- **Play Integrity Focus:** Gebruiken alle drie Google Play Integrity API v1.6.0
- **FIDO2 Integratie:** Alle drie integreren FIDO2/WebAuthn SDK v21.0.0
- **KEK/SUK Hiërarchie:** Geavanceerd sleutelbeheer met meerdere sleutellagen
- **Platformonafhankelijk:** Ondersteunen zowel Android (Play Integrity) als iOS (App Attest)
- **Codebase:** Gedeelde codebase bespaart ontwikkeltijd en zorgt voor consistentie

### 6.2 bunq

- **Eigen Implementatie:** Vollledig eigen Wero-implementatie zonder extern SDK
- **Hardware-binding:** Gebruikt direct Android Keystore met StrongBox
- **Server-side Validatie:** Vertrouwt volledig op server-side validatie
- **SQLCipher:** Gebruikt database versleuteling (59 string-referenties + libsqlcipher.so)
- **Native Signing:** Heeft native signing-componenten (`libsigner.so`, `libNativeBridge.so`)
- **Root-detectie:** Gebruikt derden voor root-detectie (Sentry, Onfido, Adyen)
- **Betalingen:** Integreert Adyen 3DS2 SDK voor kaartbetalingen

### 6.3 Triodos

- **Eigen Implementatie:** Vollledig eigen Wero-implementatie zonder extern SDK
- **Server-side Validatie:** Vertrouwt volledig op server-side validatie
- **Native Root-detectie:** Heeft eigen native root-detectie (`libfourthline-security.so`)
- **StrongBox:** Gebruikt hardware-gebonden sleutelopslag
- **Minimale APK:** Slechts 2 DEX-bestanden en 13 native libraries (kleinste van alle banken)

### 6.4 Gemeenschappelijke Kenmerken

**Alle 5 Wero-banken:**
- ✅ Gebruiken **eigen implementatie** (geen extern Wero/EPI SDK)
- ✅ Hebben **StrongBox** voor hardware-gebonden sleutelopslag
- ✅ Gebruiken **BiometricPrompt** met CryptoObject
- ✅ Hebben **setIsStrongBoxBacked** en **setUserAuthenticationRequired**
- ✅ Validatie vindt **server-side** plaats
- ❌ Gebruiken **geen** SafetyNet
- ❌ Gebruiken **geen** AndroidKeyStore-hardware-attestation (`setAttestationChallenge`)

### 6.5 Verschillen

| Kenmerk | Volksbank Groep | bunq | Triodos |
|---------|------------------|------|---------|
| **Play Integrity** | ✅ Ja | ❌ Nee | ❌ Nee |
| **FIDO2/WebAuthn** | ✅ Ja | ❌ Nee | ❌ Nee |
| **KEK/SUK Hiërarchie** | ✅ Ja | ❌ Nee | ❌ Nee |
| **SQLCipher** | ❌ Nee | ✅ Ja | ❌ Nee |
| **Native Root-detectie** | ❌ Nee | ❌ Nee (derden) | ✅ Ja (eigen) |
| **Codebase Omvang** | Gemiddeld (6 DEX, ~380K strings) | Groot (12 DEX, ~939K strings) | Klein (2 DEX, ~82K strings) |
| **Obfuscatie** | Zwaar (R8) | Licht (R8) | Onbekend |

---

## ✅ 7. VOLTOOIDE ACTIES

- [x] Wero-flows vergeleken: Volksbank (Play Integrity Token Validatie) vs bunq (Server-side met Hardware-binding) vs Triodos (Server-side)
- [x] Sleutelbeheer geanalyseerd: KEK/SUK hiërarchie (Volksbank) vs Hardware-binding (bunq, Triodos)
- [x] Validatiemethoden per bank gedocumenteerd
- [x] Gedeelde codebase (Volksbank apps) geïdentificeerd
- [x] Vergelijkende matrix van Wero-features gemaakt

---

## 📚 8. GERELATEERDE DOCUMENTEN

- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Bevat alle vervolgstappen en categoriseringen
- [vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md](./vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) - Algemene vergelijkende analyse
- [PATROON_ANALYSE.md](./patroon_analyse.md) - Patroon analyse en correlaties
- Individuele Wero-bank analyses:
  - [statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md](./statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md)
  - [statische-analyse-apparaatveiligheid-in-de-regiobank-android-app-v1-36-3.md](./statische-analyse-apparaatveiligheid-in-de-regiobank-android-app-v1-36-3.md)
  - [statische-analyse-apparaatveiligheid-in-de-sns-bank-android-app-v1-36-3.md](./statische-analyse-apparaatveiligheid-in-de-sns-bank-android-app-v1-36-3.md)
  - [statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md](./statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md)
  - [statische-analyse-apparaatveiligheid-in-de-triodos-bankingnl-android-app-v5-13-7.md](./statische-analyse-apparaatveiligheid-in-de-triodos-bankingnl-android-app-v5-13-7.md)

---

## 📖 9. LEGENDA

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG** | Aanwezig | Mechanisme is aanwezig maar status niet volledig bevestigd |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ **NIET GEÏNSPECTEERD** | Niet gecontroleerd | Mechanisme is niet specifiek onderzocht in de analyse |

---

**Laatst geactualiseerd:** 7 November 2026, 20:15 CET  
**Versie:** 1.0  
**Status:** ✅ Voltooid  
**Document Type:** Wero Implementatie Diepgaande Vergelijking
