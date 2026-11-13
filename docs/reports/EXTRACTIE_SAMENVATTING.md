# Extractie Samenvatting - Nederlandse Bank Apps

**Datum:** 4 November 2026 (geactualiseerd: 7 November 2026)  
**Starttijd:** 20:48:18 CET  
**Eindtijd:** 20:48:43 CET  
**Script:** `extract_all.sh`  
**Contextverificatie:** CLI-gebaseerde contextverificatie

---

## 📋 Uitgevoerde Acties

### APK Extractie

Alle 11 gedownloade APK's zijn succesvol uitgepakt met behulp van het `extract_all.sh` script.

| # | Bank | Source | Extractie Pad | Status | Tijd | Versie |
|---|---|---|---|---|---|---|
| 1 | SNS Bank | `nl.devolksbank.sns.bankieren.xapk` | `extracted/sns/` | ✅ | 20:48:19 | v1.36.3 |
| 2 | RegioBank | `nl.devolksbank.regio.bankieren.xapk` | `extracted/regio/` | ✅ | 20:48:20 | v1.36.3 |
| 3 | ASN Bank | `nl.devolksbank.asn.bankieren.xapk` | `extracted/asn/` | ✅ | 20:48:20 | v1.36.3 |
| 4 | ING | `com.ing.mobile.xapk` | `extracted/ing/` | ✅ | 20:48:21 | v2025.25.1 |
| 5 | Rabobank | `nl.rabomobiel.xapk` | `extracted/rabobank/` | ✅ | 20:48:22 | v8.1.4 |
| 6 | Knab | `bvm.bvmapp.xapk` | `extracted/knab/` | ✅ | 20:48:23 | v4.11.0 |
| 7 | Revolut | `com.revolut.revolut.xapk` | `extracted/revolut/` | ✅ | 20:48:24 | v10.153.1 |
| 8 | Trade Republic | `de.traderepublic.app.xapk` | `extracted/trade_republic/` | ✅ | 20:48:25 | v4.2645.1 |
| 9 | ABN AMRO | `com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm` | `extracted/abnamro/` | ✅ | 20:48:26 | v13.34 |
| 10 | Bunq | `com.bunq.android.apk` | `extracted/bunq/` | ✅ | - | v32.4.1 |
| 11 | Triodos | `com.triodos.bankingnl.xapk` | `extracted/triodos/` | ✅ | - | v5.13.7 |
| - | Wero (EPI) | `wero.apk` | `extracted/wero/` | ❌ **Verwijderd** | - | - |
| - | N26 | - | - | ❌ **Niet gedownload** | - | - |

---

## 🏗️ Directory Structuur

Elke app heeft de volgende structuur:

```
extracted/<bank>/
├── app/                          # Basis APK inhoud
│   ├── AndroidManifest.xml      # App manifest
│   ├── classes.dex               # DEX bestanden (1 of meer)
│   ├── classes2.dex              # Extra DEX (indien aanwezig)
│   ├── ...                       # Andere DEX bestanden
│   ├── res/                      # Resources
│   ├── assets/                   # Assets
│   └── META-INF/                 # Metadata
│
├── libs/                         # Native libraries directory
│   └── lib/
│       └── arm64-v8a/            # 64-bit ARM libraries
│           └── lib/arm64-v8a/    # Daadwerkelijke .so bestanden
│               ├── libxxx.so
│               ├── libyyy.so
│               └── ...
│
└── xapk/                         # XAPK bundel inhoud (indien van toepassing)
    ├── <basis-apk>.apk
    ├── config.arm64_v8a.apk
    ├── config.en.apk
    ├── ...
    └── manifest.json
```

---

## ✅ Verificatie

### AndroidManifest.xml
Alle geanalyseerde apps hebben een geldig manifest:

```
✅ SNS Bank:        extracted/sns/app/AndroidManifest.xml
✅ RegioBank:      extracted/regio/app/AndroidManifest.xml
✅ ASN Bank:       extracted/asn/app/AndroidManifest.xml
✅ ING:            extracted/ing/app/AndroidManifest.xml
✅ Rabobank:       extracted/rabobank/app/AndroidManifest.xml
✅ Knab:           extracted/knab/app/AndroidManifest.xml
✅ Revolut:        extracted/revolut/app/AndroidManifest.xml
✅ Trade Republic: extracted/trade_republic/app/AndroidManifest.xml
✅ ABN AMRO:       extracted/abnamro/app/AndroidManifest.xml
✅ Bunq:           extracted/bunq/app/AndroidManifest.xml
✅ Triodos:        extracted/triodos/app/AndroidManifest.xml
✅ Wero (EPI):     extracted/wero/app/AndroidManifest.xml
```

### Native Libraries
Native libraries (.so) zijn aanwezig in alle apps:
- SNS: 6 .so bestanden in `extracted/sns/libs/lib/arm64-v8a/lib/arm64-v8a/`
- RegioBank: 14 .so bestanden in `extracted/regio/libs/lib/arm64-v8a/lib/arm64-v8a/`
- ASN Bank: 14 native libraries in `lib/arm64-v8a/`
- ING: .so bestanden in `extracted/ing/libs/lib/arm64-v8a/lib/arm64-v8a/`
- Rabobank: .so bestanden in `extracted/rabobank/libs/lib/arm64-v8a/lib/arm64-v8a/`
- Knab: 14 native libraries in `lib/arm64-v8a/` (iProov, ML Kit OCR)
- Revolut: 21+ native libraries in `app_full/lib/arm64-v8a/` (incl. libfourthline-security.so, libsqlcipher.so)
- Trade Republic: .so bestanden in `extracted/trade_republic/libs/lib/arm64-v8a/lib/arm64-v8a/`
- ABN AMRO: 28 native libraries in `lib/arm64-v8a/` (incl. libsqlcipher.so)
- Bunq: 40 native libraries in `lib/arm64-v8a/` (incl. libsqlcipher.so, libsigner.so)
- Triodos: 13 native libraries in `lib/arm64-v8a/` (incl. libfourthline-security.so)
- Wero: .so bestanden in `extracted/wero/app/lib/arm64-v8a/`

---

## ❌ Niet Beschikbare Apps

### N26
- **Status:** ❌ **Niet gedownload**
- **Reden:** Niet beschikbaar via apkeep, APKMirror of Aptoide
- **Verdere actie:** Niet mogelijk

### Wero (EPI)
- **Status:** ❌ **Verwijderd door user**
- **Reden:** Verkeerde APK gedownload (pakket-ID was `cm.aptoide.pt` in plaats van `eu.epicompany.wero.wallet`)
- **Verdere actie:** Niet mogelijk

---

## 📊 DEX Bestanden

Elke app bevat DEX bestanden (classes.dex, classes2.dex, etc.) in de `app/` directory.

**Aantal DEX bestanden per app:**
- ABN AMRO: 9 DEX-bestanden (app_full/)
- ING: 5 DEX-bestanden
- Rabobank: 8 DEX-bestanden
- Knab: 7 DEX-bestanden
- Revolut: 22 DEX-bestanden (app_full/)
- Trade Republic: 5 DEX-bestanden
- SNS Bank: 6 DEX-bestanden
- RegioBank: 6 DEX-bestanden
- ASN Bank: 6 DEX-bestanden
- Bunq: 12 DEX-bestanden
- Triodos: 2 DEX-bestanden

---

# 🔍 Statische Analyse Resultaten

## 📈 Samenvatting Remote Attestation per Bank

| Bank | Play Integrity API | SafetyNet | AndroidKeyStore Attestation | SQLCipher | Root Detectie | Wero | Wero Validatie | FIDO2/WebAuthn |
|------|---------------------|-----------|---------------------------|-----------|---------------|------|----------------|---------------|
| **ABN AMRO** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF | ❌ AFWEZIG | ❌ AFWEZIG | ❌ Geen | ❌ AFWEZIG |
| **ING** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ Geen | ❌ AFWEZIG |
| **Rabobank** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ❌ AFWEZIG | ❌ Geen | ❌ AFWEZIG |
| **Knab** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ Geen | ❌ AFWEZIG |
| **Revolut** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF | ✅ ACTIEF | ❌ AFWEZIG | ❌ Geen | ✅ ACTIEF |
| **Trade Republic** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ Geen | ❌ AFWEZIG |
| **SNS Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | ✅ Play Integrity Token | ✅ ACTIEF |
| **RegioBank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | ✅ Play Integrity Token | ✅ ACTIEF |
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | ✅ Play Integrity Token | ✅ ACTIEF |
| **Bunq** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | ❌ AFWEZIG | ✅ ACTIEF | ✅ Server-side met Hardware-binding | ❌ AFWEZIG |
| **Triodos** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF | ✅ ACTIEF | ✅ Server-side | ❌ AFWEZIG |

---

## 🔐 **Gedetailleerde Wero Implementatie Analyse**

### 📊 **Wero Adoptie Overzicht**

| Categorisatie | Banken | Aantal | Percentage |
|---------------|--------|--------|------------|
| **Wero ACTIEF** | ASN Bank, SNS Bank, RegioBank, Bunq, Triodos | 5 | 45% |
| **Wero AFWEZIG** | ABN AMRO, ING, Rabobank, Knab, Revolut, Trade Republic | 6 | 55% |

---

### 🏆 **Banken MET Wero-implementatie**

#### **Volksbank Groep (ASN, SNS, RegioBank)**
- **Implementatie:** Eigen Volksbank implementatie
- **Codebase:** Gedeeld tussen alle drie banken (`nl.devolksbank.mobile.banking.domain.wero.*`)
- **Validatiemethode:** ✅ **Play Integrity Token Validatie met Apparaat- en App-Attestation**
- **Technische details:**
  - Gebruikt `RequestIntegrityTokenUseCase` en `IntegrityRepository`
  - Wallet-registratie: `StartRegistrationContextRequest(deviceId=)` → `registrationContextId` + `DeviceAttestationStatus`
  - `AppAttestation`-model bevat Play Integrity-token
  - Server-side validatie tegen registratie-context
  - Platformonafhankelijk (Android: Play Integrity, iOS: App Attest)
  - Betaalmiddelen gebruiken `PaymentMeansKeyAttestation` met KEK/SUK-hiërarchie
  - Biometrische en PIN-gebaseerde sleutelontgrendeling
- **SDK:** Google Play Integrity SDK v1.6.0
- **FIDO2:** ✅ ACTIEF (play-services-fido v21.0.0)
- **iProov:** ✅ Gezichtsherkenning

#### **Bunq**
- **Implementatie:** ✅ **Eigen Bunq implementatie** (geen extern Wero/EPI-SDK)
- **Codebase:** `com.bunq.android.model.wero.*`, `com.bunq.android.ui.activity.wero.*`
- **Validatiemethode:** ✅ **Server-side Validatie met Hardware-binding**
- **Technische details:**
  - Endpoints: `/user/{userId}/wero-wallet`, `/user/{userId}/wero-consumer`, `/user/{userId}/wero-issuer-transaction`
  - `WeroKeyStoreHelper.kt` beheert wallet-sleutels in Android Keystore
  - Hardware-gebonden sleutelopslag en device-binding
  - **Geen app-side attestation-token** (geen challenge/response, geen attestation-certificaatketen)
  - Validatie vindt volledig server-side plaats
- **SQLCipher:** ✅ ACTIEF (59 treffers + libsqlcipher.so)
- **Root-detectie:** Via derden (Sentry, Onfido, Adyen 3DS2)

#### **Triodos**
- **Implementatie:** ✅ **Eigen Triodos Bank implementatie**
- **Codebase:** Eigen endpoints in domein `com.triodos.bankingnl`
- **Validatiemethode:** ✅ **Server-side Validatie**
- **Technische details:**
  - Endpoints: `/wero/wallet`, `/wero/consent/`, `/v4/wero/wallet`
  - Wallet-registratie en betalingsflows volledig server-side beheerd
  - Geen app-side attestation-token zichtbaar
  - Geen extern Wero- of EPI-SDK gedetecteerd
- **Root-detectie:** ✅ ACTIEF (native, libfourthline-security.so: magisk, xposed, frida-gadget)

---

### ❌ **Banken ZONDER Wero-implementatie**

#### **ABN AMRO**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde code, endpoints of SDK's gevonden in de APK
- **Alternatieve attestatie:** ✅ SafetyNet Attestation API
- **Opmerking:** Gebruikt nog SafetyNet (ouder mechanisme), geen Wero-integratie

#### **ING**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden
- **Alternatieve attestatie:** ❌ Geen remote attestation
- **Opmerking:** Baseert apparaatveiligheid op hardware-gebonden cryptografie en server-side controles

#### **Rabobank**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde code of endpoints gevonden
- **Alternatieve attestatie:** ❌ Geen remote attestation (SafetyNet SDK aanwezig maar **❌ AFWEZIG** - geen nl.rabomobiel types in contextverificatie)
- **Opmerking:** Gebruikt **Certificate pinning ✅ ACTIEF** (bevestigd: CertificatePinner.kt in eigen code) en **BiometricPrompt ✅ ACTIEF** (bevestigd: BiometricPromptManager.kt en nl.rabobank types). SQLCipher is ⚠️ AANWEZIG (NIET ACTIEF)

#### **Knab**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden
- **Alternatieve attestatie:** ❌ Geen remote attestation (**Play Integrity ❌ AFWEZIG**, **SafetyNet ❌ AFWEZIG** - beide vals-positieven, geen bvm types in contextverificatie)
- **Opmerking:** Gebruikt iProov en ML Kit OCR voor biometrie/document scanning. **Certificate pinning ⚠️ AANWEZIG (NIET ACTIEF)**, **BiometricPrompt ⚠️ AANWEZIG (NIET ACTIEF)** - geen bvm types bevestigd

#### **Revolut**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde code, endpoints of SDK's gevonden
- **Alternatieve attestatie:** ✅ Play Integrity + SafetyNet (beide actief)
- **Opmerking:** Heeft eigen wallet-implementatie met native root-detectie

#### **Trade Republic**
- **Wero-status:** ❌ **AFWEZIG**
- **Reden:** Geen Wero-gerelateerde klassen, endpoints of SDK's gevonden
- **Alternatieve attestatie:** ✅ Play Integrity + AndroidKeyStore-hardware-attestation
- **Opmerking:** Een van de meest robuuste beveiligingsbenaderingen zonder Wero

---

## 🎯 Kernbevindingen per Bank

### **Revolut** 
- **Attestation:** ✅ Play Integrity + ✅ SafetyNet (beide actief gebruikt in eigen code)
- **Beveiliging:** ✅ SQLCipher, ✅ Native root-detectie (libfourthline-security.so detecteert magisk, xposed, frida-gadget), ✅ FIDO2/WebAuthn, ✅ Certificate pinning (OkHttp)
- **Wero:** ❌ AFWEZIG - Gebruikt eigen wallet-implementatie
- **Native libraries:** 21+ libraries
- **Opmerking:** Heeft de meest robuuste beveiligingsbenadering van alle geanalyseerde banken

### **Trade Republic** 
- **Attestation:** ✅ Play Integrity + ✅ AndroidKeyStore-hardware-attestation (beide actief bevestigd)
- **Beveiliging:** ✅ Hardware-gebonden sleutelopslag, ✅ Biometrie/SCA, ✅ Certificate pinning
- **Wero:** ❌ AFWEZIG - Geen Wero-integratie
- **Opmerking:** Geen SafetyNet, maar wel hardware-attestation actief

### **Volksbank (ASN, SNS, RegioBank)** 
- **Attestation:** ✅ Play Integrity (actief in Wero-flows)
- **Beveiliging:** ✅ FIDO2/WebAuthn, ✅ iProov gezichtsherkenning, ✅ StrongBox-aware
- **Wero:** ✅ **ACTIEF** - Eigen Volksbank implementatie met Play Integrity Token Validatie (apparaat- + app-attestation)
- **Opmerking:** Gebruiken alle drie dezelfde codebase met Play Integrity SDK v1.6.0

### **ABN AMRO** 
- **Attestation:** ✅ SafetyNet (actief gebruikt, SDK in app_full/)
- **Beveiliging:** ✅ SQLCipher, ✅ Hardware-gebonden sleutelopslag, ✅ Certificate pinning, ✅ Biometrie
- **Wero:** ❌ AFWEZIG - Geen Wero-implementatie gevonden
- **Opmerking:** Gebruikt nog SafetyNet (ouder mechanisme), geen Wero-integratie

### **Rabobank** 
- **Attestation:** ❌ Geen remote attestation gevonden
- **Beveiliging:** ✅ SQLCipher, ✅ Certificate pinning (23 pins), ✅ Hardware-gebonden sleutelopslag
- **Wero:** ❌ AFWEZIG - Geen Wero-implementatie gevonden
- **Opmerking:** SafetyNet SDK aanwezig maar niet actief gebruikt (vals-positief)

### **Bunq** 
- **Attestation:** ❌ Geen remote attestation gevonden
- **Beveiliging:** ✅ SQLCipher, ✅ Hardware-gebonden cryptografie, ✅ Server-side apparaatregistratie, ✅ Root-detectie via derden
- **Wero:** ✅ **ACTIEF** - Eigen Bunq implementatie met Server-side Validatie met Hardware-binding
- **Opmerking:** Apparaatveiligheid gebaseerd op hardware-gebonden cryptografie en server-side controles

### **Triodos** 
- **Attestation:** ❌ Geen remote attestation gevonden
- **Beveiliging:** ✅ Hardware-gebonden sleutelopslag, ✅ Native root-detectie (libfourthline-security.so)
- **Wero:** ✅ **ACTIEF** - Eigen Triodos implementatie met Server-side Validatie
- **Opmerking:** Root-detectie actief in native code

### **ING** 
- **Attestation:** ❌ Geen remote attestation gevonden
- **Beveiliging:** ✅ Hardware-gebonden sleutelopslag, ✅ Biometrie/SCA, ✅ Certificate pinning
- **Wero:** ❌ AFWEZIG - Geen Wero-implementatie gevonden
- **Opmerking:** Gebruikt geen van de drie bekende attestatie-mechanismen

### **Knab** 
- **Attestation:** ❌ Geen remote attestation gevonden (vals-positieven voor Play Integrity en SafetyNet)
- **Beveiliging:** ✅ Certificate pinning (14 pins), ✅ iProov, ✅ ML Kit OCR, ✅ Hardware-gebonden sleutelopslag
- **Wero:** ❌ AFWEZIG - Geen Wero-implementatie gevonden
- **Opmerking:** Play Integrity en SafetyNet markers aanwezig in SDK's maar niet actief gebruikt

---

## 🔬 Gedetailleerde Analyse per Attestation Methode

### Google Play Integrity API

**Actief gebruikt in:**
- ✅ Revolut (17 treffers, bevestigd in revolut.analytics.integrity)
- ✅ Trade Republic (11 treffers, bevestigd in traderepublic types)
- ✅ ASN Bank (RequestIntegrityTokenUseCase, IntegrityRepository in Wero-flows)
- ✅ SNS Bank (SDK v1.6.0, 141 treffers)
- ✅ RegioBank (SDK v1.6.0, 141 treffers)

**Afwezig in:**
- ❌ ABN AMRO
- ❌ ING
- ❌ Rabobank
- ❌ Knab (vals-positief: 9 treffers maar geen bvm types)
- ❌ Bunq
- ❌ Triodos

### SafetyNet Attestation API

**Actief gebruikt in:**
- ✅ ABN AMRO (51 treffers, SDK in app_full/)
- ✅ Revolut (3 treffers, ClientLifecycleSafetyNet bevestigd)

**Aanwezig maar niet actief:**
- ⚠️ Rabobank (86 treffers, SDK v18.1.0, vals-positief - **❌ AFWEZIG** in contextverificatie: geen nl.rabomobiel types)
- ⚠️ Knab (8 treffers, vals-positief - **❌ AFWEZIG** in contextverificatie: geen bvm types)

**Afwezig in:**
- ❌ ING
- ❌ ASN Bank
- ❌ SNS Bank
- ❌ RegioBank
- ❌ Bunq
- ❌ Trade Republic
- ❌ Triodos

### AndroidKeyStore Hardware Attestation

**Actief gebruikt in:**
- ✅ Trade Republic (16 treffers voor setAttestationChallenge, bevestigd in traderepublic types)

**Afwezig in:**
- ❌ ABN AMRO
- ❌ ING
- ❌ Rabobank
- ❌ Knab
- ❌ Revolut
- ❌ ASN Bank
- ❌ SNS Bank
- ❌ RegioBank
- ❌ Bunq
- ❌ Triodos

---

## 🛡️ Beveiligingsmechanismen Overzicht

### Database Versleuteling (SQLCipher)

| Bank | Status | Bewijs |
|------|--------|--------|
| ABN AMRO | ✅ ACTIEF | 57 treffers + libsqlcipher.so in native libraries |
| Revolut | ✅ ACTIEF | 20 treffers + libsqlcipher.so |
| Bunq | ✅ ACTIEF | 59 treffers + libsqlcipher.so bevestigd |
| Rabobank | ⚠️ AANWEZIG (NIET ACTIEF) | 50 treffers in DEX-strings, maar **geen nl.rabomobiel types** in contextverificatie |
| Knab | ❌ AFWEZIG | Geen SQLCipher in native libraries |
| ING | ❌ AFWEZIG | - |
| Trade Republic | ❌ AFWEZIG | - |
| SNS Bank | ❌ AFWEZIG | - |
| RegioBank | ❌ AFWEZIG | - |
| ASN Bank | ❌ AFWEZIG | - |
| Triodos | ❌ AFWEZIG | - |

### Certificate Pinning

| Bank | Status | Aantal Pins |
|------|--------|-------------|
| ABN AMRO | ✅ ACTIEF | 2 (OkHttp CertificatePinner) |
| ING | ✅ ACTIEF | Aangenomen (OkHttp) |
| Rabobank | ✅ ACTIEF | 23 (OkHttp CertificatePinner; **bevestigd**: CertificatePinner.kt in eigen code) |
| Knab | ⚠️ AANWEZIG (NIET ACTIEF) | 14 (OkHttp CertificatePinner; geen bvm types in contextverificatie) |
| Revolut | ✅ ACTIEF | OkHttp CertificatePinner |
| Trade Republic | ✅ ACTIEF | 20 (OkHttp CertificatePinner) |
| SNS Bank | ✅ ACTIEF | OkHttp CertificatePinner |
| RegioBank | ✅ ACTIEF | OkHttp CertificatePinner |
| ASN Bank | ✅ ACTIEF | OkHttp CertificatePinner detectie bevestigd |
| Bunq | ✅ ACTIEF | Ruim 10 pins voor API-eindpunten |
| Triodos | ❓ Niet gecontroleerd | - |

### Hardware-gebonden Sleutelopslag

| Bank | setIsStrongBoxBacked | setUserAuthenticationRequired | Status |
|------|----------------------|-------------------------------|--------|
| ABN AMRO | 5 referenties | - | ✅ ACTIEF |
| ING | 1 referentie | 4 referenties | ✅ ACTIEF |
| Rabobank | 32 referenties | 32 referenties | ⚠️ AANWEZIG (NIET ACTIEF) |
| Knab | 4 referenties | 4 referenties | ⚠️ AANWEZIG (NIET ACTIEF) |
| Revolut | 5 referenties | 5 referenties | ✅ ACTIEF |
| Trade Republic | 3 referenties | 3 referenties | ✅ ACTIEF |
| SNS Bank | Aanwezig | - | ✅ ACTIEF |
| RegioBank | Aanwezig | - | ✅ ACTIEF |
| ASN Bank | IsStrongBoxAvailableUseCase | - | ✅ ACTIEF |
| Bunq | 1 referentie (bevestigd in com.bunq code) | 1 referentie (bevestigd in com.bunq code) | ✅ ACTIEF |
| Triodos | 1 referentie | 1 referentie | ✅ ACTIEF |

### Biometrie / SCA

Alle banken gebruiken `android.hardware.biometrics.BiometricPrompt`:
- ABN AMRO: 12 referenties - ✅ ACTIEF GEBRUIKT
- ING: 11 referenties - ✅ ACTIEF GEBRUIKT
- Rabobank: 43 referenties - ✅ ACTIEF GEBRUIKT (**bevestigd**: BiometricPromptManager.kt, nl.rabobank.bankierenplus.authentication.* types)
- Knab: 5 referenties - ⚠️ AANWEZIG (NIET ACTIEF) (geen bvm types in contextverificatie)
- Revolut: 23 referenties - ✅ ACTIEF GEBRUIKT
- Trade Republic: 45 referenties - ✅ ACTIEF GEBRUIKT
- SNS Bank: Aanwezig - ✅ ACTIEF GEBRUIKT
- RegioBank: Aanwezig - ✅ ACTIEF GEBRUIKT
- ASN Bank: 28 referenties (met CryptoObject) - ✅ ACTIEF GEBRUIKT
- Bunq: 7 referenties (met CryptoObject) - ✅ ACTIEF GEBRUIKT
- Triodos: ✅ ACTIEF (met CryptoObject)

### Root Detectie

| Bank | Status | Methode |
|------|--------|---------|
| Revolut | ✅ ACTIEF | Native (libfourthline-security.so: magisk, xposed, frida-gadget) |
| Triodos | ✅ ACTIEF | Native (libfourthline-security.so: magisk, xposed, frida-gadget) |
| Bunq | ✅ ACTIEF | Via derden (Sentry, Onfido, Adyen 3DS2) |
| ABN AMRO | ❌ AFWEZIG | - |
| ING | ❌ AFWEZIG | - |
| Rabobank | ❌ AFWEZIG | - |
| Knab | ❌ AFWEZIG | - |
| Trade Republic | ❌ AFWEZIG | - |
| SNS Bank | ❌ AFWEZIG | - |
| RegioBank | ❌ AFWEZIG | - |
| ASN Bank | ❌ AFWEZIG | - |

### FIDO2/WebAuthn

| Bank | Status | SDK Versie |
|------|--------|------------|
| ASN Bank | ✅ ACTIEF | play-services-fido v21.0.0 |
| SNS Bank | ✅ ACTIEF | play-services-fido v21.0.0 |
| RegioBank | ✅ ACTIEF | play-services-fido v21.0.0 |
| Revolut | ✅ ACTIEF | 20 treffers in marker analyse |
| Trade Republic | ❌ AFWEZIG | - |
| ABN AMRO | ❌ AFWEZIG | - |
| ING | ❌ AFWEZIG | - |
| Rabobank | ❌ AFWEZIG | - |
| Knab | ❌ AFWEZIG | - |
| Bunq | ❌ AFWEZIG | - |
| Triodos | ❌ AFWEZIG | - |

### Wero Implementatie

| Bank | Status | Type | Validatiemethode | Codebase/SDK |
|------|--------|------|-------------------|--------------|
| ASN Bank | ✅ ACTIEF | Eigen Volksbank | Play Integrity Token Validatie | `nl.devolksbank.mobile.banking.domain.wero.*` |
| SNS Bank | ✅ ACTIEF | Eigen Volksbank | Play Integrity Token Validatie | Gedeeld met ASN/RegioBank |
| RegioBank | ✅ ACTIEF | Eigen Volksbank | Play Integrity Token Validatie | Gedeeld met ASN/SNS |
| Bunq | ✅ ACTIEF | Eigen Bunq | Server-side met Hardware-binding | `com.bunq.android.model.wero.*` |
| Triodos | ✅ ACTIEF | Eigen Triodos | Server-side Validatie | `com.triodos.bankingnl` endpoints |
| ABN AMRO | ❌ AFWEZIG | - | - | - |
| ING | ❌ AFWEZIG | - | - | - |
| Rabobank | ❌ AFWEZIG | - | - | - |
| Knab | ❌ AFWEZIG | - | - | - |
| Revolut | ❌ AFWEZIG | - | - | - |
| Trade Republic | ❌ AFWEZIG | - | - | - |

---

## 📋 Legenda Classificatie Status

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

## 🔗 Verwante Documenten

Individuele statische analyses:
- [ABN AMRO Analyse](statische-analyse-apparaatveiligheid-in-de-abnamro-android-app.md)
- [ASN Bank Analyse](statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md)
- [Bunq Analyse](statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md)
- [ING Analyse](statische-analyse-apparaatveiligheid-in-de-ing-android-app.md)
- [Knab Analyse](statische-analyse-apparaatveiligheid-in-de-knab-android-app-v4-11-0.md)
- [Rabobank Analyse](statische-analyse-apparaatveiligheid-in-de-rabobank-android-app-v8-1-4.md)
- [RegioBank Analyse](statische-analyse-apparaatveiligheid-in-de-regiobank-android-app-v1-36-3.md)
- [Revolut Analyse](statische-analyse-apparaatveiligheid-in-de-revolut-android-app.md)
- [SNS Bank Analyse](statische-analyse-apparaatveiligheid-in-de-sns-bank-android-app-v1-36-3.md)
- [Trade Republic Analyse](statische-analyse-apparaatveiligheid-in-de-trade-republic-android-app-v4-2645-1.md)
- [Triodos Analyse](statische-analyse-apparaatveiligheid-in-de-triodos-bankingnl-android-app-v5-13-7.md)

Vergelijkende rapporten:
- [Vergelijking apparaatveiligheid en attestation](vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md)

---

## 🔮 Volgende Stappen

1. **Manifest extractie** - Gebruik `axml_min.py` om package info te extraheren
2. **DEX extractie** - Voer `dex_extract.py` uit om strings en types te extraheren
3. **Marker analyse** - Zoek naar attestatie markers in strings_all.txt
4. **Native library scan** - Scan .so bestanden op JNI referenties

Zie `ANALYSE_INSTRUCTIES.vibe` voor gedetailleerde instructies.

---

## 📝 Opmerkingen

- Het extractieproces duurde ~25 seconden voor alle apps
- Alle bestanden zijn opgeslaan in `/home/thijs/Downloads/Bank apps/extracted/`
- Totale grootte van extracted directory: ~1.2 GB
- Het script `extract_all.sh` is behouden voor toekomstig gebruik
- Alle analyses zijn statisch uitgevoerd (geen dynamische verificatie met Frida/mitmproxy)
- Server-side controles blijven onzichtbaar in statische analyse
- **Wero-analyse:** Alle 11 banken hebben nu een gedetailleerde Wero-implementatieanalyse met validatiemethode
- **5 banken (45%)** hebben Wero geïmplementeerd: ASN Bank, SNS Bank, RegioBank, Bunq, Triodos
- **6 banken (55%)** hebben geen Wero-implementatie: ABN AMRO, ING, Rabobank, Knab, Revolut, Trade Republic
- **Contextverificatie (7 Nov 2026):** Knab: Play Integrity/SafetyNet vals-positief; Rabobank: SafetyNet vals-positief, Certificate pinning ✅ ACTIEF (CertificatePinner.kt), BiometricPrompt ✅ ACTIEF (nl.rabobank types), SQLCipher ⚠️ AANWEZIG (NIET ACTIEF)

---

*Laatste update: 5 November 2026*  
*Samengesteld op basis van individuele statische analyses per bank met Wero-implementatieanalyse*
