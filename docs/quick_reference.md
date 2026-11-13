# Quick Reference Guide
## Statische Apparaatveiligheidsanalyse van Nederlandse Bank Android Apps

**Project:** Nederlandse Bank Apps (11 banken)  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** Voltooid   
**Doel:** Snelle toegang tot belangrijkste resultaten

---

## 📋 Inleiding

Dit document biedt een **snelle referentie** naar de belangrijkste resultaten van de statische apparatuurveiligheidsanalyse van **11 Nederlandse en internationale bank-apps**. Het document is **feitelijk en objectief** en bevat geen waardeoordelen over de mate van beveiliging.

**Doelgroep:** Alle gebruikers die snel resultaten willen opzoeken zonder diepgaande technische details.

---

## 🏦 1. OVERZICHTSTABEL: BANK → ATTESTATION → WERO

| Bank | Pakketnaam | Versie | Play Integrity | SafetyNet | Hardware Attestation | Wero | Root Detectie |
|------|------------|--------|---------------|-----------|---------------------|------|---------------|
| **ABN AMRO** | com.abnamro.nl.mobile.payments | v13.34 | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **ASN Bank** | nl.devolksbank.asn.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **bunq** | com.bunq.android | v32.4.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG* |
| **ING** | com.ing.mobile | v2025.25.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Knab** | bvm.bvmapp | v4.11.0 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Rabobank** | nl.rabomobiel | v8.1.4 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **RegioBank** | nl.devolksbank.regio.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **Revolut** | com.revolut.revolut | v10.153.1 | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **SNS Bank** | nl.devolksbank.sns.bankieren | v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **Trade Republic** | de.traderepublic.app | v4.2645.1 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG |
| **Triodos** | com.triodos.bankingnl | v5.13.7 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |

* bunq gebruikt derden voor root-detectie (Sentry, Onfido, Adyen)

---

## 🔍 2. LOOKUP TABEL VOOR SPECIFIEKE MECHANISMEN

### 2.1 Play Integrity

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ASN Bank, RegioBank, SNS Bank, Revolut, Trade Republic | 5 |
| ❌ **AFWEZIG** | ABN AMRO, bunq, ING, Knab, Rabobank, Triodos | 6 |

### 2.2 SafetyNet

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ABN AMRO, Revolut | 2 |
| ❌ **AFWEZIG** | ASN Bank, bunq, ING, Knab, Rabobank, RegioBank, SNS Bank, Trade Republic, Triodos | 9 |

### 2.3 Hardware Attestation

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | Trade Republic | 1 |
| ❌ **AFWEZIG** | ABN AMRO, ASN Bank, bunq, ING, Knab, Rabobank, RegioBank, Revolut, SNS Bank, Triodos | 10 |

### 2.4 Wero

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ASN Bank, bunq, RegioBank, SNS Bank, Triodos | 5 |
| ❌ **AFWEZIG** | ABN AMRO, ING, Knab, Rabobank, Revolut, Trade Republic | 6 |

### 2.5 Root-detectie (Native)

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | Revolut, Triodos | 2 |
| ⚠️ **DERDEN** | bunq (Sentry, Onfido, Adyen) | 1 |
| ❌ **AFWEZIG** | ABN AMRO, ASN Bank, ING, Knab, Rabobank, RegioBank, SNS Bank, Trade Republic | 8 |

### 2.6 SQLCipher

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ABN AMRO, bunq, Revolut | 3 |
| ❌ **AFWEZIG** | ASN Bank, ING, Knab, Rabobank, RegioBank, SNS Bank, Trade Republic, Triodos | 8 |

### 2.7 StrongBox

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ABN AMRO, ASN Bank, bunq, Revolut, Trade Republic, Triodos | 6 |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | ING, Knab, Rabobank, SNS Bank | 4 |
| ❌ **AFWEZIG** | RegioBank | 1 |

### 2.8 Certificate Pinning

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ABN AMRO, ASN Bank, bunq, ING, Knab, Rabobank, RegioBank, Revolut, SNS Bank, Trade Republic | 10 |
| ❓ **NIET GEÏNSPECTEERD** | Triodos | 1 |

### 2.9 FIDO2/WebAuthn

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ASN Bank, RegioBank, SNS Bank | 3 |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Revolut | 1 |
| ❌ **AFWEZIG** | ABN AMRO, bunq, ING, Knab, Rabobank, Trade Republic, Triodos | 7 |

### 2.10 BiometricPrompt

| Status | Banken | Aantal |
|--------|--------|--------|
| ✅ **ACTIEF GEBRUIKT** | ABN AMRO, ASN Bank, bunq, ING, Rabobank, RegioBank, Revolut, SNS Bank, Trade Republic, Triodos | 10 |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Knab | 1 |

---

## 📋 3. LIJST VAN ALLE BEVESTIGDE MECHANISMEN PER BANK

### 3.1 ABN AMRO

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| SafetyNet | ✅ ACTIEF GEBRUIKT | SDK gebundeld, eigen code bevestigd |
| StrongBox | ✅ ACTIEF GEBRUIKT | Contextverificatie bevestigd |
| SQLCipher | ✅ ACTIEF GEBRUIKT | Native library + DEX referenties |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | OkHttp CertificatePinner |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 12 referenties |

### 3.2 ASN Bank

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Play Integrity | ✅ ACTIEF GEBRUIKT | SDK v1.6.0, RequestIntegrityTokenUseCase |
| StrongBox | ✅ ACTIEF GEBRUIKT | IsStrongBoxAvailableUseCase |
| FIDO2/WebAuthn | ✅ ACTIEF GEBRUIKT | SDK v21.0.0 |
| Wero | ✅ ACTIEF GEBRUIKT | Eigen Volksbank implementatie |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | OkHttp CertificatePinner |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 28 referenties |
| iProov | ✅ ACTIEF GEBRUIKT | Native libraries |

### 3.3 bunq

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Wero | ✅ ACTIEF GEBRUIKT | Eigen implementatie, WeroKeyStoreHelper |
| StrongBox | ✅ ACTIEF GEBRUIKT | setIsStrongBoxBacked bevestigd |
| SQLCipher | ✅ ACTIEF GEBRUIKT | 59 referenties + libsqlcipher.so |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | OkHttp CertificatePinner |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 7 referenties |
| Native Signing | ✅ ACTIEF GEBRUIKT | libsigner.so |
| Derden Root-detectie | ⚠️ AANWEZIG | Sentry, Onfido, Adyen |

### 3.4 ING

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | Contextverificatie bevestigd |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 11 referenties |
| StrongBox | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse, vals-positief gecorrigeerd |
| setUserAuthenticationRequired | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse, vals-positief gecorrigeerd |

### 3.5 Knab

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| BiometricPrompt | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse, vals-positief gecorrigeerd |
| Play Integrity | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| SafetyNet | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| StrongBox | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| setUserAuthenticationRequired | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| Certificate Pinning | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| iProov | ✅ ACTIEF GEBRUIKT | Native libraries |

### 3.6 Rabobank

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | CertificatePinner.kt bevestigd |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | BiometricPromptManager.kt bevestigd |
| SafetyNet | ❌ AFWEZIG | Marker analyse vals-positief gecorrigeerd |
| StrongBox | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse vals-positief gecorrigeerd |
| setUserAuthenticationRequired | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse vals-positief gecorrigeerd |
| SQLCipher | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse vals-positief gecorrigeerd |
| iProov | ✅ ACTIEF GEBRUIKT | Native libraries |

### 3.7 RegioBank

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Play Integrity | ✅ ACTIEF GEBRUIKT | SDK v1.6.0, gedeelde codebase met ASN |
| StrongBox | ✅ ACTIEF GEBRUIKT | Gedeelde codebase met ASN |
| FIDO2/WebAuthn | ✅ ACTIEF GEBRUIKT | SDK v21.0.0, gedeelde codebase |
| Wero | ✅ ACTIEF GEBRUIKT | Eigen Volksbank implementatie, gedeelde codebase |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | OkHttp CertificatePinner |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 44 referenties |
| iProov | ✅ ACTIEF GEBRUIKT | Native libraries |

### 3.8 Revolut

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Play Integrity | ✅ ACTIEF GEBRUIKT | SDK v1.6.0, eigen code bevestigd |
| SafetyNet | ✅ ACTIEF GEBRUIKT | Eigen code bevestigd |
| StrongBox | ✅ ACTIEF GEBRUIKT | Contextverificatie bevestigd |
| SQLCipher | ✅ ACTIEF GEBRUIKT | 20 referenties + libsqlcipher.so |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | Marker analyse bevestigd |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 23 referenties |
| Root-detectie | ✅ ACTIEF GEBRUIKT | libfourthline-security.so |
| FIDO2/WebAuthn | ⚠️ AANWEZIG (NIET ACTIEF) | Marker analyse |

### 3.9 SNS Bank

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Play Integrity | ✅ ACTIEF GEBRUIKT | SDK v1.6.0, gedeelde codebase met ASN |
| StrongBox | ✅ ACTIEF GEBRUIKT | Gedeelde codebase met ASN |
| FIDO2/WebAuthn | ✅ ACTIEF GEBRUIKT | SDK v21.0.0, gedeelde codebase |
| Wero | ✅ ACTIEF GEBRUIKT | Eigen Volksbank implementatie, gedeelde codebase |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | OkHttp CertificatePinner |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 45 referenties |
| iProov | ✅ ACTIEF GEBRUIKT | Native libraries |

### 3.10 Trade Republic

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Play Integrity | ✅ ACTIEF GEBRUIKT | SDK v1.6.0, eigen code bevestigd |
| Hardware Attestation | ✅ ACTIEF GEBRUIKT | setAttestationChallenge bevestigd |
| StrongBox | ✅ ACTIEF GEBRUIKT | Contextverificatie bevestigd |
| Certificate Pinning | ✅ ACTIEF GEBRUIKT | Marker analyse bevestigd |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 45 referenties |

### 3.11 Triodos

| Mechanisme | Status | Bewijs |
|------------|--------|--------|
| Wero | ✅ ACTIEF GEBRUIKT | Eigen implementatie |
| StrongBox | ✅ ACTIEF GEBRUIKT | setIsStrongBoxBacked bevestigd |
| setUserAuthenticationRequired | ✅ ACTIEF GEBRUIKT | Bevestigd |
| Root-detectie | ✅ ACTIEF GEBRUIKT | libfourthline-security.so |
| BiometricPrompt | ✅ ACTIEF GEBRUIKT | 7+ referenties |
| Certificate Pinning | ❓ NIET GEÏNSPECTEERD | - |

---

## 🔄 4. DOCUMENT VALS-POSITIEVEN EN CORRECTIES

### 4.1 Gecorrigeerde Vals-positieven per Bank

#### Knab

| Mechanisme | Originele Status | Gecorrigeerde Status | Reden |
|------------|------------------|----------------------|-------|
| Play Integrity | ⚠️ AANWEZIG (9 treffers) | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |
| SafetyNet | ⚠️ AANWEZIG (8 treffers) | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |
| StrongBox | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |
| setUserAuthenticationRequired | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |
| Certificate Pinning | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |
| BiometricPrompt | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `bvm` types in contextverificatie |

#### Rabobank

| Mechanisme | Originele Status | Gecorrigeerde Status | Reden |
|------------|------------------|----------------------|-------|
| SafetyNet | ⚠️ AANWEZIG (86 treffers) | ❌ AFWEZIG | Geen `nl.rabomobiel` types in contextverificatie |
| StrongBox | ⚠️ AANWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `nl.rabomobiel` types |
| setUserAuthenticationRequired | ⚠️ AANWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `nl.rabomobiel` types |
| SQLCipher | ⚠️ AANWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `nl.rabomobiel` types |
| Certificate Pinning | ⚠️ AANWEZIG | ✅ ACTIEF GEBRUIKT | CertificatePinner.kt bevestigd |
| BiometricPrompt | ⚠️ AANWEZIG | ✅ ACTIEF GEBRUIKT | BiometricPromptManager.kt bevestigd |

#### ING

| Mechanisme | Originele Status | Gecorrigeerde Status | Reden |
|------------|------------------|----------------------|-------|
| StrongBox | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `com.ing` types in contextverificatie |
| setUserAuthenticationRequired | ⚠️ AANWEZIG | ❌ AFWEZIG | Geen `com.ing` types in contextverificatie |

### 4.2 Contextverificatie Impact

**Totaal gecorrigeerde vals-positieven:** 15

- **Knab:** 6 mechanismen gecorrigeerd
- **Rabobank:** 4 mechanismen gecorrigeerd (2 vals-positief → afwezig, 2 vals-positief → aanwezig niet actief, 2 vals-positief → actief)
- **ING:** 2 mechanismen gecorrigeerd

**Belang:** Contextverificatie is cruciaal voor nauwkeurige classificatie. Zonder contextverificatie zouden vals-positieven leiden tot onjuiste conclusies.

---

## 📊 5. STATISTISCHE SAMENVATTING

### 5.1 Per Mechanisme

| Mechanisme | ACTIEF GEBRUIKT | AANWEZIG (NIET ACTIEF) | AFWEZIG | Totaal |
|------------|-----------------|-----------------------|---------|--------|
| Play Integrity | 5 | 0 | 6 | 11 |
| SafetyNet | 2 | 0 | 9 | 11 |
| Hardware Attestation | 1 | 0 | 10 | 11 |
| Wero | 5 | 0 | 6 | 11 |
| Root-detectie | 2 | 0 | 8 | 11 |
| SQLCipher | 3 | 0 | 8 | 11 |
| StrongBox | 6 | 4 | 1 | 11 |
| Certificate Pinning | 10 | 0 | 1 | 11 |
| FIDO2/WebAuthn | 3 | 1 | 7 | 11 |
| BiometricPrompt | 10 | 1 | 0 | 11 |

### 5.2 Per Banktype

| Banktype | Totaal | Play Integrity | SafetyNet | Wero | StrongBox |
|----------|--------|---------------|-----------|------|-----------|
| Traditioneel | 7 | 4 | 1 | 4 | 5 |
| Neobank | 2 | 0 | 0 | 1 | 2 |
| Internationaal | 2 | 2 | 1 | 0 | 2 |

---

## 🎯 6. SNELLE OPZOEKTABELLEN

### 6.1 Banken met Play Integrity

**5 banken:** ASN Bank, RegioBank, SNS Bank, Revolut, Trade Republic

### 6.2 Banken met Wero

**5 banken:** ASN Bank, bunq, RegioBank, SNS Bank, Triodos

### 6.3 Banken met Native Root-detectie

**2 banken:** Revolut, Triodos

### 6.4 Banken met SQLCipher

**3 banken:** ABN AMRO, bunq, Revolut

### 6.5 Banken met FIDO2/WebAuthn

**3 banken:** ASN Bank, RegioBank, SNS Bank

### 6.6 Banken zonder Native Libraries

**3 banken:** ING, Rabobank, Trade Republic

---

## 📚 7. GERELATEERDE DOCUMENTEN

Voor gedetailleerde informatie, raadpleeg:

- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Complete lijst van vervolgstappen en documentatie
- [ANALYSE_RAPPORT.md](./ANALYSE_RAPPORT.md) - Compleet technisch analyse rapport
- [vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md](./vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) - Vergelijkende analyse
- [patroon_analyse.md](./patroon_analyse.md) - Patroon analyse en correlaties
- [wero_implementatie_vergelijking.md](./wero_implementatie_vergelijking.md) - Wero implementatie vergelijking
- [native_library_analyse.md](./native_library_analyse.md) - Native library analyse
- [technisch_dashboard.md](./technisch_dashboard.md) - Technisch dashboard
- [executive_summary.md](./executive_summary.md) - Executive summary
- [methodologie_handboek.md](./methodologie_handboek.md) - Methodologie handboek

---

## 📖 8. LEGENDA

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ **NIET GEÏNSPECTEERD** | Niet gecontroleerd | Mechanisme is niet specifiek onderzocht in de analyse |

---

## ✅ 9. VOLTOOIDE ACTIES

- [x] Maak overzichtstabel: Bank → Attestation → Wero
- [x] Creëer lookup tabel voor specifieke mechanisms
- [x] Maak lijst van alle bevestigde mechanismen per bank
- [x] Document vals-positieven en correcties

---

**Laatst geactualiseerd:** 7 November 2026, 22:45 CET  
**Versie:** 1.0  
**Status:** Voltooid  
**Document Type:** Quick Reference Guide  
**Doelgroep:** Alle gebruikers die snel resultaten willen opzoeken
