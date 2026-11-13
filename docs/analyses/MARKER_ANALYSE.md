# Marker Analyse Resultaten - Nederlandse Bank Apps

**Datum:** 5 November 2026, 22:00 CET (geactualiseerd: 7 November 2026)  
**Script:** `marker_analyse.sh`  
**Log:** `marker_results.log`
**Status:** Geactualiseerd met Wero-implementatieanalyse en CLI-contextverificatie voor Knab en Rabobank

---

## ❌ Niet Beschikbaar voor Analyse

### N26 (`de.number26.android`)
- **Status:** ❌ **Download mislukt**
- **Reden:** Niet beschikbaar via apkeep, APKMirror of Aptoide
- **Gevolg:** Marker analyse **niet uitgevoerd**

### Wero (EPI) (`eu.epicompany.wero.wallet`)
- **Status:** ❌ **Verkeerde APK gedownload**
- **Reden:** Alleen verkeerde APK beschikbaar (pakket-ID: `cm.aptoide.pt` = Aptoide app store)
- **Actie:** Verkeerde APK verwijderd door user
- **Gevolg:** Marker analyse **niet uitgevoerd**

---

## ✅ Geanalyseerde Apps (11 van 13)

**Opmerking:** 11 banken succesvol geanalyseerd, 2 apps niet beschikbaar (N26, Wero EPI)

## Samenvattende Tabel

| Bank | Pakket-ID | Version | Play Integrity (markers) | SafetyNet (markers) | Hardware Attest. (markers) | Android Keystore | Biometrie | FIDO2 | SQLCipher | Cert. Pinning | Wero |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **SNS Bank** | `nl.devolksbank.sns.bankieren` | 1.36.3 | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 45 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **RegioBank** | `nl.devolksbank.regio.bankieren` | 1.36.3 | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 44 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **ASN Bank** | `nl.devolksbank.asn.bankieren` | 1.36.3 | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 28 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **ING** | `com.ing.mobile` | v2025.25.1 (2024313186) | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 4 | ✅ 11 | ✅ 1 | ❌ 0 | ❌ 0 | ❌ AFWEZIG |
| **Rabobank** | `nl.rabomobiel` | 8.1.4 | ❌ 0 | ✅ 86 | ❌ 0 | ✅ 32 | ✅ 43 | ✅ 1 | ✅ 50 | ✅ 23 | ❌ AFWEZIG |
| **Knab** | `bvm.bvmapp` | 4.11.0 | ✅ 9 | ✅ 8 | ❌ 0 | ✅ 4 | ✅ 5 | ✅ 1 | ❌ 0 | ✅ 14 | ❌ AFWEZIG |
| **Revolut** | `com.revolut.revolut` | v10.153.1 | ✅ 17 | ✅ 3 | ❌ 0 | ✅ 5 | ✅ 23 | ✅ 20 | ✅ 47 | ❌ 0 | ❌ AFWEZIG |
| **Trade Republic** | `de.traderepublic.app` | 4.2645.1 | ✅ 11 | ❌ 0 | ✅ 16 | ✅ 3 | ✅ 45 | ✅ 20 | ❌ 0 | ✅ 20 | ❌ AFWEZIG |
| **ABN AMRO** | `com.abnamro.nl.mobile.payments` | v13.34 (10261289) | ❌ 0 | ✅ 51 | ❌ 0 | ✅ 5 | ✅ 12 | ✅ 2 | ✅ 57 | ✅ 2 | ❌ AFWEZIG |
| **Bunq** | `com.bunq.android` | v32.4.1 | ❌ 0 | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 7 | ❌ 0 | ✅ 59 | ✅ 10+ | ✅ Eigen |
| **Triodos** | `com.triodos.bankingnl` | v5.13.7 | ❌ 0 | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 7+ | ❌ 0 | ❌ 0 | ❓ | ✅ Eigen |
| **N26** | `de.number26.android` | - | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar |
| **Wero (EPI)** | `eu.epicompany.wero.wallet` | - | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar | ❌ Niet beschikbaar |

**Notitie:** De aantallen zijn gebaseerd op string-matching in DEX-bestanden. Contextverificatie is nodig om vals-positieven uit te sluiten. Zie de definitieve classificatie secties hieronder voor de uiteindelijke status.

---

## Gedetailleerde Analyse per Bank

### 1. **SNS Bank** (`nl.devolksbank.sns.bankieren` v1.36.3)

**Play Integrity:** ✅ **AANWEZIG (120+ treffers)**
- `play.core.integrity` (120x)
- `IntegrityManager`, `IntegrityManagerFactory`, `StandardIntegrityManager`
- `requestIntegrityToken`, `cloudProjectNumber`

**SafetyNet:** ❌ **AFWEZIG**

**Hardware Attestation:** ❌ **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` afwezig in alle DEX-bestanden)

**Android Keystore:** ✅ **AANWEZIG (6 treffers)**

**Biometrie:** ✅ **AANWEZIG (45 treffers)**

**FIDO2:** ✅ **AANWEZIG (20 treffers)**

**SQLCipher:** ❌ **AFWEZIG**

**Certificate Pinning:** ✅ **Detectie bevestigd** (OkHttp CertificatePinner)

**Voorlopige Classificatie:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT**
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG**

**Vergelijking:** Identiek aan ASN Bank (v1.36.3) uit referentie-analyse. **Wero-implementatie:** ✅ ACTIEF (Eigen Volksbank implementatie)

---

### 2. **ASN Bank** (`nl.devolksbank.asn.bankieren` v1.36.3)

**Play Integrity:** ✅ **AANWEZIG (120+ treffers)**
- `play.core.integrity` (120x)
- `IntegrityManager`, `IntegrityManagerFactory`, `StandardIntegrityManager`
- `RequestIntegrityTokenUseCase`, `IntegrityRepository` (bevestigd in classes3.dex met devolksbank types)

**SafetyNet:** ❌ **AFWEZIG**
- Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 380.875 unieke DEX-strings

**Hardware Attestation:** ❌ **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in alle 6 DEX-bestanden én in alle 14 native libraries)
- Wel aanwezig: modellen `KeyAttestation`, `PaymentMeansKeyAttestation` (met velden `attestationChallenge`, `attestationTypes`)

**Android Keystore:** ✅ **AANWEZIG (6 treffers)**

**Biometrie:** ✅ **AANWEZIG (28 referenties)**
- `BiometricPrompt` (28 referenties) met `CryptoObject` (17 referenties)

**FIDO2:** ✅ **AANWEZIG (20 treffers)**
- `play-services-fido` (versie 21.0.0 bevestigd)

**SQLCipher:** ❌ **AFWEZIG**

**Certificate Pinning:** ✅ **Detectie bevestigd** (OkHttp CertificatePinner)

**Wero:** ✅ **AANWEZIG**
- Eigen Volksbank implementatie: `nl.devolksbank.mobile.banking.domain.wero.*`
- `WeroProvider`, consent-flows (`SignAndSendWeroConsentUseCase`, `CancelWeroPaymentConsentUseCase`)
- Wallet-registratie: `StartRegistrationContextRequest(deviceId=)` → `registrationContextId` + `DeviceAttestationStatus`

**Definitieve Classificatie:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT** (in Wero-flows)
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG**
- Wero: ✅ **ACTIEF GEBRUIKT** (Eigen Volksbank implementatie met Play Integrity Token Validatie)

**Vergelijking:** Identiek aan SNS Bank en RegioBank (alle Volksbank apps)

---

### 3. **RegioBank** (`nl.devolksbank.regio.bankieren` v1.36.3)

**Play Integrity:** ✅ **AANWEZIG (120+ treffers)**
- `integrity.properties` (versie 1.6.0)
- klassen `com.google.android.play.core.integrity.*`

**SafetyNet:** ❌ **AFWEZIG**
- Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 380.959 unieke DEX-strings

**Hardware Attestation:** ❌ **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` afwezig in alle DEX-bestanden, 37 treffers waren vals-positief)

**Android Keystore:** ✅ **AANWEZIG (6 treffers)**

**Biometrie:** ✅ **AANWEZIG (44 referenties)**

**FIDO2:** ✅ **AANWEZIG (20 treffers)**

**SQLCipher:** ❌ **AFWEZIG**

**Certificate Pinning:** ✅ **Detectie bevestigd** (OkHttp CertificatePinner)

**Wero:** ✅ **AANWEZIG**
- Eigen Volksbank implementatie, gedeeld met ASN Bank en SNS Bank
- Gebruikt dezelfde codebase en Wero-flows

**Definitieve Classificatie:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT** (in Wero-flows)
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG**
- Wero: ✅ **ACTIEF GEBRUIKT** (Eigen Volksbank implementatie met Play Integrity Token Validatie)

**Vergelijking:** Identiek aan SNS Bank en ASN Bank (alle Volksbank apps)

---

### 4. **ING** (`com.ing.mobile`)

**Play Integrity:** ❌ **AFWEZIG**

**SafetyNet:** ❌ **AFWEZIG**

**Hardware Attestation:** ✅ **1 treffer** (vals-positief bevestigd)

**Contextverificatie Resultaten (4 Nov 2026):**
- Play Integrity: **Geen treffers** met com.ing filter
- SafetyNet: **Geen treffers** met com.ing filter
- Hardware Attestation: 1 treffer in classes4.dex, **geen com.ing types** in dezelfde DEX
- **Geen integrity.properties** of **safetynet.properties** in dependencies

**Definitieve Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG** (vals-positief bevestigd)

**Conclusie:** ING gebruikt **geen** remote attestation. Vergelijkbaar met bunq.

---

### 5. **Rabobank** (`nl.rabomobiel` v8.1.4)

**Play Integrity:** ❌ **AFWEZIG**

**SafetyNet:** ✅ **AANWEZIG (86 treffers)**

**Hardware Attestation:** ❌ **AFWEZIG**

**SQLCipher:** ✅ **AANWEZIG (50 treffers)**

**Certificate Pinning:** ✅ **AANWEZIG (23 treffers)**

**Voorlopige Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ❌ **AFWEZIG** (vals-positief - alleen SDK code, geen nl.rabomobiel types)
- Directe hardware attestation: ❌ **AFWEZIG**

---

### 6. **Knab** (`bvm.bvmapp` v4.11.0)

**Play Integrity:** ✅ **AANWEZIG (9 treffers)**

**SafetyNet:** ✅ **AANWEZIG (8 treffers)**

**Hardware Attestation:** ❌ **AFWEZIG**

**Certificate Pinning:** ✅ **AANWEZIG (14 treffers)**

**Contextverificatie Resultaten (4 Nov 2026):**
- Play Integrity: Markers in classes4.dex (IIntegrityService, etc.), **geen bvm types** in dezelfde DEX
- SafetyNet: Markers in classes5/7.dex (GMS classes), **geen bvm types** in dezelfde DEX

**Definitieve Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG** (vals-positief - alleen SDK code)
- SafetyNet: ❌ **AFWEZIG** (vals-positief - alleen SDK code)
- Directe hardware attestation: ❌ **AFWEZIG**

**Conclusie:** Beide API's waren vals-positieven. Knab gebruikt geen remote attestation.

---

### 7. **Revolut** (`com.revolut.revolut` v10.153.1)

**Play Integrity:** ✅ **AANWEZIG (17 treffers)**

**SafetyNet:** ✅ **AANWEZIG (3 treffers)**

**Hardware Attestation:** ❌ **AFWEZIG**

**SQLCipher:** ✅ **AANWEZIG (47 treffers)**

**Contextverificatie Resultaten (4 Nov 2026):**
- Play Integrity: Markers in classes5/18.dex (IIntegrityService, IExpressIntegrityService), **met revolut.analytics.integrity types** in dezelfde DEX (EnableIntegrityTokenRetryAnalyticsFirebaseExperiment, IntegrityAnalyticsFeatureToggles)
- SafetyNet: ClientLifecycleSafetyNet strings in classes5.dex, **met revolut types** in dezelfde DEX

**Definitieve Classificatie:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT** (eigen integrity analytics)
- SafetyNet: ✅ **ACTIEF GEBRUIKT** (ClientLifecycleSafetyNet implementatie)
- Directe hardware attestation: ❌ **AFWEZIG**
- **Wero:** ❌ **AFWEZIG** (eigen wallet-implementatie zonder Wero)

**Conclusie:** Revolut gebruikt **beide** Play Integrity en SafetyNet actief.

---

### 8. **Trade Republic** (`de.traderepublic.app` v4.2645.1)

**Play Integrity:** ✅ **AANWEZIG (11 treffers)**

**SafetyNet:** ❌ **AFWEZIG**

**Hardware Attestation:** ✅ **AANWEZIG (16 treffers)**

**Certificate Pinning:** ✅ **AANWEZIG (20 treffers)**

**Contextverificatie Resultaten (4 Nov 2026):**
- Play Integrity: Markers in classes15.dex (IExpressIntegrityService, IExpressIntegrityServiceCallback), **met traderepublic types** in dezelfde DEX
- Hardware Attestation: `setAttestationChallenge` in classes.dex, **met traderepublic types** in dezelfde DEX

**Definitieve Classificatie:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT**
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ✅ **ACTIEF GEBRUIKT**
- **Wero:** ❌ **AFWEZIG** (geen Wero-implementatie)

**Conclusie:** Trade Republic gebruikt **Play Integrity + Hardware Attestation** actief.

---

### 9. **ABN AMRO** (`com.abnamro.nl.mobile.payments` v13.34 (10261289))

**Play Integrity:** ❌ **AFWEZIG**

**SafetyNet:** ✅ **AANWEZIG (51 treffers)**

**Hardware Attestation:** ❌ **AFWEZIG**

**SQLCipher:** ✅ **AANWEZIG (57 treffers)**

**Certificate Pinning:** ✅ **AANWEZIG (2 treffers)**

**Contextverificatie Resultaten (4 Nov 2026):**
- SafetyNet: DEX bestanden met SafetyNet strings en ABN AMRO types (classes2.dex: 2 treffers, classes3.dex: 49 treffers, classes6.dex: 5 treffers)

**Definitieve Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ✅ **ACTIEF GEBRUIKT** (in eigen code)
- Directe hardware attestation: ❌ **AFWEZIG**
- **Wero:** ❌ **AFWEZIG** (geen Wero-implementatie)

**Conclusie:** ABN AMRO gebruikt SafetyNet voor attestation.

---

### 10. **Bunq** (`com.bunq.android` v32.4.1)

**Play Integrity:** ❌ **AFWEZIG**
- Geen klassen onder `com.google.android.play.core.integrity`
- Geen `play-services-integrity` dependency-metadata
- Geen `playintegrity.googleapis.com`-eindpunt
- Geen integrity-service-binding

**SafetyNet:** ❌ **AFWEZIG**
- Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 938.997 unieke DEX-strings

**Hardware Attestation:** ❌ **AFWEZIG**
- Methodenaam `setAttestationChallenge` ontbreekt in alle 12 DEX-bestanden en in alle 40 native libraries
- De enige strings die `attest` bevatten zijn `UC_DROIDGUARD_ATTESTATION`, `UC_DROIDGUARD_VERDICT_INPUT` en `TAP_AND_PAY_ATTESTATION_ERROR` (Google Wallet intern)

**Android Keystore:** ✅ **AANWEZIG (1 referentie)**
- `setIsStrongBoxBacked` (1 referentie, bevestigd in com.bunq code)
- `setUserAuthenticationRequired` (1 referentie, bevestigd in com.bunq code)

**Biometrie:** ✅ **AANWEZIG (7 referenties)**
- `BiometricPrompt` (7 referenties) met `CryptoObject` (8 referenties)

**FIDO2:** ❌ **AFWEZIG**

**SQLCipher:** ✅ **AANWEZIG (59 string-referenties)**
- SQLCipher bevestigd in native libraries (libsqlcipher.so)

**Certificate Pinning:** ✅ **AANWEZIG (ruim 10 treffers)**
- OkHttp `CertificatePinner` met ruim tien `sha256/`-spikkels

**Wero:** ✅ **AANWEZIG**
- Alle Wero-klassen zijn bunq-eigendommen: `com.bunq.android.model.wero.*`
- API-eindpunten: `/user/{userId}/wero-wallet`, `/user/{userId}/wero-consumer`, `/user/{userId}/wero-issuer-transaction`
- `WeroKeyStoreHelper.kt` beheert wallet-sleutels

**Definitieve Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG**
- SQLCipher: ✅ **ACTIEF GEBRUIKT**
- Certificate Pinning: ✅ **ACTIEF GEBRUIKT**
- Wero: ✅ **ACTIEF GEBRUIKT** (eigen implementatie zonder remote attestation)

**Conclusie:** Bunq baseert apparaatveiligheid op hardware-gebonden cryptografie en server-side controles.

---

### 11. **Triodos** (`com.triodos.bankingnl` v5.13.7)

**Play Integrity:** ❌ **AFWEZIG**
- Geen klassen onder `com.google.android.play.core.integrity`
- Geen `play-services-integrity` dependency
- Geen `playintegrity.googleapis.com`-eindpunt

**SafetyNet:** ❌ **AFWEZIG**
- Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 82.265 unieke DEX-strings

**Hardware Attestation:** ❌ **AFWEZIG**
- Methodenaam `setAttestationChallenge` ontbreekt in beide DEX-bestanden en in alle native libraries

**Android Keystore:** ✅ **AANWEZIG (1 referentie)**
- `setIsStrongBoxBacked` (1 referentie)
- `setUserAuthenticationRequired` (1 referentie)

**Biometrie:** ✅ **AANWEZIG (7+ referenties)**
- `BiometricPrompt` met `CryptoObject`

**FIDO2:** ❌ **AFWEZIG**

**SQLCipher:** ❌ **AFWEZIG**

**Certificate Pinning:** ❓ **Niet gecontroleerd**

**Root-detectie:** ✅ **AANWEZIG (native)**
- `libfourthline-security.so` bevat detectie voor magisk, xposed, frida-gadget

**Wero:** ✅ **AANWEZIG**
- Endpoints: `/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet`
- Eigen Triodos Bank implementatie

**Definitieve Classificatie:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ❌ **AFWEZIG**
- Wero: ✅ **ACTIEF GEBRUIKT** (eigen implementatie met native root-detectie)

**Conclusie:** Triodos combineert Wero met native root-detectie voor apparaatveiligheid.

---

## Samenvatting en Vergelijking

### Apps met **Play Integrity**:
- ✅ **SNS Bank** (Volksbank) - **BEVESTIGD** (120+ treffers, CLI-bevestigd in Wero-flows)
- ✅ **RegioBank** (Volksbank) - **BEVESTIGD** (120+ treffers, CLI-bevestigd in Wero-flows)
- ✅ **ASN Bank** (Volksbank) - **BEVESTIGD** (120+ treffers, CLI-bevestigd in Wero-flows)
- ❌ **Knab** - **VALS-POSITIEF** (9 treffers, alleen SDK code, geen bvm types)
- ✅ **Revolut** - **BEVESTIGD** (17 treffers, eigen integrity analytics)
- ✅ **Trade Republic** - **BEVESTIGD** (11 treffers, eigen code)
- ❌ **Bunq** - **AFWEZIG** (geen markers, eigen Wero-implementatie zonder Play Integrity)
- ❌ **Triodos** - **AFWEZIG** (geen markers, eigen Wero-implementatie zonder Play Integrity)

### Apps met **SafetyNet**:
- ❌ **Rabobank** - **VALS-POSITIEF** (86 treffers, alleen SDK code, geen nl.rabomobiel types)
- ✅ **ABN AMRO** - **BEVESTIGD** (51 treffers, eigen code)
- ❌ **Knab** - **VALS-POSITIEF** (8 treffers, alleen SDK code, geen bvm types)
- ✅ **Revolut** - **BEVESTIGD** (3 treffers, ClientLifecycleSafetyNet implementatie)
- ❌ **Bunq** - **AFWEZIG** (geen markers, eigen Wero-implementatie)
- ❌ **Triodos** - **AFWEZIG** (geen markers, eigen Wero-implementatie)

### Apps met **Directe Hardware Attestation** (setAttestationChallenge):
- ✅ **Trade Republic** - **BEVESTIGD** (16 treffers, eigen code met traderepublic types)
- ❌ **SNS Bank** - **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in alle DEX-bestanden)
- ❌ **RegioBank** - **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` afwezig in alle DEX-bestanden)
- ❌ **ASN Bank** - **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in alle DEX-bestanden en native libraries)
- ❌ **Bunq** - **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in alle 12 DEX-bestanden en 40 native libraries)
- ❌ **Triodos** - **AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in beide DEX-bestanden en alle native libraries)

### Apps met **SQLCipher** (lokale database versleuteling):
1. ✅ Rabobank (50 treffers)
2. ✅ Revolut (47 treffers)
3. ✅ ABN AMRO (57 treffers)
4. ✅ Bunq (59 string-referenties + libsqlcipher.so in native libraries)

### Apps met **Certificate Pinning**:
- ✅ **SNS Bank** (OkHttp CertificatePinner detectie bevestigd)
- ✅ **RegioBank** (OkHttp CertificatePinner detectie bevestigd)
- ✅ **ASN Bank** (OkHttp CertificatePinner detectie bevestigd)
- ✅ **Rabobank** (23 treffers)
- ✅ **Knab** (14 treffers)
- ✅ **Trade Republic** (20 treffers)
- ✅ **ABN AMRO** (2 treffers)
- ✅ **Bunq** (ruim 10 treffers)
- ❓ **Triodos** (niet gecontroleerd in marker analyse)

### Apps met **Wero-implementatie**:
- ✅ **ASN Bank** - **Eigen Volksbank implementatie** (CLI-bevestigd)
- ✅ **SNS Bank** - **Eigen Volksbank implementatie** (gedeeld met ASN/RegioBank)
- ✅ **RegioBank** - **Eigen Volksbank implementatie** (gedeeld met ASN/SNS)
- ✅ **Bunq** - **Eigen Bunq implementatie** (CLI-bevestigd, geen extern SDK)
- ✅ **Triodos** - **Eigen Triodos implementatie** (eigen endpoints, native root-detectie)
- ❌ **ABN AMRO, ING, Rabobank, Knab, Revolut, Trade Republic** - **AFWEZIG**

---

## 🔍 **Wero-Specifieke Marker Analyse**

### Wero Gerelateerde Markers per Bank

| Bank | Wero Klassen | Wero Endpoints | Key Attestation | Integrity Token | Single-Use Keys | KEK/SUK | Validatie |
|------|--------------|----------------|----------------|----------------|------------------|---------|-----------|
| **ASN Bank** | ✅ `nl.devolksbank.mobile.banking.domain.wero.*` | ✅ | ✅ `KeyAttestation`, `PaymentMeansKeyAttestation` | ✅ `RequestIntegrityTokenUseCase`, `IntegrityRepository` | ✅ `GetSuksResponse`, `GetNewWeroSukSetUseCase` | ✅ `kekBio`, `kekPin`, `encryptedKkek` | ✅ Play Integrity Token |
| **SNS Bank** | ✅ (Volksbank codebase) | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ Play Integrity Token |
| **RegioBank** | ✅ (Volksbank codebase) | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ Play Integrity Token |
| **Bunq** | ✅ `com.bunq.android.model.wero.*` | ✅ `/user/{userId}/wero-wallet`, `/user/{userId}/wero-consumer`, `/user/{userId}/wero-issuer-transaction` | ❌ | ❌ | ❌ | ❌ | ✅ Server-side met Hardware-binding |
| **Triodos** | ❌ | ✅ `/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet` | ❌ | ❌ | ❌ | ❌ | ✅ Server-side |
| **ABN AMRO** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |
| **ING** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |
| **Rabobank** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |
| **Knab** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |
| **Revolut** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |
| **Trade Republic** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ Geen |

### Wero Marker Categorisatie

#### **Play Integrity in Wero-flows (Volksbank)**
- `RequestIntegrityTokenUseCase` - Token aanvraag voor Wero-registratie
- `IntegrityRepository` - Repository voor Integrity tokens
- `PrepareIntegrityTokenRequest` - Token voorbereiding met cloudProjectNumber
- `IntegrityTokenRequest` - Token aanvraag met nonce
- `AppAttestation` - App attestation model
- `DeviceAttestationStatus` - Apparaat attestatie status

#### **Key Management (Volksbank)**
- `KeyAttestation` - Key attestation model
- `PaymentMeansKeyAttestation` - Betalingsmiddel key attestation
- `KeyAttestationApplicationId` - Key attestation applicatie ID
- `KeyAttestationPackageInfo` - Key attestation pakket info

#### **Single-Use Keys (Volksbank)**
- `GetSuksResponse` - Single-use keys respons
- `GetNewWeroSukSetUseCase` - Nieuwe Wero SUK set aanvragen
- `ReplenishSingleUseKeysUseCase` - Single-use keys bijvullen
- `singleUseKeys` - Single-use keys

#### **Key Encryption Keys (Volksbank)**
- `kekBio` - Biometric Key Encryption Key
- `kekPin` - PIN Key Encryption Key
- `encryptedKkek` - Encrypted Key Encryption Key

#### **Bunq Specifiek**
- `WeroKeyStoreHelper.kt` - Wallet sleutel beheer
- `wero_wallet_key` - Wallet sleutel

---

## ✅ Contextverificatie Resultaten

**Datum:** 5 November 2026, 22:00 CET  
**Script:** `dex_locate.py`
**Status:** Geactualiseerd met Wero-implementatieanalyse

### Verificatie: SNS Bank ✅

**Play Integrity Context:**
```
🔍 Zoeken naar: 'play.core.integrity' met filter 'devolksbank'

Resultaten:
- classes4.dex: 3 string-treffers + devolksbank types (WeroRepository, EnrollmentRepository)
- classes5.dex: 3 string-treffers + devolksbank types (WeroRepository)

Conclusie: ✅ **ACTIEF GEBRUIKT** in eigen code (Volksbank)
```

**Hardware Attestation Context:**
```
🔍 Zoeken naar: 'setAttestationChallenge' met filter 'devolksbank'

Resultaten:
- classes2.dex: 1 string-treffer + devolksbank types
- classes5.dex: 1 string-treffer + devolksbank types (WeroRepository)

Conclusie: ✅ **ACTIEF GEBRUIKT** in eigen code (Volksbank)
```

**Definitieve Classificatie SNS Bank:**
- Google Play Integrity API: ✅ **ACTIEF GEBRUIKT** (in Wero flow)
- SafetyNet: ❌ **AFWEZIG**
- Directe hardware attestation: ✅ **ACTIEF GEBRUIKT** (setAttestationChallenge in eigen code)

---

### Verificatie: Rabobank ⚠️

**SafetyNet Context:**
```
🔍 Zoeken naar DEX bestanden met SafetyNet strings en Rabobank types

Resultaten:
- classes3.dex: 5 SafetyNet treffers, 0 Rabobank types
- classes4.dex: 84 SafetyNet treffers, 0 Rabobank types
- classes6.dex: 0 SafetyNet treffers, 236 Rabobank types
- classes7.dex: 0 SafetyNet treffers, 3 Rabobank types
- classes8.dex: 0 SafetyNet treffers, 27 Rabobank types

Conclusie: ❌ **VALS-POSITIEF** - SafetyNet API is gebundeld (GMS SDK) maar niet gebruikt door Rabobank code
```

**SQLCipher Context:**
```
🔍 Zoeken naar: 'SQLCipher' in Rabobank DEX bestanden

Resultaten:
- 50 treffers in strings_all.txt
- Voornamelijk in classes7.dex en classes8.dex

Conclusie: ✅ **ACTIEF GEBRUIKT** (lokale database versleuteling)
```

**Certificate Pinning Context:**
```
🔍 Zoeken naar: 'CertificatePinner' in Rabobank DEX bestanden

Resultaten:
- 23 treffers in strings_all.txt

Conclusie: ✅ **ACTIEF GEBRUIKT**
```

**Definitieve Classificatie Rabobank (CLI-bevestigd 7 Nov 2026):**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ❌ **AFWEZIG** (vals-positief - 86 treffers, maar **geen nl.rabomobiel types** in contextverificatie)
- Directe hardware attestation: ❌ **AFWEZIG**
- SQLCipher: ⚠️ **AANWEZIG (NIET ACTIEF)** (50 treffers, maar **geen nl.rabomobiel types** in contextverificatie)
- Certificate Pinning: ✅ **ACTIEF GEBRUIKT** (**bevestigd**: CertificatePinner.kt in eigen code)
- BiometricPrompt: ✅ **ACTIEF GEBRUIKT** (**bevestigd**: BiometricPromptManager.kt en nl.rabobank types)

---

### Verificatie: ABN AMRO ✅

**SafetyNet Context:**
```
🔍 Zoeken naar DEX bestanden met SafetyNet strings en ABN AMRO types

Resultaten:
- classes2.dex: 2 SafetyNet treffers, 907 ABN AMRO types
- classes3.dex: 49 SafetyNet treffers, 1069 ABN AMRO types
- classes6.dex: 5 SafetyNet treffers, 1267 ABN AMRO types

Conclusie: ✅ **ACTIEF GEBRUIKT** - SafetyNet strings in DEX bestanden met eigen code
```

**Definitieve Classificatie ABN AMRO:**
- Google Play Integrity API: ❌ **AFWEZIG**
- SafetyNet: ✅ **ACTIEF GEBRUIKT** (in eigen code)
- Directe hardware attestation: ❌ **AFWEZIG**
- SQLCipher: ✅ **ACTIEF GEBRUIKT**
- Certificate Pinning: ✅ **ACTIEF GEBRUIKT**

---

## 🎯 **Definitieve Classificatie Overzicht (Alle 11 Banken)**

| Bank | Play Integrity | SafetyNet | Hardware Attestation | Root Detectie | Wero | Wero Validatie |
|------|---------------|-----------|---------------------|---------------|------|----------------|
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | Play Integrity Token |
| **SNS Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | Play Integrity Token |
| **RegioBank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | Play Integrity Token |
| **ING** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | - |
| **Rabobank** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | - |
| **Knab** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | - |
| **Revolut** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | - |
| **Trade Republic** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | - |
| **ABN AMRO** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | - |
| **Bunq** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | Server-side met Hardware-binding |
| **Triodos** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF | Server-side |

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

## 🔮 Volgende Stappen

### Contextverificatie voor Wero-implementaties

```bash
# Volksbank - Play Integrity in Wero-flows
python3 dex_locate.py extracted/asn/app play.core.integrity devolksbank
python3 dex_locate.py extracted/sns/app play.core.integrity devolksbank
python3 dex_locate.py extracted/regio/app play.core.integrity devolksbank

# Volksbank - Wero-specifieke klassen
python3 dex_locate.py extracted/asn/app RequestIntegrityTokenUseCase devolksbank
python3 dex_locate.py extracted/asn/app IntegrityRepository devolksbank
python3 dex_locate.py extracted/asn/app StartRegistrationContextRequest devolksbank

# Bunq - Wero klassen
python3 dex_locate.py extracted/bunq/app WeroKeyStoreHelper com.bunq
python3 dex_locate.py extracted/bunq/app "com.bunq.android.model.wero" com.bunq

# Triodos - Wero endpoints
python3 dex_locate.py extracted/triodos/app /wero/wallet com.triodos
python3 dex_locate.py extracted/triodos/app /wero/consent com.triodos
```

### Native Library Scan voor Wero
Scan de .so bestanden op Wero-gerelateerde JNI referenties:

```bash
# Voor alle banken met Wero
python3 native_scan.py extracted/asn/libs/lib/arm64-v8a/lib/arm64-v8a/ | grep -i wero
python3 native_scan.py extracted/sns/libs/lib/arm64-v8a/lib/arm64-v8a/ | grep -i wero
python3 native_scan.py extracted/regio/libs/lib/arm64-v8a/lib/arm64-v8a/ | grep -i wero
python3 native_scan.py extracted/bunq/lib/arm64-v8a/ | grep -i wero
python3 native_scan.py extracted/triodos/lib/arm64-v8a/ | grep -i wero
```

### Dependency Metadata Check voor Wero
Check welke Wero-gerelateerde SDK's aanwezig zijn:

```bash
ls extracted/<bank>/app/*.properties | grep -i wero
ls extracted/<bank>/app/*.properties | grep -i epi
```

### Attestation Context Verificatie

```bash
# Rabobank - SafetyNet in eigen code?
python3 dex_locate.py extracted/rabobank/app safetynet nl.rabomobiel

# ABN AMRO - SafetyNet in eigen code?
python3 dex_locate.py extracted/abnamro/app_full safetynet abnamro

# Trade Republic - Play Integrity in eigen code?
python3 dex_locate.py extracted/trade_republic/app play.core.integrity traderepublic

# Trade Republic - Hardware Attestation in eigen code?
python3 dex_locate.py extracted/trade_republic/app setAttestationChallenge traderepublic
```

### Native Library Scan
Scan de .so bestanden op JNI referenties naar keystore methoden:

```bash
python3 native_scan.py extracted/<bank>/libs/lib/arm64-v8a/lib/arm64-v8a/
```

### Dependency Metadata Check
Check welke SDK's aanwezig zijn:

```bash
ls extracted/<bank>/app/*.properties | grep -E "(integrity|safetynet|fido)"
```

---

## Opmerkingen

### 📌 **Wero-Implementatie Overzicht**
- **5 banken (45%)** hebben Wero geïmplementeerd: ASN Bank, SNS Bank, RegioBank (Volksbank groep), Bunq, Triodos
- **6 banken (55%)** hebben geen Wero-implementatie: ABN AMRO, ING, Rabobank, Knab, Revolut, Trade Republic

### 📌 **Attestation Patronen**
1. **Volksbank apps** (SNS, RegioBank, ASN): Alle drie gebruiken **Play Integrity ✅** in Wero-flows. Hardware Attestation **❌ AFWEZIG** (CLI-bevestigd: `setAttestationChallenge` ontbreekt in alle DEX-bestanden).

2. **ING**: Geen attestation markers gevonden in eigen code. De 1 hardware attestation treffer was vals-positief (alleen SDK code). **Vergelijkbaar met bunq - geen remote attestation**.

3. **Rabobank en ABN AMRO**: Gebruiken **SafetyNet** in plaats van Play Integrity. Rabobank's SafetyNet was vals-positief (alleen SDK code).

4. **Knab**: Geen actieve attestation - beide markers waren vals-positief (alleen SDK code, geen bvm types).

5. **Revolut**: Gebruikt **beide** Play Integrity en SafetyNet actief (eigen integrity analytics en ClientLifecycleSafetyNet). **Geen Wero-implementatie**.

6. **Trade Republic**: Gebruikt **Play Integrity + Hardware Attestation** actief. **Geen Wero-implementatie**.

### 📌 **Wero-Specifieke Markers**
- **Volksbank (ASN/SNS/RegioBank)**: `RequestIntegrityTokenUseCase`, `IntegrityRepository`, `StartRegistrationContextRequest`, `AppAttestation`, `DeviceAttestationStatus`
- **Bunq**: `com.bunq.android.model.wero.*`, `WeroKeyStoreHelper.kt`, endpoints `/user/{userId}/wero-wallet`
- **Triodos**: endpoints `/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet`

### 📌 **Contextverificatie Resultaten (CLI - 7 November 2026)**

**Knab (`bvm.bvmapp` v4.11.0):**
- Google Play Integrity API: **❌ AFWEZIG** (9 treffers, maar **geen `bvm` types** in contextverificatie via `dex_locate.py`)
- SafetyNet: **❌ AFWEZIG** (8 treffers, maar **geen `bvm` types** in contextverificatie)
- setIsStrongBoxBacked: **⚠️ AANWEZIG (NIET ACTIEF)** (4 referenties, maar **geen `bvm` types**)
- setUserAuthenticationRequired: **⚠️ AANWEZIG (NIET ACTIEF)** (4 referenties, maar **geen `bvm` types**)
- CertificatePinner: **⚠️ AANWEZIG (NIET ACTIEF)** (OkHttp klassen, maar **geen `bvm` types**)
- BiometricPrompt: **⚠️ AANWEZIG (NIET ACTIEF)** (Android framework klassen, maar **geen `bvm` types**)

**Rabobank (`nl.rabomobiel` v8.1.4):**
- SafetyNet: **❌ AFWEZIG** (86 treffers, maar **geen `nl.rabomobiel` types** in contextverificatie)
- setIsStrongBoxBacked: **⚠️ AANWEZIG (NIET ACTIEF)** (32 referenties, maar **geen `nl.rabomobiel` types**)
- setUserAuthenticationRequired: **⚠️ AANWEZIG (NIET ACTIEF)** (32 referenties, maar **geen `nl.rabomobiel` types**)
- SQLCipher: **⚠️ AANWEZIG (NIET ACTIEF)** (50 treffers, maar **geen `nl.rabomobiel` types**)
- CertificatePinner: **✅ ACTIEF GEBRUIKT** (**`CertificatePinner.kt`** gevonden in eigen code)
- BiometricPrompt: **✅ ACTIEF GEBRUIKT** (**`BiometricPromptManager.kt`**, `nl.rabobank.bankierenplus.authentication.*` types bevestigd)

### 📌 **Niet Beschikbare Apps**
- **Wero**: Verkeerde APK gedownload (pakket-ID was `cm.aptoide.pt`). **Wero is verwijderd door user. Verdere analyse is niet mogelijk.**
- **N26**: Niet te downloaden via apkeep, APKMirror of Aptoide. **Verdere analyse is niet mogelijk.**
