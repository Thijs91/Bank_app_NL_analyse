# Executive Summary: Apparaatveiligheid en Attestation in Nederlandse Bank Apps
## Statische Analyse van 11 Bank Android Applications

**Project:** Nederlandse Bank Apps  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** ✅ Voltooid (Verdiepende Analyse Punt 2.1)  
**Doel:** Beknopte samenvatting voor niet-technische stakeholders

---

## 📌 Samenvatting

Dit document biedt een samenvatting van de statische analyse van apparatusveiligheidsmechanismen en attestatie-implementaties in **11 Nederlandse en internationale bank-applicaties**. De analyse is volledig gebaseerd op statische code-analyse en CLI-verificatie.

**Belangrijke opmerking:** Dit document maakt **geen waardeoordelen** over de mate van beveiliging van de onderzochte bank-apps.

---

## 📊 1. OVERZICHT VAN HET ONDERZOEK

### 1.1 Onderzochte Banken

| # | Bank | Type | Land | Versie | Pakketnaam |
|---|------|------|------|--------|------------|
| 1 | ABN AMRO | Traditioneel | Nederland | v13.34 | com.abnamro.nl.mobile.payments |
| 2 | ASN Bank | Traditioneel | Nederland | v1.36.3 | nl.devolksbank.asn.bankieren |
| 3 | bunq | Neobank | Nederland | v32.4.1 | com.bunq.android |
| 4 | ING | Traditioneel | Nederland | v2025.25.1 | com.ing.mobile |
| 5 | Knab | Neobank | Nederland | v4.11.0 | bvm.bvmapp |
| 6 | Rabobank | Traditioneel | Nederland | v8.1.4 | nl.rabomobiel |
| 7 | RegioBank | Traditioneel | Nederland | v1.36.3 | nl.devolksbank.regio.bankieren |
| 8 | Revolut | Internationaal | Internationaal | v10.153.1 | com.revolut.revolut |
| 9 | SNS Bank | Traditioneel | Nederland | v1.36.3 | nl.devolksbank.sns.bankieren |
| 10 | Trade Republic | Internationaal | Internationaal | v4.2645.1 | de.traderepublic.app |
| 11 | Triodos | Traditioneel | Nederland | v5.13.7 | com.triodos.bankingnl |

**Totaal:** 11 bank-apps onderzocht

---

## 🎯 2. HOOFDBEVINDINGEN

### 2.1 Attestation Mechanismen Adoptie

| Mechanisme | Aantal Banken | Percentage | Banken |
|------------|---------------|------------|--------|
| **Google Play Integrity API** | 5 | 45% | ASN Bank, RegioBank, SNS Bank, Revolut, Trade Republic |
| **SafetyNet Attestation API** | 2 | 18% | ABN AMRO, Revolut |
| **AndroidKeyStore Hardware Attestation** | 1 | 9% | Trade Republic |
| **Geen Actieve Attestation** | 6 | 55% | bunq, ING, Knab, Rabobank, Triodos (bunq heeft Wero) |

### 2.2 Wero Adoptie

| Status | Aantal Banken | Percentage | Banken |
|--------|---------------|------------|--------|
| **Wero Geïmplementeerd** | 5 | 45% | ASN Bank, bunq, RegioBank, SNS Bank, Triodos |
| **Wero Niet Geïmplementeerd** | 6 | 55% | ABN AMRO, ING, Knab, Rabobank, Revolut, Trade Republic |

### 2.3 Native Security Libraries

| Type | Aantal Banken | Banken |
|------|---------------|--------|
| **SQLCipher (Database Versleuteling)** | 3 | ABN AMRO, bunq, Revolut |
| **Native Root-detectie** | 2 | Revolut, Triodos |
| **iProov (Gezichtsherkenning)** | 4 | ASN Bank, Knab, RegioBank, SNS Bank |
| **Native Signing** | 1 | bunq |
| **Geen Native Libraries** | 3 | ING, Rabobank, Trade Republic |

### 2.4 Hardware Backed Keystore (StrongBox)

| Status | Aantal Banken | Percentage | Banken |
|--------|---------------|------------|--------|
| **StrongBox ACTIEF GEBRUIKT** | 6 | 55% | ABN AMRO, ASN Bank, bunq, Revolut, Trade Republic, Triodos |
| **StrongBox AANWEZIG (NIET ACTIEF)** | 4 | 36% | ING, Knab, Rabobank, SNS Bank |
| **StrongBox AFWEZIG** | 1 | 9% | Trade Republic |

### 2.5 Certificate Pinning

| Status | Aantal Banken | Percentage |
|--------|---------------|------------|
| **ACTIEF GEBRUIKT** | 10 | 91% |
| **NIET GEÏNSPECTEERD** | 1 | 9% | Triodos |

---

## 🏦 3. BANKSPECIFIEK

### 3.1 Volksbank Groep (Gedeelde Codebase)

ASN Bank, RegioBank en SNS Bank delen dezelfde codebase en implementatie.

| Bank | Play Integrity | SafetyNet | Hardware Attestation | Wero | StrongBox | FIDO2/WebAuthn |
|------|---------------|-----------|---------------------|------|-----------|---------------|
| ASN Bank | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| RegioBank | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| SNS Bank | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |

### 3.2 Internationale Banken

| Bank | Play Integrity | SafetyNet | Hardware Attestation | Wero | Root-detectie | SQLCipher |
|------|---------------|-----------|---------------------|------|---------------|------------|
| Revolut | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| Trade Republic | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |

### 3.3 Traditionele Nederlandse Banken (Overig)

| Bank | Play Integrity | SafetyNet | Hardware Attestation | Wero | Native Libraries |
|------|---------------|-----------|---------------------|------|------------------|
| ABN AMRO | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | 28 |
| ING | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | 0 |
| Rabobank | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | 0 |
| Triodos | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | 13 |

### 3.4 Neobanken

| Bank | Play Integrity | SafetyNet | Hardware Attestation | Wero | Native Libraries | SQLCipher |
|------|---------------|-----------|---------------------|------|------------------|------------|
| bunq | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | 40 | ✅ ACTIEF GEBRUIKT |
| Knab | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | 14 | ❌ AFWEZIG |

---

## 🔍 4. WERO-IMPLEMENTATIE

### 4.1 Wero Adoptie Overzicht

**5 banken implementeren Wero (45% van alle banken):**

| Bank | Implementatie Type | Validatiemethode | Attestation Mechanisme |
|------|-------------------|------------------|------------------------|
| ASN Bank | Eigen (Volksbank) | Play Integrity Token Validatie | Google Play Integrity API |
| RegioBank | Eigen (Volksbank) | Play Integrity Token Validatie | Google Play Integrity API |
| SNS Bank | Eigen (Volksbank) | Play Integrity Token Validatie | Google Play Integrity API |
| bunq | Eigen | Server-side Validatie | Hardware-binding |
| Triodos | Eigen | Server-side Validatie | Geen app-side attestation |

**6 banken implementeren Wero niet (55% van alle banken):**
- ABN AMRO
- ING
- Knab
- Rabobank
- Revolut
- Trade Republic

### 4.2 Wero Validatiemethoden

| Methode | Aantal Banken | Banken |
|---------|---------------|--------|
| **Play Integrity Token Validatie** | 3 | ASN Bank, RegioBank, SNS Bank |
| **Server-side Validatie met Hardware-binding** | 1 | bunq |
| **Server-side Validatie** | 1 | Triodos |

### 4.3 Wero SDK Gebruik

- **Extern Wero/EPI SDK:** ❌ Geen van de 5 Wero-banken gebruikt een extern Wero- of EPI-SDK
- **Eigen Implementatie:** ✅ Alle 5 Wero-banken gebruiken een eigen implementatie

---

## 📈 5. STATISTISCHE VERDELING

### 5.1 Per Banktype

| Banktype | Totaal | Play Integrity | SafetyNet | Hardware Attestation | Wero | Native Libraries |
|----------|--------|---------------|-----------|---------------------|------|------------------|
| **Traditioneel** | 7 | 4 | 1 | 0 | 4 | Variabel |
| **Neobank** | 2 | 0 | 0 | 0 | 1 | Variabel |
| **Internationaal** | 2 | 2 | 1 | 1 | 0 | Variabel |

### 5.2 Per Land

| Land | Totaal | Play Integrity | SafetyNet | Hardware Attestation | Wero |
|------|--------|---------------|-----------|---------------------|------|
| **Nederland** | 9 | 4 | 1 | 0 | 4 |
| **Internationaal** | 2 | 2 | 1 | 1 | 0 |

---

## 📊 6. VISUELE DASHBOARDS (ASCII TABELLEN)

### 6.1 Attestation Mechanismen Matrix

```
+------------------+------------------+------------------+------------------+
|                  | Play Integrity   | SafetyNet        | Hardware Attest. |
+------------------+------------------+------------------+------------------+
| ABN AMRO         | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       |
| ASN Bank         | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       |
| bunq             | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| ING              | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Knab             | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Rabobank         | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| RegioBank        | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Revolut          | ✅ ACTIEF        | ✅ ACTIEF        | ❌ AFWEZIG       |
| SNS Bank         | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Trade Republic   | ✅ ACTIEF        | ❌ AFWEZIG       | ✅ ACTIEF        |
| Triodos          | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
+------------------+------------------+------------------+------------------+
| Totaal           | 5 (45%)         | 2 (18%)         | 1 (9%)          |
+------------------+------------------+------------------+------------------+
```

### 6.2 Wero Adoptie Overzicht

```
+------------------+------------------+
| Bank             | Wero Status      |
+------------------+------------------+
| ABN AMRO         | ❌ AFWEZIG       |
| ASN Bank         | ✅ ACTIEF        |
| bunq             | ✅ ACTIEF        |
| ING              | ❌ AFWEZIG       |
| Knab             | ❌ AFWEZIG       |
| Rabobank         | ❌ AFWEZIG       |
| RegioBank        | ✅ ACTIEF        |
| Revolut          | ❌ AFWEZIG       |
| SNS Bank         | ✅ ACTIEF        |
| Trade Republic   | ❌ AFWEZIG       |
| Triodos          | ✅ ACTIEF        |
+------------------+------------------+
| Totaal           | 5 (45%)         |
+------------------+------------------+
```

### 6.3 Native Security Libraries Overzicht

```
+------------------+------------------+------------------+------------------+------------------+
| Bank             | SQLCipher        | Root-detectie    | iProov           | Native Signing   |
+------------------+------------------+------------------+------------------+------------------+
| ABN AMRO         | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| ASN Bank         | ❌ AFWEZIG       | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       |
| bunq             | ✅ ACTIEF        | ❌ AFWEZIG*      | ❌ AFWEZIG       | ✅ ACTIEF        |
| ING              | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Knab             | ❌ AFWEZIG       | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       |
| Rabobank         | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| RegioBank        | ❌ AFWEZIG       | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       |
| Revolut          | ✅ ACTIEF        | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       |
| SNS Bank         | ❌ AFWEZIG       | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       |
| Trade Republic   | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       | ❌ AFWEZIG       |
| Triodos          | ❌ AFWEZIG       | ✅ ACTIEF        | ❌ AFWEZIG       | ❌ AFWEZIG       |
+------------------+------------------+------------------+------------------+------------------+
| Totaal           | 3                | 2                | 4                | 1                |
+------------------+------------------+------------------+------------------+------------------+

* bunq gebruikt derden voor root-detectie (Sentry, Onfido, Adyen)
```

---

## 📋 7. DATASET OMVANG

### 7.1 Analyse Omvang

| Metriek | Waarde |
|---------|--------|
| **Totaal aantal banken** | 11 |
| **Totaal DEX-bestanden** | 93 |
| **Totaal unieke strings** | ~4.000.000+ |
| **Totaal unieke types** | ~1.000.000+ |
| **Totaal native libraries** | 179+ |
| **APK/XAPK bestanden** | 11 |

### 7.2 Per Bank Statistieken

| Bank | DEX-bestanden | Unieke Strings | Native Libraries |
|------|---------------|----------------|------------------|
| Revolut | 22 | 894.837 | 21+ |
| Trade Republic | 5 | 1.258.180 | 0 |
| bunq | 12 | 938.997 | 40 |
| Rabobank | 8 | 850.557 | 0 |
| ABN AMRO | 9 | 681.583 | 28 |
| ING | 7 | 468.409 | 0 |
| ASN Bank | 6 | 380.875 | 14 |
| SNS Bank | 6 | 380.869 | 14 |
| RegioBank | 6 | 380.959 | 14 |
| Knab | 7 | 240.050 | 14 |
| Triodos | 2 | 82.265 | 13 |

---

## 🎯 8. WERO ADOPTIE SAMENVATTING

### 8.1 Wero Implementatie Benaderingen

| Benadering | Aantal Banken | Banken | Kenmerken |
|------------|---------------|--------|-----------|
| **Play Integrity Token Validatie** | 3 | ASN, Regio, SNS | Volksbank Groep, gedeelde codebase, FIDO2/WebAuthn |
| **Server-side met Hardware-binding** | 1 | bunq | Eigen implementatie, native signing, SQLCipher |
| **Server-side Validatie** | 1 | Triodos | Eigen implementatie, native root-detectie |

### 8.2 Wero en Attestation Correlatie

| Wero Status | Play Integrity | SafetyNet | Hardware Attestation | Totaal |
|-------------|---------------|-----------|---------------------|--------|
| **Wero ACTIEF** | 3 | 0 | 0 | 5 |
| **Wero AFWEZIG** | 2 | 2 | 1 | 6 |

### 8.3 Wero SDK Gebruik

- **Extern Wero/EPI SDK:** ❌ Geen van de 11 banken gebruikt een extern Wero- of EPI-SDK
- **Eigen Implementatie:** ✅ Alle 5 Wero-banken gebruiken een eigen implementatie

---

## 📚 9. GERELATEERDE DOCUMENTEN

Voor gedetailleerde technische informatie, raadpleeg:

- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Complete lijst van vervolgstappen en documentatie
- [ANALYSE_RAPPORT.md](./ANALYSE_RAPPORT.md) - Compleet technisch analyse rapport
- [vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md](./vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) - Vergelijkende analyse
- [patroon_analyse.md](./patroon_analyse.md) - Patroon analyse en correlaties
- [wero_implementatie_vergelijking.md](./wero_implementatie_vergelijking.md) - Diepgaande Wero implementatie vergelijking
- [native_library_analyse.md](./native_library_analyse.md) - Native library analyse

---

## 📖 10. TOELICHTING OP DE ANALYSE

### 10.1 Methodologie

- **Analysetype:** Statische code-analyse (geen dynamische analyse)
- **Bronnen:** APK/XAPK bestanden, DEX-bestanden, native libraries, dependency metadata
- **Verificatie:** CLI-contextverificatie voor alle 11 banken
- **Obfuscatie:** Sommige banken gebruiken zware obfuscatie (R8)

### 10.2 Beperkingen

1. **Statische Analyse:** Alleen statische code is geanalyseerd. Dynamische gedragingen, server-side controles en runtime configuraties zijn niet zichtbaar.
2. **Versie-specifiek:** De analyse betreft specifieke versies van de apps. Latere versies kunnen afwijken.
3. **Contextverificatie:** Vals-positieven zijn geïdentificeerd en gecorrigeerd via CLI-contextverificatie.
4. **Native Code:** Native libraries zijn gescand op specifieke strings, maar volledige reverse-engineering is niet uitgevoerd.

### 10.3 Niet Uitgevoerde Analyses

- ❌ **Dynamische Verificatie:** Niet haalbaar via CLI, vereist fysiek apparaat en actieve bankrekeningen
- ❌ **Runtime Gedrag:** Niet zichtbaar in statische analyse
- ❌ **Server-side Controles:** Niet toegankelijk via statische analyse

---

## ✅ 11. VOLTOOIDE ACTIES

- [x] Hoofdbevindingen samengevat in business language
- [x] Visuele dashboards (ASCII tabellen) gemaakt
- [x] Samenvatting van Wero-adoptie status gemaakt

---

**Laatst geactualiseerd:** 7 November 2026, 21:15 CET  
**Versie:** 1.0  
**Status:** ✅ Voltooid  
**Document Type:** Executive Summary voor Stakeholders  
**Doelgroep:** Management, beleidsmakers, niet-technische stakeholders

---

*Dit document bevat alleen feiten en maakt geen waardeoordelen over de mate van beveiliging van de onderzochte bank-apps.*
