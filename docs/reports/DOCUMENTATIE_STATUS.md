# Documentatie Status Rapport

**Project:** Statische Apparaatveiligheidsanalyse Nederlandse Bank Apps  
**Datum:** 4 November 2026  
**Status:** **COMPLEET** ✅

---

## 🎯 **Antwoord op de Vragen**

### 1. Is alle documentatie bijgewerkt waar nodig?

**Antwoord:** ✅ **JA** - Alle documentatie is nu compleet en bijgewerkt

### 2. Zijn voor alle 11 banken de zelfde analyses uitgevoerd?

**Antwoord:** ✅ **JA** - Voor alle 11 banken zijn dezelfde **statische** analyses uitgevoerd

**Belangrijke opmerking:** Dynamische analyses (Frida, mitmproxy) zijn **NIET** uitgevoerd omdat:
- Niet haalbaar via CLI
- Vereisen actieve bankrekeningen (niet beschikbaar)
- Beveiligingsmaatregelen blokkeren deze tools

---

## 📊 **Analyse Status per Bank**

### ✅ **Complete Statische Analyse + Documentatie (11 banks)**

| Bank | Versie | Pakket-ID | Analyse | Individueel Rapport | Status |
|------|--------|-----------|---------|---------------------|--------|
| **SNS Bank** | v1.36.3 | `nl.devolksbank.sns.bankieren` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **RegioBank** | v1.36.3 | `nl.devolksbank.regio.bankieren` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **ING** | v2025.25.1 | `com.ing.mobile` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **Rabobank** | v8.1.4 | `nl.rabomobiel` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **Knab** | v4.11.0 | `bvm.bvmapp` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **Revolut** | Onbekend | `com.revolut.revolut` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **Trade Republic** | v4.2645.1 | `de.traderepublic.app` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **ABN AMRO** | v13.34 | `com.abnamro.nl.mobile.payments` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |
| **ASN Bank** | v1.36.3 | `nl.devolksbank.asn.bankieren` | ✅ Voltooid | ✅ **Ja (2x)** | ✅ Compleet |
| **bunq** | v32.4.1 | `com.bunq.android` | ✅ Voltooid | ✅ **Ja (2x)** | ✅ Compleet |
| **Triodos** | v5.13.7 | `com.triodos.bankingnl` | ✅ Voltooid | ✅ **Ja** | ✅ Compleet |

**Opmerking:** Alle banken hebben **statische analyse** ondergaan. **Geen bank mist analyse stappen.**

---

## 📁 **Beschikbare Data voor Alle 11 Banken**

### ✅ **Statische Analyse Data (Alle 11)**
- `extracted/<bank>/dex_out/strings_all.txt`
- `extracted/<bank>/dex_out/types_all.txt`
- `native_scan_<bank>.log`
- `context_<bank>_<marker>.log` (voor kritische markers)
- `extracted/<bank>/*.properties`
- `dependencies_<bank>.txt`

---

## 📄 **Beschikbare Documentatie**

### ✅ **Individuele Analyse Documenten (13 documenten voor 11 banks)**

1. **SNS Bank** - `statische-analyse-apparaatveiligheid-in-de-sns-bank-android-app-v1-36-3.md`
2. **RegioBank** - `statische-analyse-apparaatveiligheid-in-de-regiobank-android-app-v1-36-3.md`
3. **ING** - `statische-analyse-apparaatveiligheid-in-de-ing-android-app.md`
4. **Rabobank** - `statische-analyse-apparaatveiligheid-in-de-rabobank-android-app-v8-1-4.md`
5. **Knab** - `statische-analyse-apparaatveiligheid-in-de-knab-android-app-v4-11-0.md`
6. **Revolut** - `statische-analyse-apparaatveiligheid-in-de-revolut-android-app.md`
7. **Trade Republic** - `statische-analyse-apparaatveiligheid-in-de-trade-republic-android-app-v4-2645-1.md`
8. **ABN AMRO** - `statische-analyse-apparaatveiligheid-in-de-abnamro-android-app.md`
9. **ASN Bank** - `statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3.md` (web)
10. **ASN Bank** - `statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3-CLI.md` (CLI)
11. **bunq** - `statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1.md` (web)
12. **bunq** - `statische-analyse-apparaatveiligheid-in-de-bunq-android-app-v32-4-1-CLI.md` (CLI)
13. **Triodos** - `statische-analyse-apparaatveiligheid-in-de-triodos-bankingnl-android-app-v5-13-7.md`

### ✅ **Vergelijkende Documenten (2)**
1. `vergelijking-apparaatveiligheid-in-de-bunq-en-asn-bank-android-apps.md` (ASN + bunq)
2. `vergelijking-apparaatveiligheid-in-de-asn-bunq-triodos-bank-android-apps.md` (ASN + bunq + Triodos)

### ✅ **Samenvattingsdocumenten (5)**
1. `SAMENVATTING_ANALYSE.md` - Compleet overzicht
2. `ANALYSE_RAPPORT_ASN_BUNQ_TRIODOS.md` - Compleet analyse rapport
3. `WIJZIGINGENLOG.md` - Wijzigingenlogboek
4. `KWALITEITSCONTROLE_RAPPORT.md` - Kwaliteitscontrole rapport
5. `DOCUMENTATIE_STATUS.md` - Documentatie status (dit document)

### ✅ **Instructie Documenten (2)**
1. `stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md`
2. `DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md` - Bronopbouw van statische-analyse documenten
3. `VERVOLGSTAPPEN.md` (geüpdatet)

---

## 📊 **Samenvatting**

| Aspect | Status | Aantal |
|--------|--------|--------|
| **Statische analyses** voor alle 11 banken | ✅ Voltooid | 11 |
| Individuele documentatie | ✅ Voltooid | 13 documenten |
| Vergelijkende documentatie | ✅ Voltooid | 2 documenten |
| Samenvattingsdocumentatie | ✅ Voltooid | 5 documenten |
| Kwaliteitscontrole | ✅ Voltooid | 1 rapport |
| **Dynamische analyses (Frida/mitmproxy)** | ❌ **Niet haalbaar** | 0 |

**Conclusie:** ✅ **ALLE STATISCHE ANALYSES ZIJN COMPLEET EN GEDOCUMENTEERD**

- Alle 11 banken hebben **individuele analyzedocumenten**
- Alle 11 banken hebben **complete statische analyse data**
- Alle 11 banken hebben **classificaties**
- **Geen bank mist statische analyse stappen of documentatie**
- **Dynamische verificatie is niet uitgevoerd (niet haalbaar)**

---

## 🎯 **Classificatie Overzicht (Alle 11 Banken)**

| Bank | Play Integrity | SafetyNet | Hardware Att. | Root Detectie |
|------|---------------|-----------|---------------|---------------|
| **SNS Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **RegioBank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **ING** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Rabobank** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Knab** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Revolut** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Trade Republic** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **ABN AMRO** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG |
| **ASN Bank** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **bunq** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Triodos** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Wero (EPI)** | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd |
| **N26** | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd | ❌ Niet geanalyseerd |

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |

---

## ❌ **Niet Uitgevoerde Analyses**

### **Dynamische Verificatie (Frida, mitmproxy)**

**Redenen waarom NIET uitgevoerd:**

1. **Technisch niet haalbaar via CLI**
   - Frida en mitmproxy vereisen een running Android apparaat/emulator
   - CLI-tools kunnen deze runtime analyses niet uitvoeren
   - Geen toegang tot fysieke apparaten in deze omgeving

2. **Geen bankrekeningen beschikbaar**
   - Elke bank vereist een actieve rekening
   - Ingelogde sessie vereist voor Wero-transacties
   - User heeft geen rekeningen bij de geanalyseerde banken

3. **Beveiligingsmaatregelen blokkeren tools**
   - Triodos en Revolut hebben native root-detectie
   - Frida-gadget zou gedetecteerd worden
   - Apparaat zou geblokkeerd worden

**Besluit:** De analyse **blijft beperkt tot statische analyse via CLI**. Dit is voldoende voor de beoogde doelen van attestatie-classificatie.

---

**Document gegenereerd:** 4 November 2026, 22:50 CET  
**Status:** COMPLEET ✅
