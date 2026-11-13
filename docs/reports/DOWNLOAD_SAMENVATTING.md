# Download Samenvatting - Nederlandse Bank Apps

**Datum:** 4 November 2026 (geactualiseerd: 7 November 2026)  
**Taak:** APK's downloaden voor Nederlandse bank apps + statische analyse en contextverificatie

---

## Gedownloade APK's

Succesvol gedownload via apkeep (APKPure):

| # | Bank | Pakket-ID | Bestandsnaam | Grootte | Type | Versie | Status |
|---|---|---|---|---|---|---|---|
| 1 | ASN Bank | `nl.devolksbank.asn.bankieren` | `nl.devolksbank.asn.bankieren.xapk` | 65 MB | XAPK | v1.36.3 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 2 | SNS Bank | `nl.devolksbank.sns.bankieren` | `nl.devolksbank.sns.bankieren.xapk` | 65 MB | XAPK | v1.36.3 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 3 | RegioBank | `nl.devolksbank.regio.bankieren` | `nl.devolksbank.regio.bankieren.xapk` | 60 MB | XAPK | v1.36.3 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 4 | ING | `com.ing.mobile` | `com.ing.mobile.xapk` | 84 MB | XAPK | v2025.25.1 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 5 | Rabobank | `nl.rabomobiel` | `nl.rabomobiel.xapk` | 101 MB | XAPK | v8.1.4 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD (7 Nov 2026)** |
| 6 | Knab | `bvm.bvmapp` | `bvm.bvmapp.xapk` | 102 MB | XAPK | v4.11.0 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD (7 Nov 2026)** |
| 7 | Revolut | `com.revolut.revolut` | `com.revolut.revolut.xapk` | 292 MB | XAPK | v10.153.1 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 8 | Trade Republic | `de.traderepublic.app` | `de.traderepublic.app.xapk` | 192 MB | XAPK | v4.2645.1 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 9 | Triodos Bank | `com.triodos.bankingnl` | `com.triodos.bankingnl.xapk` | 62 MB | XAPK | v5.13.7 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |

Handmatig gedownload:

| # | Bank | Pakket-ID | Bestandsnaam | Grootte | Type | Versie | Status |
|---|---|---|---|---|---|---|---|
| 10 | ABN AMRO | `com.abnamro.nl.mobile.payments` | `com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm` | 72 MB | APKM | v13.34 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |
| 11 | bunq | `com.bunq.android` | `com.bunq.android.apk` | 329 MB | APK | v32.4.1 | ✅ **GEANALYSEERD + CONTEXTVERIFIEERD** |

**Totaal:** 11 van 11 beschikbare banken gedownload en geanalyseerd

---

## ❌ Niet Beschikbare Apps

De volgende apps konden **niet** worden gedownload voor analyse:

| Bank | Pakket-ID | Reden | Status |
|---|---|---|---|
| N26 | `de.number26.android` | Cloudflare bescherming op alle bronnen (APKPure, APKMirror, Aptoide) | **Analyse niet mogelijk** |
| Wero (EPI) | `eu.epicompany.wero.wallet` | Alleen verkeerde APK beschikbaar (Aptoide app store) | **Analyse niet mogelijk** |

**Opmerking:** 
- Pakket-ID's zijn geverifieerd op Google Play (HTTP 200)
- **Wero:** Gedownloade APK had pakket-ID `cm.aptoide.pt` in plaats van `eu.epicompany.wero.wallet`. User heeft deze verwijderd.
- **N26:** Geen bruikbare download bron gevonden
- **bunq:** Handmatig gedownload als directe APK (niet via apkeep)
- **ABN AMRO:** Handmatig gedownload via APKMirror

**Opgelost:**
- ABN AMRO: ✅ Handmatig gedownload via APKMirror (`com.abnamro.nl.mobile.payments_13.34-10261289_apkmirror.com.apkm`)

---

## Analyse Status (7 November 2026)

### ✅ **Voltooid voor alle 11 banken:**

1. **APK Download** - Alle 11 banken ✅
2. **APK Extractie** - Alle 11 banken ✅
3. **DEX Extractie** - Alle 11 banken ✅
4. **Marker Analyse** - Alle 11 banken ✅
5. **Contextverificatie** - Alle 11 banken ✅
6. **Native Library Scan** - Alle 11 banken ✅
7. **Dependency Metadata Check** - Alle 11 banken ✅
8. **Definitieve Classificatie** - Alle 11 banken ✅
9. **Individuele Rapportage** - 13 documenten voor 11 banken ✅
10. **Vergelijkende Analyse** - Alle 11 banken ✅

**Statistieken:**
- **Banken met Play Integrity:** 5 (ASN, SNS, Regio, Revolut, Trade Republic)
- **Banken met SafetyNet:** 2 (ABN AMRO, Revolut)
- **Banken met Hardware Attestation:** 1 (Trade Republic)
- **Banken met Root Detectie:** 2 (Revolut, Triodos)
- **Banken met Wero:** 5 (ASN, SNS, Regio, bunq, Triodos)

---

## Alternatieve Download Methoden

### 1. APKMirror (Aanbevolen)
Bezoek in browser:
- **ABN AMRO:** https://www.apkmirror.com/apk/abn-amro-bank-n-v/abn-amro/
- **N26:** https://www.apkmirror.com/apk/n26-gmbh/n26-bank/
- **Wero:** https://www.apkmirror.com/apk/european-payments-initiative-epi/wero/

Download de nieuwste versie (APK of XAPK) en plaats in `/home/thijs/Downloads/Bank apps/`

### 2. Aptoide
Bezoek: https://en.aptoide.com/ en zoek op de app naam.

### 3. apkeep met Google Play
Vereist Google authenticatie:
```bash
./apkeep -a com.abnamro.nl.mobile.payments -d google-play -e <email> --oauth-token <token> .
```
Zie: https://github.com/EFForg/apkeep voor authenticatie-instructies

### 4. Handmatige APKPure Download
1. Bezoek: https://m.apkpure.com/
2. Zoek op de pakket-ID
3. Klik op "Download APK" (vereist mogelijk CAPTCHA)
4. Plaats de gedownloade APK/XAPK in de directory

---

## Gemaakte Bestanden

1. **`ANALYSE_INSTRUCTIES.vibe`** - Complete instructies voor statische analyse
   - Bevat stappenplan voor elke APK
   - Inclusief scripts en classificatiecriteria
   - Referentie naar bestaande analyses

2. **`download_missing_apks.sh`** - Script voor handmatige downloads
   - Lijst van ontbrekende APK's
   - Alternatieve download methoden
   - Status check

3. **Extracted directories** - `extracted/<bank>/` voor alle 11 banken

4. **Log bestanden** - Native scans en contextverificatie logs

---

## Volgende Stappen

✅ **Alle stappen zijn voltooid voor de beschikbare 11 banken:**

1. ✅ **Download ontbrekende APK's** - Alle 11 banken gedownload
2. ✅ **Voer analyse uit** volgens `ANALYSE_INSTRUCTIES.vibe` - Alle 11 banken geanalyseerd
3. ✅ **Documenteer bevindingen** in separate md-bestanden per app - 13 documenten gegenereerd
4. ✅ **Vergelijk resultaten** - Algehele vergelijkingstabel gegenereerd
5. ✅ **Contextverificatie** - CLI-verificatie 

**Niet haalbaar:**
- ❌ Dynamische verificatie (Frida, mitmproxy) - Technisch niet haalbaar via CLI

---

## Status Overzicht

| Bank | Download Status | Extractie Status | Analyse Status | Contextverificatie Status |
|---|---|---|---|---|
| bunq | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| ASN Bank | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| SNS Bank | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| RegioBank | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| ING | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| ABN AMRO | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| Rabobank | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| Knab | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| Revolut | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| Trade Republic | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| Triodos Bank | ✅ Gedownload | ✅ Geëxtraheerd | ✅ Geanalyseerd | ✅ Bevestigd |
| N26 | ❌ Download mislukt | ❌ Niet mogelijk | ❌ Niet mogelijk | ❌ Niet mogelijk |
| Wero (EPI) | ❌ Verkeerde APK | ❌ Niet mogelijk | ❌ Niet mogelijk | ❌ Niet mogelijk |

---

## Opmerkingen

- Alle APK's zijn opgeslagen als **XAPK-bundels** (behalve bunq, ABN AMRO die als directe APK/APKM zijn gedownload)
- XAPK-bundels moeten eerst worden uitgepakt voor analyse
- Gebruik de scripts uit `stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md`
- De analyse moet volgen de methodiek beschreven in de bestaande documenten
- **Alle 11 banken zijn volledig geanalyseerd met CLI-contextverificatie**

---

**Laatste update:** 7 November 2026, 16:30 CET
