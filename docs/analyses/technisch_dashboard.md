# Technisch Dashboard
## Statische Apparaatveiligheidsanalyse van Nederlandse Bank Android Apps

**Project:** Nederlandse Bank Apps (11 banken)  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** Voltooid  
**Doel:** Overzichtelijke presentatie van alle technische resultaten

---

## 📋 Inleiding

Dit document biedt een **technisch dashboard** met complete overzichten van alle mechanisme-implementaties, decision trees, marker analyses en SDK-versies voor de **11 geanalyseerde bank-apps**. Het document is **feitelijk en objectief** en bevat geen waardeoordelen over de mate van beveiliging.

**Doelgroep:** Technische teams, security analysts, en iedereen die gedetailleerde technische informatie nodig heeft.

---

## 📊 1. COMPLETE VERGELIJKENDE TABELLEN PER MECHANISME

### 1.1 Attestation Mechanismen

| Bank | Pakketnaam | Versie | Play Integrity | SafetyNet | Hardware Attestation | Root Detectie | Native Root-detectie |
|------|------------|--------|---------------|-----------|---------------------|---------------|----------------------|
| **ABN AMRO** | com.abnamro.nl.mobile.payments | v13.34 | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **ASN Bank** | nl.devolksbank.asn.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **bunq** | com.bunq.android | v32.4.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **ING** | com.ing.mobile | v2025.25.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Knab** | bvm.bvmapp | v4.11.0 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Rabobank** | nl.rabomobiel | v8.1.4 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **RegioBank** | nl.devolksbank.regio.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Revolut** | com.revolut.revolut | v10.153.1 | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **SNS Bank** | nl.devolksbank.sns.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Trade Republic** | de.traderepublic.app | v4.2645.1 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG |
| **Triodos** | com.triodos.bankingnl | v5.13.7 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |

**Samenvatting:**
- **Play Integrity:** 5 banken (45%)
- **SafetyNet:** 2 banken (18%)
- **Hardware Attestation:** 1 bank (9%)
- **Native Root-detectie:** 2 banken (18%)

---

### 1.2 Cryptografie en Sleutelbeheer

| Bank | StrongBox | SQLCipher | setIsStrongBoxBacked | setUserAuthenticationRequired | Certificate Pinning |
|------|-----------|-----------|----------------------|-----------------------------|---------------------|
| **ABN AMRO** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG | ✅ ACTIEF GEBRUIKT |
| **bunq** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **ING** | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **Knab** | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) |
| **Rabobank** | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT |
| **RegioBank** | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT |
| **Revolut** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **SNS Bank** | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT |
| **Trade Republic** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **Triodos** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❓ NIET GEÏNSPECTEERD |

**Samenvatting:**
- **StrongBox ACTIEF GEBRUIKT:** 6 banken (55%)
- **SQLCipher:** 3 banken (27%)
- **Certificate Pinning:** 10 banken (91%)

---

### 1.3 Biometrie en Identiteitsverificatie

| Bank | BiometricPrompt | FIDO2/WebAuthn | iProov | Onfido | Adyen 3DS2 | Google Pay |
|------|-----------------|---------------|--------|--------|------------|------------|
| **ABN AMRO** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **bunq** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **ING** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Knab** | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG |
| **Rabobank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **RegioBank** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Revolut** | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **SNS Bank** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Trade Republic** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Triodos** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |

**Samenvatting:**
- **BiometricPrompt:** 9 banken (82%)
- **FIDO2/WebAuthn:** 3 banken (27%) - Alleen Volksbank Groep
- **iProov:** 3 banken (27%) - ASN, Regio, SNS

---

### 1.4 Wero Implementatie

| Bank | Wero Status | Validatiemethode | Wero SDK | KEK/SUK Hiërarchie | Hardware-binding |
|------|-------------|------------------|----------|--------------------|-----------------|
| **ABN AMRO** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Eigen (Volksbank) | ✅ ACTIEF GEBRUIKT | ⚠️ Via StrongBox |
| **bunq** | ✅ ACTIEF GEBRUIKT | Server-side Validatie | Eigen | ❓ Niet gespecificeerd | ✅ Direct |
| **ING** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **Knab** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **Rabobank** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **RegioBank** | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Eigen (Volksbank) | ✅ ACTIEF GEBRUIKT | ⚠️ Via StrongBox |
| **Revolut** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **SNS Bank** | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Eigen (Volksbank) | ✅ ACTIEF GEBRUIKT | ⚠️ Via StrongBox |
| **Trade Republic** | ❌ AFWEZIG | Geen | Geen | ❌ AFWEZIG | ❌ AFWEZIG |
| **Triodos** | ✅ ACTIEF GEBRUIKT | Server-side Validatie | Eigen | ❓ Niet gespecificeerd | ✅ Direct |

**Samenvatting:**
- **Wero ACTIEF GEBRUIKT:** 5 banken (45%)
- **Wero Validatiemethoden:**
  - Play Integrity Token Validatie: 3 banken (Volksbank Groep)
  - Server-side Validatie: 2 banken (bunq, Triodos)

---

## 🌳 2. DECISION TREES VOOR ATTESTATIE STRATEGIEËN

### 2.1 Attestation Strategie Decision Tree

```
Er een attestatie-mechanisme nodig?
├── Ja
│   ├── Gebruik Google Play Integrity?
│   │   ├── Ja
│   │   │   ├── Gebruik ook SafetyNet?
│   │   │   │   ├── Ja → Volledige Attestatie Stack (Revolut)
│   │   │   │   └── Nee
│   │   │   │       ├── Gebruik Hardware Attestation?
│   │   │   │       │   ├── Ja → Play Integrity + Hardware Attestation (Trade Republic)
│   │   │   │       │   └── Nee → Play Integrity Focus (ASN, Regio, SNS)
│   │   │   └── Gebruik FIDO2/WebAuthn?
│   │   │       ├── Ja → Volksbank Groep (ASN, Regio, SNS)
│   │   │       └── Nee → Baseline Play Integrity
│   │   └── Nee
│   │       ├── Gebruik SafetyNet?
│   │       │   ├── Ja → SafetyNet Focus (ABN AMRO)
│   │       │   └── Nee → Geen attestatie (ING, Knab, Rabobank, bunq*, Triodos*)
│   └── Nee → Geen attestatie
└── Nee → Geen attestatie nodig

* bunq en Triodos gebruiken Wero zonder attestatie-mechanismen
```

### 2.2 Wero Implementatie Decision Tree

```
Implementeer Wero?
├── Ja
│   ├── Gebruik Play Integrity?
│   │   ├── Ja → Volksbank Groep (ASN, Regio, SNS)
│   │   │   ├── Validatiemethode: Play Integrity Token Validatie
│   │   │   ├── SDK: Google Play Integrity v1.6.0
│   │   │   ├── FIDO2: ✅ ACTIEF GEBRUIKT
│   │   │   └── KEK/SUK Hiërarchie: ✅ ACTIEF GEBRUIKT
│   │   └── Nee
│   │       ├── Gebruik Hardware-binding?
│   │       │   ├── Ja → bunq
│   │       │   │   ├── Validatiemethode: Server-side met Hardware-binding
│   │       │   │   ├── SDK: Eigen implementatie
│   │       │   │   └── SQLCipher: ✅ ACTIEF GEBRUIKT
│   │       │   └── Nee → Triodos
│   │       │       ├── Validatiemethode: Server-side
│   │       │       ├── SDK: Eigen implementatie
│   │       │       └── Native Root-detectie: ✅ ACTIEF GEBRUIKT
│   └── Nee → Geen Wero
└── Nee → Geen Wero
```

### 2.3 Root-detectie Decision Tree

```
Implementeer Root-detectie?
├── Ja
│   ├── Native Implementatie?
│   │   ├── Ja
│   │   │   ├── Gebruik libfourthline-security.so?
│   │   │   │   ├── Ja → Revolut, Triodos
│   │   │   │   │   ├── Detectie: Magisk, Xposed, Frida-gadget
│   │   │   │   │   └── Type: Native library
│   │   │   │   └── Nee → Bugsnag (Triodos)
│   │   │   │       └── Detectie: Root-detectie via Bugsnag SDK
│   │   │   └── Gebruik eigen native code?
│   │   │       └── Nee
│   │   └── Nee (Derden)
│   │       └── bunq
│   │           ├── Sentry: RootChecker
│   │           ├── Onfido: Test-keys detectie
│   │           ├── Adyen: Emulator detectie
│   │           └── vonage: Cellular binding detectie
│   └── Nee → Geen native root-detectie
└── Nee → Geen root-detectie
```

---

## 📋 3. OVERZICHT VAN ALLE MARKERS PER BANK

### 3.1 Marker Aantallen (uit MARKER_ANALYSE.md)

| Bank | Play Integrity | SafetyNet | Hardware Attest. | Android Keystore | Biometrie | FIDO2 | SQLCipher | Cert. Pinning | Wero |
|------|---------------|-----------|-----------------|------------------|-----------|-------|-----------|---------------|------|
| **SNS Bank** | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 45 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **RegioBank** | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 44 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **ASN Bank** | ✅ 120 | ❌ 0 | ❌ 0 | ✅ 6 | ✅ 28 | ✅ 20 | ❌ 0 | ✅ Detectie | ✅ Eigen |
| **ING** | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 4 | ✅ 11 | ✅ 1 | ❌ 0 | ❌ 0 | ❌ AFWEZIG |
| **Rabobank** | ❌ 0 | ✅ 86 | ❌ 0 | ✅ 32 | ✅ 43 | ✅ 1 | ✅ 50 | ✅ 23 | ❌ AFWEZIG |
| **Knab** | ✅ 9 | ✅ 8 | ❌ 0 | ✅ 4 | ✅ 5 | ✅ 1 | ❌ 0 | ✅ 14 | ❌ AFWEZIG |
| **Revolut** | ✅ 17 | ✅ 3 | ❌ 0 | ✅ 5 | ✅ 23 | ✅ 20 | ✅ 47 | ❌ 0 | ❌ AFWEZIG |
| **Trade Republic** | ✅ 11 | ❌ 0 | ✅ 16 | ✅ 3 | ✅ 45 | ✅ 20 | ❌ 0 | ✅ 20 | ❌ AFWEZIG |
| **ABN AMRO** | ❌ 0 | ✅ 51 | ❌ 0 | ✅ 5 | ✅ 12 | ✅ 2 | ✅ 57 | ✅ 2 | ❌ AFWEZIG |
| **bunq** | ❌ 0 | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 7 | ❌ 0 | ✅ 59 | ✅ 10+ | ✅ Eigen |
| **Triodos** | ❌ 0 | ❌ 0 | ❌ 0 | ✅ 1 | ✅ 7+ | ❌ 0 | ❌ 0 | ❓ | ✅ Eigen |

**Opmerking:** Deze aantallen zijn gebaseerd op string-matching in DEX-bestanden. Contextverificatie is uitgevoerd om vals-positieven te identificeren en te corrigeren.

---

### 3.2 Marker Classificatie Status

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ | **ACTIEF GEBRUIKT** | Mechanisme is aanwezig en wordt actief gebruikt in eigen code (bevestigd via contextverificatie) |
| ⚠️ | **AANWEZIG (NIET ACTIEF)** | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt (vals-positief) |
| ❌ | **AFWEZIG** | Geen sporen gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ | **NIET GEÏNSPECTEERD** | Mechanisme is niet specifiek onderzocht |

---

### 3.3 Marker Aantallen per Categorie

| Categorie | Totaal Markers | Gemiddeld per Bank |
|-----------|----------------|---------------------|
| **Play Integrity** | 397 | 36.1 |
| **SafetyNet** | 148 | 13.5 |
| **Hardware Attestation** | 17 | 1.5 |
| **Android Keystore** | 66 | 6.0 |
| **Biometrie** | 225 | 20.5 |
| **FIDO2** | 82 | 7.5 |
| **SQLCipher** | 182 | 16.5 |
| **Certificate Pinning** | 86+ | 7.8 |

---

## 📦 4. SDK VERSIES PER BANK

### 4.1 Google Play Services SDK's

| Bank | Play Integrity SDK | Versie | Status |
|------|-------------------|--------|--------|
| **ASN Bank** | play-core-integrity | v1.6.0 | ✅ Bevestigd |
| **RegioBank** | play-core-integrity | v1.6.0 | ✅ Bevestigd |
| **SNS Bank** | play-core-integrity | v1.6.0 | ✅ Bevestigd |
| **Revolut** | play-core-integrity | v1.6.0 | ✅ Bevestigd |
| **Trade Republic** | play-core-integrity | v1.6.0 | ✅ Bevestigd |
| **ABN AMRO** | play-services-safetynet | Onbekend | ✅ Bevestigd |
| **Revolut** | play-services-safetynet | Onbekend | ✅ Bevestigd |

### 4.2 FIDO2/WebAuthn SDK

| Bank | SDK | Versie | Status |
|------|-----|--------|--------|
| **ASN Bank** | play-services-fido | v21.0.0 | ✅ Bevestigd |
| **RegioBank** | play-services-fido | v21.0.0 | ✅ Bevestigd |
| **SNS Bank** | play-services-fido | v21.0.0 | ✅ Bevestigd |

### 4.3 SQLCipher

| Bank | Library | Versie | Status |
|------|---------|--------|--------|
| **ABN AMRO** | libsqlcipher.so | Onbekend | ✅ Bevestigd |
| **bunq** | libsqlcipher.so | Onbekend | ✅ Bevestigd |
| **Revolut** | libsqlcipher.so | Onbekend | ✅ Bevestigd |

### 4.4 Native Security Libraries

| Bank | Library | Functie | Status |
|------|---------|---------|--------|
| **Revolut** | libfourthline-security.so | Root-detectie | ✅ Bevestigd |
| **Triodos** | libfourthline-security.so | Root-detectie | ✅ Bevestigd |
| **Triodos** | libbugsnag-root-detection.so | Root-detectie | ✅ Bevestigd |
| **bunq** | libsigner.so | Native signing | ✅ Bevestigd |
| **bunq** | libsardine-native-methods.so | Netstat detectie | ✅ Bevestigd |

### 4.5 iProov SDK

| Bank | SDK | Versie | Status |
|------|-----|--------|--------|
| **ASN Bank** | iProov | Onbekend | ✅ Bevestigd |
| **RegioBank** | iProov | Onbekend | ✅ Bevestigd |
| **SNS Bank** | iProov | Onbekend | ✅ Bevestigd |
| **Knab** | iProov | Onbekend | ✅ Bevestigd |

### 4.6 Adyen 3DS2 SDK

| Bank | SDK | Versie | Status |
|------|-----|--------|--------|
| **bunq** | com.adyen.threeds2 | Onbekend | ✅ Bevestigd |

### 4.7 Onfido SDK

| Bank | SDK | Versie | Status |
|------|-----|--------|--------|
| **bunq** | Onfido | Onbekend | ✅ Bevestigd |
| **Knab** | iProov | Onbekend | ✅ Bevestigd |

---

## 📊 5. STATISTISCHE SAMENVATTINGEN

### 5.1 Mechanismen per Banktype

| Banktype | Totaal | Play Integrity | SafetyNet | Hardware Attest. | Wero | SQLCipher | Root-detectie |
|----------|--------|---------------|-----------|------------------|------|-----------|---------------|
| **Traditioneel** | 7 | 4 | 1 | 0 | 4 | 1 | 1 |
| **Neobank** | 2 | 0 | 0 | 0 | 1 | 1 | 0 |
| **Internationaal** | 2 | 2 | 1 | 1 | 0 | 1 | 1 |

### 5.2 Mechanismen per Land

| Land | Totaal | Play Integrity | SafetyNet | Hardware Attest. | Wero |
|------|--------|---------------|-----------|------------------|------|
| **Nederland** | 9 | 4 | 1 | 0 | 4 |
| **Internationaal** | 2 | 2 | 1 | 1 | 0 |

### 5.3 Native Libraries per Bank

| Bank | Native Libraries | Security Libraries | Percentage Security |
|------|-------------------|--------------------|---------------------|
| **ABN AMRO** | 28 | 5+ | ~18% |
| **ASN Bank** | 14 | 2 | 14% |
| **bunq** | 40 | 5+ | 13% |
| **ING** | 0 | 0 | 0% |
| **Knab** | 14 | 5 | 36% |
| **Rabobank** | 0 | 0 | 0% |
| **RegioBank** | 14 | 3 | 21% |
| **Revolut** | 21+ | 3+ | 14% |
| **SNS Bank** | 14 | 2 | 14% |
| **Trade Republic** | 0 | 0 | 0% |
| **Triodos** | 13 | 6+ | 46% |

---

## 🎯 6. CORRELATIE ANALYSE

### 6.1 Wero en Attestation Correlatie

| Wero Status | Play Integrity | SafetyNet | Hardware Attestation | Totaal |
|-------------|---------------|-----------|---------------------|--------|
| **Wero ACTIEF** | 3 | 0 | 0 | 5 |
| **Wero AFWEZIG** | 2 | 2 | 1 | 6 |

**Inzicht:** Banken met Wero geven de voorkeur aan Play Integrity (60% van Wero-banken) en gebruiken geen SafetyNet.

### 6.2 Native Libraries en Beveiligingsmechanismen

| Mechanisme | Native Library | Java/Kotlin | Banken |
|------------|----------------|-------------|--------|
| **Root-detectie** | ✅ Ja | ❌ Nee | Revolut, Triodos |
| **SQLCipher** | ✅ Ja | ❌ Nee | ABN AMRO, bunq, Revolut |
| **iProov** | ✅ Ja | ❌ Nee | ASN, Regio, SNS, Knab |
| **Play Integrity** | ❌ Nee | ✅ Ja | ASN, Regio, SNS, Revolut, Trade Republic |
| **StrongBox** | ❌ Nee | ✅ Ja | 6 banken |

---

## 📚 7. GERELATEERDE DOCUMENTEN

- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Complete lijst van vervolgstappen en documentatie
- [ANALYSE_RAPPORT.md](./ANALYSE_RAPPORT.md) - Compleet technisch analyse rapport
- [vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md](./vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) - Vergelijkende analyse
- [MARKER_ANALYSE.md](./MARKER_ANALYSE.md) - Marker analyse resultaten
- [patroon_analyse.md](./patroon_analyse.md) - Patroon analyse en correlaties
- [wero_implementatie_vergelijking.md](./wero_implementatie_vergelijking.md) - Wero implementatie vergelijking
- [native_library_analyse.md](./native_library_analyse.md) - Native library analyse
- [executive_summary.md](./executive_summary.md) - Executive summary voor stakeholders

---

## ✅ 8. VOLTOOIDE ACTIES

- [x] Maak complete vergelijkende tabellen per mechanisme
- [x] Creëer decision trees voor attestatie strategieën
- [x] Maak overzicht van alle markers per bank
- [x] Document SDK versies per bank

---

## 📖 9. LEGENDA

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ **NIET GEÏNSPECTEERD** | Niet gecontroleerd | Mechanisme is niet specifiek onderzocht in de analyse |

---

**Laatst geactualiseerd:** 7 November 2026, 21:45 CET  
**Versie:** 1.0  
**Status:** Voltooid  
**Document Type:** Technisch Dashboard  
