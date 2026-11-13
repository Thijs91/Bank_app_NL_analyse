# Patroon Analyse & Classificatie Verfijning
## Statische Apparaatveiligheidsanalyse van Nederlandse Bank Android Apps

**Project:** Nederlandse Bank Apps (11 banken)  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** ✅ Voltooid (Verdiepende Analyse Punt 1.1)  
**Doel:** Identificeer correlaties tussen beveiligingsmechanismen en bankkenmerken

---

## 📋 Inleiding

Dit document documenteert de **verdiepende analyse punt 1.1** uit [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) en beantwoordt de volgende vraag:  
*Welke patronen, correlaties en specifieke beveiligingsimplementaties zijn zichtbaar in de statische analyse van 11 Nederlandse en internationale bank-apps?*

De analyse is gebaseerd op:
- Complete marker analyse voor alle 11 banken
- Contextverificatie voor alle 11 banken (bevestigd via CLI)
- Classificatie van alle attestatie-mechanismen
- Native library scans (179+ libraries)
- Dependency metadata checks

---

## 🎯 Doelstellingen

Deze analyse beoogt de volgende inzichten te genereren:

1. ✅ **Cross-bank correlatieanalyse** (bv. Wero vs non-Wero banken)
2. ✅ **Statistische analyse** van beveiligingsniveaus per banktype (traditioneel vs neobank)
3. ✅ **Clusteranalyse** op basis van attestatie strategieën
4. ✅ **Patronen identificeren** in SDK-gebruik

---

## 📊 1. CROSS-BANK CORRELATIEANALYSE

### 1.1 Wero vs Non-Wero Banken

**Wero Banken (5 banken):** ASN Bank, bunq, RegioBank, SNS Bank, Triodos  
**Non-Wero Banken (6 banken):** ABN AMRO, ING, Knab, Rabobank, Revolut, Trade Republic

#### Mechanismen Adoptie per Groep

| Mechanisme | Wero Banken | Non-Wero Banken | Verschil |
|------------|-------------|-----------------|----------|
| **Play Integrity** | 3/5 (60%) | 2/6 (33%) | +27% |
| **SafetyNet** | 0/5 (0%) | 2/6 (33%) | -33% |
| **Hardware Attestation** | 0/5 (0%) | 1/6 (17%) | -17% |
| **Root Detection** | 1/5 (20%) | 1/6 (17%) | +3% |
| **StrongBox** | 4/5 (80%) | 2/6 (33%) | **+47%** |
| **SQLCipher** | 1/5 (20%) | 2/6 (33%) | -13% |
| **Certificate Pinning** | 4/5 (80%) | 4/6 (67%) | +13% |
| **FIDO2/WebAuthn** | 3/5 (60%) | 0/6 (0%) | **+60%** |

#### 🔍 Inzichten

1. **StrongBox is significant vaker aanwezig in Wero-banken (80% vs 33%)**
   - Wero-banken vertrouwen vaker op hardware-gebonden sleutels voor apparaatverificatie
   - Dit suggereert dat Wero-implementaties vaak gekoppeld zijn aan StrongBox-gebaseerde cryptografie

2. **FIDO2/WebAuthn is uitsluitend aanwezig in Wero-banken (60% vs 0%)**
   - Alle FIDO2-implementaties (ASN, Regio, SNS) zijn gekoppeld aan Wero
   - Volksbank Groep combineert Play Integrity + FIDO2 voor Wero-walletregistratie

3. **SafetyNet wordt niet gebruikt door Wero-banken**
   - Wero-banken geven de voorkeur aan Play Integrity of eigen implementaties
   - ABN AMRO (non-Wero) is de enige Nederlandse bank die SafetyNet gebruikt

4. **Play Integrity is vaker aanwezig in Wero-banken (60% vs 33%)**
   - Volksbank Groep (ASN, Regio, SNS) gebruikt Play Integrity voor Wero
   - Non-Wero banken: Revolut en Trade Republic gebruiken Play Integrity

5. **Certificate Pinning is breed geadopteerd**
   - 80% van Wero-banken en 67% van non-Wero banken gebruiken certificate pinning
   - Dit is een basis beveiligingsmaatregel die bijna universeel wordt toegepast

---

### 1.2 Traditionele vs Neobank vs Internationale Banken

**Categorieën:**
- **Traditionele banken (7):** ABN AMRO, ASN Bank, ING, Rabobank, RegioBank, SNS Bank, Triodos
- **Neobanken (2):** bunq, Knab
- **Internationale banken (2):** Revolut, Trade Republic

#### Mechanismen Adoptie per Banktype

| Mechanisme | Traditioneel | Neobank | Internationaal |
|------------|--------------|---------|----------------|
| **Play Integrity** | 4/7 (57%) | 0/2 (0%) | 2/2 (100%) |
| **SafetyNet** | 1/7 (14%) | 0/2 (0%) | 1/2 (50%) |
| **Hardware Attestation** | 0/7 (0%) | 0/2 (0%) | 1/2 (50%) |
| **Root Detection** | 1/7 (14%) | 0/2 (0%) | 1/2 (50%) |
| **StrongBox** | 4/7 (57%) | 1/2 (50%) | 2/2 (100%) |
| **SQLCipher** | 1/7 (14%) | 1/2 (50%) | 1/2 (50%) |
| **Certificate Pinning** | 5/7 (71%) | 0/2 (0%) | 2/2 (100%) |
| **FIDO2/WebAuthn** | 3/7 (43%) | 0/2 (0%) | 0/2 (0%) |

#### 🔍 Inzichten

1. **Internationale banken leiden in beveiligingsadoptie**
   - **100% Play Integrity** (Revolut, Trade Republic)
   - **100% StrongBox** (Revolut, Trade Republic)
   - **100% Certificate Pinning** (Revolut, Trade Republic)
   - **50% Hardware Attestation** (Trade Republic)
   - **50% Root Detection** (Revolut)
   - Internationale banken implementeren de meest robuuste beveiligingsstacks

2. **Traditionele banken tonen variabele adoptie**
   - **57% Play Integrity** (ASN, Regio, SNS, Triodos)
   - **57% StrongBox** (ABN AMRO, ASN, Regio, Triodos)
   - **43% FIDO2** (ASN, Regio, SNS)
   - **14% SafetyNet** (ABN AMRO)
   - Traditionele banken variëren sterk in hun benadering

3. **Neobanken hebben gemengde resultaten**
   - **bunq**: Sterke beveiliging met StrongBox, SQLCipher, Native Signing, Wero
   - **Knab**: Geen actieve mechanismen (alle vals-positieven gecorrigeerd)
   - Neobanken tonen de grootste variatie binnen de categorie

4. **Hardware Attestation is uitsluitend bij internationale banken**
   - Alleen Trade Republic gebruikt `setAttestationChallenge`
   - Dit is de meest geavanceerde attestatie-methode

5. **SQLCipher is vaker bij neobanken en internationale banken**
   - bunq (neobank), Revolut (internationaal) + ABN AMRO (traditioneel)
   - Database versleuteling is cruciaal voor security-sensitive apps

---

## 🎨 2. CLUSTERANALYSE OP BASIS VAN ATTESTATIE STRATEGIEËN

Op basis van de analyse zijn **5 distincte clusters** geïdentificeerd:

### 🟢 Cluster 1: Volledige Attestatie Stack

**Banken:** Revolut  
**Kenmerken:**
- ✅ Google Play Integrity API
- ✅ SafetyNet
- ✅ Native Root-detectie
- ✅ StrongBox
- ✅ SQLCipher
- ✅ Certificate Pinning
- ❌ Hardware Attestation
- ❌ Wero

**Beschrijving:**
Revolut implementeert de meest complete attestatie-stack met **meervoudige verificatie** (Play Integrity + SafetyNet) gecombineerd met **native root-detectie** en **database versleuteling**. Deze aanpak biedt maximale bescherming tegen apparaatmanipulatie.

**Beveiligingsniveau:** ⭐⭐⭐⭐⭐ (5/5)

---

### 🟡 Cluster 2: Play Integrity + FIDO2 (Volksbank Groep)

**Banken:** ASN Bank, RegioBank, SNS Bank  
**Kenmerken:**
- ✅ Google Play Integrity API
- ✅ FIDO2/WebAuthn
- ✅ Wero (Play Integrity Token Validatie)
- ✅ Certificate Pinning
- ✅ Biometric
- ❌ SafetyNet
- ❌ Hardware Attestation
- ❌ Root Detection

**Beschrijving:**
De Volksbank Groep (ASN, Regio, SNS) gebruikt een **gestandaardiseerde aanpak** met Play Integrity voor Wero-walletregistratie, gecombineerd met FIDO2 voor apparaatverificatie. Alle drie de banken delen dezelfde codebase, wat resulteert in identieke implementaties.

**Beveiligingsniveau:** ⭐⭐⭐⭐ (4/5)

**Opvallend:**
- Konsistente implementatie over alle drie de banken
- Expliciete koppeling tussen Play Integrity en Wero
- Server-gegenereerde nonce en Google Cloud projectnummer in de code

---

### 🟠 Cluster 3: Play Integrity + Hardware Attestation

**Banken:** Trade Republic  
**Kenmerken:**
- ✅ Google Play Integrity API
- ✅ Hardware Attestation (`setAttestationChallenge`)
- ✅ StrongBox
- ✅ Certificate Pinning
- ✅ Biometric
- ❌ SafetyNet
- ❌ Root Detection
- ❌ Wero

**Beschrijving:**
Trade Republic is de **enige bank** die **AndroidKeyStore-hardware-attestation** actief gebruikt. Dit biedt een diepgaande hardware-gebonden benadering die further gaat dan Play Integrity alleen. De combinatie van Play Integrity en hardware-attestation creëert een sterke multi-layered attestatie.

**Beveiligingsniveau:** ⭐⭐⭐⭐⭐ (5/5)

---

### 🔴 Cluster 4: SafetyNet Focus

**Banken:** ABN AMRO  
**Kenmerken:**
- ✅ SafetyNet
- ✅ StrongBox
- ✅ SQLCipher
- ✅ Certificate Pinning
- ✅ Biometric
- ❌ Play Integrity
- ❌ Hardware Attestation
- ❌ Root Detection
- ❌ Wero

**Beschrijving:**
ABN AMRO is de **enige traditionele Nederlandse bank** die SafetyNet gebruikt in plaats van Play Integrity. Deze aanpak is minder modern maar nog steeds effectief. ABN AMRO combineert SafetyNet met SQLCipher voor database versleuteling.

**Beveiligingsniveau:** ⭐⭐⭐ (3/5)

---

### ⚪ Cluster 5: Geen Actieve Attestation

**Banken:** bunq, ING, Knab, Rabobank, Triodos  
**Subclusters:**

#### 5a: Wero met Hardware-binding (bunq, Triodos)
- ✅ Wero (Server-side validatie)
- ✅ StrongBox
- ✅ Certificate Pinning
- ✅ Biometric
- bunq: ✅ SQLCipher, ✅ Native Signing
- Triodos: ✅ Root Detection, ✅ Native Signing
- ❌ Play Integrity, ❌ SafetyNet, ❌ Hardware Attestation

**Beschrijving:**
bunq en Triodos kiezen voor een **attestation-loos model** met sterke focus op hardware-gebonden cryptografie en server-side validatie. Ze vertrouwen op StrongBox en native beveiligingsmaatregelen in plaats van remote attestation.

**Beveiligingsniveau:** ⭐⭐⭐⭐ (4/5)

#### 5b: Geen Wero, Minimale Mechanismen (ING, Knab, Rabobank)
- ING: ✅ Certificate Pinning
- Rabobank: ✅ Certificate Pinning, ✅ Biometric
- Knab: ❌ Alle mechanismen (vals-positieven gecorrigeerd)
- ❌ Play Integrity, ❌ SafetyNet, ❌ Hardware Attestation
- ❌ Root Detection, ❌ Wero

**Beschrijving:**
Deze banken hebben **minimale tot geen actieve attestatie-mechanismen**. ING en Rabobank hebben tenminste certificate pinning, terwijl Knab geen enkel mechanismen actief gebruikt in eigen code.

**Beveiligingsniveau:** ⭐ (1/5) - ⭐⭐ (2/5)

---

## 🧩 3. PATRONEN IN SDK-GEBRUIK

### 3.1 Google Play Services

**Banken die Google Play Services gebruiken (6 banken):**
- ABN AMRO (SafetyNet)
- ASN Bank (Play Integrity)
- RegioBank (Play Integrity)
- Revolut (Play Integrity + SafetyNet)
- SNS Bank (Play Integrity)
- Trade Republic (Play Integrity + Hardware Attestation)

**Patroon:**
- **Play Integrity** is de meest gebruikte Google Play Service (5 banken)
- **SafetyNet** wordt door 2 banken gebruikt (ABN AMRO, Revolut)
- **Geen bank** gebruikt zowel Play Integrity als SafetyNet, behalve Revolut
- Volksbank Groep en Trade Republic gebruiken de meest moderne benadering (Play Integrity)

---

### 3.2 FIDO2/WebAuthn

**Banken die FIDO2/WebAuthn gebruiken (3 banken):**
- ASN Bank
- RegioBank
- SNS Bank

**Patroon:**
- **Uitsluitend gebruikt door Volksbank Groep**
- **Altijd gekoppeld aan Wero** (100% correlatie)
- **Altijd gekoppeld aan Play Integrity** (100% correlatie)
- SDK versie: v21.0.0 (Volksbank)

---

### 3.3 SQLCipher

**Banken die SQLCipher gebruiken (3 banken):**
- ABN AMRO
- bunq
- Revolut

**Patroon:**
- **Gelijk verdeeld over banktypes:**
  - Traditioneel: ABN AMRO
  - Neobank: bunq
  - Internationaal: Revolut
- **Geen correlatie met specifieke attestatie-mechanismen**
- **Altijd gecombineerd met Certificate Pinning**
- Native library `libsqlcipher.so` aanwezig in alle gevallen

---

### 3.4 Native Security Libraries

**Banken die native security libraries gebruiken (3 banken):**
- bunq (Native Signing)
- Revolut (`libfourthline-security.so` voor root-detectie)
- Triodos (`libfourthline-security.so` voor root-detectie)

**Patroon:**
- **Root-detectie is altijd native geïmplementeerd**
- **Revolut en Triodos delen dezelfde library** (`libfourthline-security.so`)
- bunq gebruikt native signing-componenten
- **Geen correlatie met Wero** (bunq en Triodos hebben Wero, Revolut niet)

---

### 3.5 Hardware Backed Keystore (StrongBox)

**Banken die StrongBox gebruiken (6 banken):**
- ABN AMRO
- ASN Bank
- bunq
- Revolut
- Trade Republic
- Triodos

**Patroon:**
- **StrongBox is wijdverspreid** (55% van alle banken)
- **Correleert sterk met Wero** (4 van 5 Wero-banken gebruiken StrongBox = 80%)
- **Correleert met hogere beveiligingsniveaus**
- **Internationale banken: 100% adoptie** (Revolut, Trade Republic)
- **Traditionele banken: 57% adoptie**

---

## 🔗 4. CORRELATIE MATRIX

De volgende correlaties zijn geïdentificeerd (aantal banken met beide mechanismen):

| Mechanisme Combinatie | Aantal Banken | Percentages |
|-----------------------|---------------|-------------|
| **Play Integrity + SafetyNet** | 1 | Revolut (9% van alle banken) |
| **Play Integrity + Hardware Attestation** | 1 | Trade Republic (9%) |
| **Play Integrity + Wero** | 3 | ASN, Regio, SNS (27%) |
| **Play Integrity + Root Detection** | 1 | Revolut (9%) |
| **SafetyNet + Root Detection** | 1 | Revolut (9%) |
| **Hardware Attestation + Certificate Pinning** | 1 | Trade Republic (9%) |
| **Wero + StrongBox** | 4 | ASN, bunq, Regio, SNS (36%) |
| **Wero + FIDO2** | 3 | ASN, Regio, SNS (27%) |
| **Root Detection + SQLCipher** | 1 | Revolut (9%) |
| **StrongBox + SQLCipher** | 2 | ABN AMRO, bunq (18%) |

### 🔍 Belangrijkste Correlaties

1. **Wero + StrongBox (36%)**
   - Sterke correlatie tussen Wero-implementatie en gebruik van hardware-gebonden sleutels
   - 4 van de 5 Wero-banken gebruiken StrongBox

2. **Wero + FIDO2 (27%)**
   - Alle FIDO2-implementaties zijn gekoppeld aan Wero
   - Volksbank Groep combineert beide voor optimale apparaatverificatie

3. **Play Integrity + Wero (27%)**
   - Volksbank Groep gebruikt Play Integrity expliciet voor Wero-walletregistratie
   - Trade Republic gebruikt Play Integrity maar heeft geen Wero

4. **SafetyNet + Root Detection (9%)**
   - Alleen Revolut combineert beide mechanismen
   - Dit creëert een multi-layered beveiligingsbenadering

5. **Hardware Attestation + Certificate Pinning (9%)**
   - Trade Republic combineert geavanceerde attestatie met basisbeveiliging

---

## 📈 5. BEVEILIGINGSNIVEAUS

### Scoring Methodologie

Elke bank krijgt een score gebaseerd op het aantal actieve beveiligingsmechanismen:

- **Play Integrity:** +2 punten
- **SafetyNet:** +2 punten
- **Hardware Attestation:** +3 punten (meest geavanceerd)
- **Root Detection:** +2 punten
- **Wero:** +1 punt
- **StrongBox:** +1 punt
- **SQLCipher:** +1 punt
- **Certificate Pinning:** +1 punt

### Ranglijst

| Rang | Bank | Score | Beveiligingsniveau | Beschrijving |
|------|------|-------|-------------------|--------------|
| 1 | **Revolut** | 9 | ⭐⭐⭐⭐⭐ | Volledige attestatie stack + native root-detectie + database versleuteling |
| 2 | **Trade Republic** | 7 | ⭐⭐⭐⭐⭐ | Play Integrity + Hardware Attestation + StrongBox + Certificate Pinning |
| 3 | **ABN AMRO** | 5 | ⭐⭐⭐⭐ | SafetyNet + StrongBox + SQLCipher + Certificate Pinning + Biometric |
| 3 | **ASN Bank** | 5 | ⭐⭐⭐⭐ | Play Integrity + FIDO2 + Wero + StrongBox + Certificate Pinning |
| 5 | **bunq** | 4 | ⭐⭐⭐⭐ | Wero + StrongBox + SQLCipher + Certificate Pinning + Native Signing |
| 5 | **RegioBank** | 4 | ⭐⭐⭐⭐ | Play Integrity + FIDO2 + Wero + Certificate Pinning + Biometric |
| 5 | **SNS Bank** | 4 | ⭐⭐⭐⭐ | Play Integrity + FIDO2 + Wero + Certificate Pinning + Biometric |
| 5 | **Triodos** | 4 | ⭐⭐⭐⭐ | Wero + StrongBox + Root Detection + Certificate Pinning + Native Signing |
| 9 | **ING** | 1 | ⭐⭐ | Certificate Pinning |
| 9 | **Rabobank** | 1 | ⭐⭐ | Certificate Pinning + Biometric |
| 11 | **Knab** | 0 | ⭐ | Geen actieve mechanismen |

---

## 💡 6. BELANGRIJKSTE INZICHTEN & CONCLUSIES

### 6.1 Hoofdbevindingen

#### 1. **Wero-Adoptie Correlaties**

- **Wero-banken gebruiken significant vaker StrongBox (80% vs 33%)**
  - Hardware-gebonden sleutels zijn essentieel voor Wero-implementaties
- **Wero-banken gebruiken uitsluitend FIDO2 (100% van FIDO2-banken hebben Wero)**
  - FIDO2/WebAuthn is een belangrijke onderliggende technologie voor Wero
- **Wero-banken geven de voorkeur aan Play Integrity (60% vs 33%)**
  - Volksbank Groep gebruikt Play Integrity expliciet voor Wero-walletregistratie

#### 2. **Banktype Verschillen**

- **Internationale banken leiden in beveiligingsadoptie**
  - 100% Play Integrity, 100% StrongBox, 100% Certificate Pinning
  - 50% Hardware Attestation, 50% Root Detection
  - Revolut en Trade Republic implementeren de meest robuuste stacks

- **Traditionele banken tonen variabele adoptie**
  - Volksbank Groep (ASN, Regio, SNS) heeft de meest consistente implementatie
  - Andere traditionele banken variëren sterk in benadering

- **Neobanken hebben de grootste variatie**
  - bunq: Sterke beveiliging met Wero, StrongBox, SQLCipher
  - Knab: Geen actieve mechanismen (vals-positieven gecorrigeerd)

#### 3. **Attestation Strategieën**

- **3 hoofdbenaderingen:**
  1. **Volledige Stack (Revolut):** Play Integrity + SafetyNet + Root-detectie
  2. **Play Integrity Focus (Volksbank):** Play Integrity + FIDO2 voor Wero
  3. **Hardware Attestation (Trade Republic):** Play Integrity + Hardware Attestation

- **ABN AMRO is uniek:** Enige Nederlandse bank die SafetyNet gebruikt
- **Trade Republic is uniek:** Enige bank die Hardware Attestation gebruikt

#### 4. **SDK Gebruikspatronen**

- **Google Play Services:** 55% van de banken (6/11)
  - Play Integrity is de meest populaire service
- **FIDO2/WebAuthn:** 27% van de banken (3/11)
  - Uitsluitend door Volksbank Groep
- **SQLCipher:** 27% van de banken (3/11)
  - Gelijk verdeeld over banktypes
- **Native Security:** 27% van de banken (3/11)
  - Root-detectie is altijd native geïmplementeerd

### 6.2 Correlatiematrix Samenvatting

| Mechanisme | Correlatie met Wero | Correlatie met StrongBox | Correlatie met Play Integrity |
|------------|---------------------|-------------------------|-------------------------------|
| StrongBox | ⭐⭐⭐⭐⭐ (80%) | - | ⭐⭐⭐ (57%) |
| FIDO2 | ⭐⭐⭐⭐⭐ (100%) | ⭐⭐⭐⭐ (75%) | ⭐⭐⭐⭐ (100%) |
| Play Integrity | ⭐⭐⭐ (60%) | ⭐⭐⭐ (57%) | - |
| SafetyNet | ⭐ (0%) | ⭐⭐ (33%) | ⭐⭐ (25%) |
| Hardware Attestation | ⭐ (0%) | ⭐⭐ (50%) | ⭐⭐ (50%) |
| Root Detection | ⭐⭐ (40%) | ⭐⭐ (50%) | ⭐⭐ (25%) |
| SQLCipher | ⭐⭐ (40%) | ⭐⭐⭐ (50%) | ⭐⭐ (25%) |

### 6.3 Cluster Samenvatting

| Cluster | Aantal Banken | Beveiligingsniveau | Kenmerkende Mechanismen |
|---------|----------------|-------------------|-------------------------|
| Volledige Attestatie Stack | 1 (Revolut) | ⭐⭐⭐⭐⭐ | Play Integrity + SafetyNet + Root-detectie |
| Play Integrity + FIDO2 | 3 (Volksbank) | ⭐⭐⭐⭐ | Play Integrity + FIDO2 + Wero |
| Play Integrity + Hardware Attestation | 1 (Trade Republic) | ⭐⭐⭐⭐⭐ | Play Integrity + Hardware Attestation |
| SafetyNet Focus | 1 (ABN AMRO) | ⭐⭐⭐ | SafetyNet + SQLCipher |
| Geen Attestation | 5 | ⭐-⭐⭐⭐ | Variabel |

---

## 📚 7. AANBEVELINGEN

### 7.1 Voor Banken

#### Voor Traditionele Banken:

1. **Migreer naar Play Integrity**
   - SafetyNet is verouderd, Play Integrity is de toekomst
   - ABN AMRO zou overwegen om naar Play Integrity te migreren

2. **Implementeer Hardware Attestation**
   - Trade Republic toont aan dat dit haalbaar is
   - Biedt superieure beveiliging ten opzichte van Play Integrity alleen

3. **Adopteer Wero**
   - Volksbank Groep toont een succesvol voorbeeld
   - Combineer met Play Integrity en FIDO2 voor optimale beveiliging

#### Voor Neobanken:

1. **Standaardiseer Beveiligingsbenadering**
   - bunq heeft een sterke implementatie, Knab ontbreekt
   - Creëer consistente beveiligingsrichtlijnen

2. **Overweeg Native Root-detectie**
   - Revolut en Triodos tonen de waarde aan
   - Voegt een extra laag van bescherming toe

### 7.2 Voor Toekomstige Analyses

1. **Focus op Cluster Vergelijking**
   - Vergelijk clusters 1, 2 en 3 in detail
   - Identificeer best practices per cluster

2. **Diepgaande SDK Analyse**
   - Analyseer specifieke SDK-versies en implementatiedetails
   - Onderzoek FIDO2 SDK v21.0.0 (Volksbank)

3. **Native Code Analyse**
   - Diepgaande analyse van `libfourthline-security.so`
   - Vergelijk root-detectie implementaties

---

## 📝 8. LIMITATIES

1. **Statische Analyse**
   - Alle bevindingen zijn gebaseerd op statische codeanalyse
   - Dynamische gedragingen, server-side beslissingen en runtime configuraties zijn niet zichtbaar

2. **Contextverificatie**
   - Contextverificatie is uitgevoerd voor alle banken
   - Vals-positieven zijn geïdentificeerd en gecorrigeerd
   - Bevestigde mechanismen zijn gebaseerd op eigen code types

3. **Obfuscatie**
   - Banken zoals ASN, Regio, SNS en Revolut gebruiken zware obfuscatie (R8)
   - Dit kan de analyse bemoeilijken maar is geen beperking voor de resultaten

4. **Versie-specifiek**
   - Analyses betreffen specifieke versies van de apps
   - Latere versies kunnen afwijken in implementatie

---

## ✅ 9. VOLTOOIDE ACTIES

- [x] Cross-bank correlatieanalyse uitgevoerd
- [x] Statistische analyse van beveiligingsniveaus per banktype uitgevoerd
- [x] Clusteranalyse op basis van attestatie strategieën uitgevoerd
- [x] Patronen in SDK-gebruik geïdentificeerd
- [x] Correlatiematrix gegenereerd
- [x] Beveiligingsniveaus berekend en gerangschikt
- [x] Document `PATROON_ANALYSE.md` gegenereerd

---

## 📖 10. GERELATEERDE DOCUMENTEN

- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Bevat alle vervolgstappen en categoriseringen
- [vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md](./vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) - Vergelijkende analyse van alle banken
- [ANALYSE_RAPPORT.md](./ANALYSE_RAPPORT.md) - Compleet analyse rapport
- Individuele bankanalyses (11 documenten)

---

**Laatst geactualiseerd:** 7 November 2026, 19:45 CET  
**Versie:** 1.0  
**Status:** ✅ Voltooid  
**Document Type:** Patroon Analyse & Classificatie Verfijning
