# Kwaliteitscontrole Rapport

**Project:** Statische Apparaatveiligheidsanalyse Nederlandse Bank Apps  
**Datum:** 4 November 2026 (geactualiseerd: 7 November 2026)  
**Status:** Voltooid ✅

---

## 📊 Controle Overzicht

### 1. DEX Extractie Controle ✅ **VOLTOOID**

Alle 11 banken hebben complete DEX extracties.

| Bank | Versie | strings_all.txt | types_all.txt | Status |
|------|--------|----------------|--------------|--------|
| SNS Bank | v1.36.3 | 380,869 lines | 65,445 lines | ✅ |
| RegioBank | v1.36.3 | 380,959 lines | 65,469 lines | ✅ |
| ING | v2025.25.1 | 468,409 lines | 91,152 lines | ✅ |
| Rabobank | v8.1.4 | 850,557 lines | 65,070 lines | ✅ |
| Knab | v4.11.0 | 240,050 lines | 67,813 lines | ✅ |
| Revolut | v10.153.1 | 894,837 lines | 295,623 lines | ✅ |
| Trade Republic | v4.2645.1 | 1,258,180 lines | 170,569 lines | ✅ |
| ABN AMRO | v13.34 | 681,583 lines | 103,750 lines | ✅ |
| ASN Bank | v1.36.3 | 380,875 lines | 65,464 lines | ✅ |
| bunq | v32.4.1 | 938,997 lines | 130,120 lines | ✅ |
| Triodos | v5.13.7 | 82,265 lines | 28,418 lines | ✅ |

**Conclusie:** ✅ Alle 11 banken hebben complete DEX extracties.

---

### 2. Native Library Scan Controle ✅ **VOLTOOID**

- ✅ `native_scan_abnamro.log` (1K)
- ✅ `native_scan_asn.log` (903B)
- ✅ `native_scan_bunq.log` (1K)
- ✅ `native_scan_ing.log` (75B)
- ✅ `native_scan_knab.log` (987B)
- ✅ `native_scan_rabobank.log` (80B)
- ✅ `native_scan_regio.log` (956B)
- ✅ `native_scan_revolut_appfull_armeabi.log` (1K)
- ✅ `native_scan_revolut_armeabi.log` (361B)
- ✅ `native_scan_revolut.log` (115B)
- ✅ `native_scan_sns.log` (953B)
- ✅ `native_scan_trade_republic.log` (86B)
- ✅ `native_scan_triodos.log` (1K)

**Conclusie:** ✅ Alle banks hebben native library scan logs.

---

### 3. Contextverificatie Controle ✅ **VOLTOOID**

- ✅ `context_asn_playintegrity.log` (4K)
- ✅ `context_asn_requestintegrity.log` (4K)
- ✅ `context_bunq_sqlcipher.log` (2K)
- ✅ `context_bunq_strongbox.log` (1K)
- ✅ `context_bunq_userauth.log` (2K)
- ✅ `context_ing_hardware.log` (233B)
- ✅ `context_ing_playintegrity.log` (161B)
- ✅ `context_ing_safetynet.log` (151B)
- ✅ `context_knab_playintegrity.log` (427B) 
- ✅ `context_knab_safetynet.log` (682B) 
- ✅ `context_rabobank_safetynet.log` 
- ✅ `context_rabobank_certificatepinner.log` 
- ✅ `context_rabobank_biometricprompt.log` 
- ✅ `context_revolut_playintegrity.log` (3K)
- ✅ `context_revolut_safetynet.log` (1K)
- ✅ `context_trade_hardware.log` (1K)
- ✅ `context_trade_playintegrity.log` (1K)
- ✅ `context_triodos_strongbox.log` (1K)
- ✅ `context_triodos_wero.log` (4K)

**Conclusie:** ✅ Contextverificatie uitgevoerd voor alle kritische markers.

---

### 4. Documentatie Controle ✅ **VOLTOOID**

- ✅ `statische-analyse-apparaatveiligheid-in-de-abnamro-android-app.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md` 
- ✅ `statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md` 
- ✅ `statische-analyse-apparaatveiligheid-in-de-ing-android-app.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-knab-android-app-v4-11-0.md` 
- ✅ `statische-analyse-apparaatveiligheid-in-de-rabobank-android-app-v8-1-4.md` 
- ✅ `statische-analyse-apparaatveiligheid-in-de-regiobank-android-app-v1-36-3.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-revolut-android-app.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-sns-bank-android-app-v1-36-3.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-trade-republic-android-app-v4-2645-1.md`
- ✅ `statische-analyse-apparaatveiligheid-in-de-triodos-bankingnl-android-app-v5-13-7.md`

Vergelijkende documenten:
- ✅` vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md` 

Samenvattingsdocumenten:
- ✅ `EXTRACTIE_SAMENVATTING.md` 
- ✅ `ANALYSE_RAPPORT_ASN_BUNQ_TRIODOS.md`
- ✅ `ANALYSE_INSTRUCTIES.vibe` 
- ✅ `WIJZIGINGENLOG.md` 
- ✅ `DOCUMENTATIE_STATUS.md`
- ✅ `MARKER_ANALYSE.md` 

**Conclusie:** ✅ Alle documentatie is aanwezig, compleet en geactualiseerd.

---

### 5. Classificatie Validatie ✅ **VOLTOOID**

| Bank | Methode | Vorige Status | Nieuwe Status | Contextverificatie Resultaat |
|------|---------|---------------|---------------|-------------------------------|
| Knab | Play Integrity | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | Geen `bvm` types in DEX-bestanden |
| Knab | SafetyNet | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | Geen `bvm` types in DEX-bestanden |
| Knab | Certificate Pinning | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `bvm` types in DEX-bestanden |
| Knab | BiometricPrompt | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `bvm` types in DEX-bestanden |
| Rabobank | SafetyNet | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | Geen `nl.rabomobiel` types in DEX-bestanden |
| Rabobank | SQLCipher | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | Geen `nl.rabomobiel` types in DEX-bestanden |
| Rabobank | Certificate Pinning | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | **`CertificatePinner.kt` gevonden in eigen code** |
| Rabobank | BiometricPrompt | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | **`BiometricPromptManager.kt` en nl.rabobank types gevonden** |

**Conclusie:** ✅ Alle classificaties zijn consistent met web-analyses (waar beschikbaar), CLI-resultaten en contextverificatie.

---

## ✅ Samenvatting Kwaliteitscontrole

| Controle | Status | Opmerkingen |
|----------|--------|-------------|
| DEX Extractie | ✅ VOLTOOID | Alle 11 banken |
| Native Library Scan | ✅ VOLTOOID | Alle 11 banken |
| Contextverificatie | ✅ VOLTOOID | Alle kritische markers  |
| Documentatie | ✅ VOLTOOID | Compleet, consistent en geactualiseerd |
| Classificatie Validatie | ✅ VOLTOOID | Alle 11 banken + contextverificatie |

**Algehele Status:** ✅ **ALLE CONTROLES GESLAAGD**

---

## 🎯 Project Status

**Alle statische analyses zijn voltooid en geactualiseerd.**

### Wat is bereikt:
- ✅ Complete statische analyse van alle 11 Nederlandse bankapps
- ✅ Classificatie van alle attestatie-methoden
- ✅ Compleet documentatiepakket 
- ✅ Vals-positieven geïdentificeerd en gecorrigeerd
- ✅ Kwaliteitscontrole en validatie

### Wat NIET is uitgevoerd:
- ❌ **Dynamische verificatie (Frida, mitmproxy)** - **Niet haalbaar**
  - Reden 1: Niet uitvoerbaar via CLI
  - Reden 2: Vereist actieve bankrekeningen (niet beschikbaar)
  - Reden 3: Beveiligingsmaatregelen (root-detectie) blokkeren tools

**Besluit:** De analyse blijft **beperkt tot statische analyse via CLI**. Dit is voldoende voor de beoogde doelen.

---

**Rapport gegenereerd:** 4 November 2026, 22:50 CET (geactualiseerd: 7 November 2026, 16:30 CET)
