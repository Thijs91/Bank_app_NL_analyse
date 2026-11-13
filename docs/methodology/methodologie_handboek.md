# Methodologie Handboek
## Statische Apparaatveiligheidsanalyse van Nederlandse Bank Android Apps

**Project:** Nederlandse Bank Apps (11 banken)  
**Datum:** 7 November 2026  
**Versie:** 1.0  
**Status:** Voltooid   
**Doel:** Compleet handboek voor toekomstige analyses

---

## 📋 Inleiding

Dit document biedt een **compleet methodologie handboek** voor het uitvoeren van statische apparatuurveiligheidsanalyses op Android bank-applicaties. Het consolideert alle bestaande methodologie documenten, beschrijft het stapsgewijze analyseproces, documenteren alle gebruikte tools en scripts, en biedt een troubleshooting gids.

**Doelgroep:** Iedereen die de analyse wil reproduceren of uitbreiden.

**Belangrijke opmerking:** Dit handboek is **feitelijk en objectief** en bevat geen waardeoordelen over de mate van beveiliging van de onderzochte bank-apps.

---

## 📚 1. CONSOLIDATIE VAN BESTAANDE METHODOLOGIE DOCUMENTEN

### 1.1 Gerelateerde Documenten

De volgende documenten vormen de basis voor deze methodologie:

1. **[stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md](./stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md)**
   - Complete, reproduceerbare werkwijze
   - 10 stappen voor statische analyse
   - Scripts en commandos

2. **[DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md](./DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md)**
   - Bronopbouw van analyse documenten
   - Informatie stroom van bron naar document
   - Consistentie waarborging

3. **[ANALYSE_INSTRUCTIES.vibe](./ANALYSE_INSTRUCTIES.vibe)**
   - Master instructie document
   - Documentatie structuur
   - Voortgang tracking

### 1.2 Samenvatting van Stappenplan

Het stappenplan beschrijft een **10-stappen proces** voor statische analyse:

1. **APK-verwerving** (apkeep)
2. **Uitpakken** (unzip)
3. **Manifest-meting** (axml_min.py)
4. **DEX-extractie** (dex_extract.py)
5. **Marker analyse** (marker_analyse.sh)
6. **Contextverificatie** (dex_locate.py)
7. **Native library scan** (native_scan.py)
8. **Dependency metadata check**
9. **Definitieve classificatie**
10. **Documentatie generatie**

---

## 🎯 2. STAPSGEWIJZE ANALYSE PROCES

### 2.1 Overzicht van het Proces

```
┌─────────────────────────────────────────────────────────────────────┐
│                        STATISCHE ANALYSE PROCES                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  STAP 1: APK VERWERVING                                              │
│  ├─ apkeep (Download APK/XAPK)                                     │
│  └─ Curl (Verificatie pakket-ID)                                   │
│                                                                     │
│  STAP 2: UITPAKKEN                                                  │
│  ├─ unzip (APK)                                                    │
│  └─ unzip (XAPK → basis-APK + splits)                              │
│                                                                     │
│  STAP 3: MANIFEST METING                                           │
│  └─ axml_min.py (Package, Version, SDK)                             │
│                                                                     │
│  STAP 4: DEX EXTRACTIE                                             │
│  └─ dex_extract.py (strings_all.txt, types_all.txt)                │
│                                                                     │
│  STAP 5: MARKER ANALYSE                                            │
│  └─ marker_analyse.sh (Attestation markers)                         │
│                                                                     │
│  STAP 6: CONTEXTVERIFICATIE                                         │
│  └─ dex_locate.py (Eigen code types bevestigen)                     │
│                                                                     │
│  STAP 7: NATIVE LIBRARY SCAN                                       │
│  └─ native_scan.py (Root-detectie, SQLCipher, Keystore)            │
│                                                                     │
│  STAP 8: DEPENDENCY METADATA CHECK                                 │
│  └─ properties bestanden (SDK versies)                            │
│                                                                     │
│  STAP 9: DEFINITIEVE CLASSIFICATIE                                 │
│  └─ Consolidatie van alle resultaten                               │
│                                                                     │
│  STAP 10: DOCUMENTATIE GENERATIE                                   │
│  └─ Individuele analyse documenten                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Gedetailleerde Stappen

#### Stap 1: APK Verwerving

**Doel:** Download de APK/XAPK bestanden van de target bank-apps.

**Tools:**
- `apkeep` (standalone Rust-binary)
- `curl` (voor pakket-ID verificatie)

**Commandos:**

```bash
# apkeep downloaden
curl -sL -o apkeep "https://github.com/EFForg/apkeep/releases/download/0.17.0/apkeep-x86_64-unknown-linux-gnu"
chmod +x apkeep

# APK downloaden (voor 1 bank)
./apkeep -a <PAKKET-ID> .

# Voorbeeld: ASN Bank
./apkeep -a nl.devolksbank.asn.bankieren .

# Voorbeeld: bunq
./apkeep -a com.bunq.android .

# Pakket-ID verifiëren (HTTP status check)
curl -sL -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "https://play.google.com/store/apps/details?id=<PAKKET-ID>"
```

**Aandachtspunten:**
- Standaardbron is APKPure
- Sommige apps zijn `.apk`, andere `.xapk` bundels
- XAPK is een zip met basis-APK + configuratie-splits
- Verkeerde pakket-ID's geven stille mislukking
- Downloads >300 MB vereisen verhoogde timeout (280 seconden)

**Output:**
- `<app>.apk` of `<app>.xapk` in de werkdirectory

---

#### Stap 2: Uitpakken

**Doel:** Pak de APK/XAPK uit om toegang te krijgen tot de interne bestanden.

**Tools:**
- `unzip`

**Commandos:**

```bash
# APK-variant (direct uitpakken)
unzip -o <app>.apk -d extracted/<bank>

# XAPK-variant (eerst bundel uitpakken)
unzip -o <app>.xapk -d xapk
unzip -o xapk/<basis-apk> -d extracted/<bank>

# Configuratie splits uitpakken (native libraries)
unzip -o xapk/config.arm64_v8a.apk -d extracted/<bank>/libs
```

**Directory Structuur na Uitpakken:**
```
extracted/<bank>/
├── app/
│   ├── AndroidManifest.xml          # Binair AXML
│   ├── classes.dex                 # DEX-bestanden
│   ├── classes2.dex
│   ├── ...
│   └── *.properties                 # SDK metadata
└── libs/lib/arm64-v8a/*.so          # Native libraries (als XAPK)
```

**Output:**
- `extracted/<bank>/` directory met alle uitgepakte bestanden

---

#### Stap 3: Manifest Meting (Versie)

**Doel:** Lees de AndroidManifest.xml om pakket-ID, versie, en SDK informatie te verkrijgen.

**Tools:**
- `axml_min.py` (Python script)

**Script:**

```python
import struct, sys

def parse_string_pool(data, off):
    typ, hdr_size, size, count, style_count, flags, strings_start, styles_start = struct.unpack_from('<HHIIIIII', data, off)
    utf8 = bool(flags & (1 << 8))
    offsets = [struct.unpack_from('<I', data, off + hdr_size + i * 4)[0] for i in range(count)]
    base = off + strings_start
    out = []
    for o in offsets:
        p = base + o
        if utf8:
            n = data[p]; p += 1
            if n & 0x80: p += 1
            n2 = data[p]; p += 1
            if n2 & 0x80: p += 1
            e = data.index(b'\x00', p)
            out.append(data[p:e].decode('utf-8', errors='replace'))
        else:
            n = struct.unpack_from('<H', data, p)[0]; p += 2
            if n & 0x8000:
                n = ((n & 0x7fff) << 16) | struct.unpack_from('<H', data, p)[0]; p += 2
            out.append(data[p:p + n * 2].decode('utf-16-le', errors='replace'))
    return out, off + size

def main(path):
    data = open(path, 'rb').read()
    strings, p = parse_string_pool(data, 8)
    found = 0
    while p + 8 <= len(data) and found < 1:
        typ, hdr, sz = struct.unpack_from('<HHI', data, p)
        if typ == 0x0102:  # START_ELEMENT
            attr_start, attr_size, attr_count = struct.unpack_from('<HHH', data, p + 24)
            base = p + 16 + attr_start
            for i in range(attr_count):
                a = base + i * attr_size
                a_ns, a_name, a_raw = struct.unpack_from('<III', data, a)
                dtype, dval = struct.unpack_from('<BI', data, a + 15)
                aname = strings[a_name] if a_name < len(strings) else '?'
                if a_raw != 0xFFFFFFFF and a_raw < len(strings):
                    val = strings[a_raw]
                elif dtype == 0x03 and dval < len(strings):
                    val = strings[dval]
                elif dtype in (0x10, 0x11):
                    val = str(dval)
                else:
                    val = f"type{dtype}:{dval}"
                print(f"{aname} = {val}")
            found += 1
        if sz == 0: break
        p += sz

if __name__ == '__main__':
    main(sys.argv[1])
```

**Commandos:**

```bash
# Manifest uitvoeren
python3 axml_min.py extracted/<bank>/app/AndroidManifest.xml

# Voorbeeld output:
# package = nl.devolksbank.asn.bankieren
# versionName = 1.36.3
# versionCode = 139
```

**Output:**
- Pakket-ID, versionName, versionCode

---

#### Stap 4: DEX Extractie

**Doel:** Extractie van strings en types uit DEX-bestanden.

**Tools:**
- `dex_extract.py` (Python script)

**Script:**

Zie [dex_extract.py](./dex_extract.py) voor het complete script.

**Commandos:**

```bash
# DEX extractie voor 1 bank
python3 dex_extract.py extracted/<bank>/app extracted/<bank>/dex_out

# Voorbeeld: ASN Bank
python3 dex_extract.py extracted/asn/app extracted/asn/dex_out

# Batch extractie voor alle banken
for bank in asn regio sns ing rabobank knab revolut trade_republic abnamro bunq triodos; do
    echo "🔍 DEX Extractie: $bank"
    python3 dex_extract.py extracted/$bank/app extracted/$bank/dex_out
    echo ""
done
```

**DEX Header Offsets:**
- `string_ids_size/off`: offset 0x38/0x3C (ULEB128-lengte plus MUTF-8-gegevens)
- `type_ids_size/off`: offset 0x40/0x44

**Output:**
- `extracted/<bank>/dex_out/strings_all.txt` - Alle unieke strings
- `extracted/<bank>/dex_out/types_all.txt` - Alle unieke types

---

#### Stap 5: Marker Analyse

**Doel:** Zoeken naar attestatie markers in DEX strings_all.txt bestanden.

**Tools:**
- `marker_analyse.sh` (Bash script)

**Script:**

Zie [marker_analyse.sh](./marker_analyse.sh) voor het complete script.

**Commandos:**

```bash
# Marker analyse voor alle banken
bash marker_analyse.sh

# Handmatige marker analyse voor 1 bank
# Zoeken naar Play Integrity markers
grep -iE "play.core.integrity|playintegrity|IntegrityManager|StandardIntegrityManager|requestIntegrityToken|cloudProjectNumber" extracted/<bank>/dex_out/strings_all.txt | wc -l

# Zoeken naar SafetyNet markers
grep -iE "safetynet|SafetyNetClient" extracted/<bank>/dex_out/strings_all.txt | wc -l
```

**Marker Categorien:**

| Categorie | Patterns |
|-----------|----------|
| **Play Integrity** | play.core.integrity, playintegrity, IntegrityManager, StandardIntegrityManager, requestIntegrityToken, cloudProjectNumber |
| **SafetyNet** | safetynet, SafetyNetClient |
| **Hardware Attestation** | setAttestationChallenge, attestationChallenge, attestationTypes, KeyAttestation |
| **Android Keystore** | AndroidKeyStore, setIsStrongBoxBacked, IsStrongBoxAvailable, setUserAuthenticationRequired |
| **Biometrie** | BiometricPrompt, CryptoObject, KeyPermanentlyInvalidatedException |
| **Certificate Pinning** | CertificatePinner |
| **FIDO2** | play-services-fido, FIDO2_, attestationConveyancePreference |
| **SQLCipher** | SQLCipher, libsqlcipher |

**Output:**
- `marker_results.log` - Complete marker analyse resultaten

---

#### Stap 6: Contextverificatie

**Doel:** Verifiëren dat markers daadwerkelijk in eigen code van de bank worden gebruikt (niet vals-positieven).

**Tools:**
- `dex_locate.py` (Python script)

**Script:**

Zie [dex_locate.py](./dex_locate.py) voor het complete script.

**Commandos:**

```bash
# Contextverificatie voor Play Integrity (ASN Bank)
python3 dex_locate.py extracted/asn/app play.core.integrity devolksbank

# Contextverificatie voor SafetyNet (Rabobank)
python3 dex_locate.py extracted/rabobank/app safetynet rabobank

# Contextverificatie voor Hardware Attestation (Trade Republic)
python3 dex_locate.py extracted/trade_republic/app setAttestationChallenge traderepublic

# Batch contextverificatie voor alle banken
for bank in asn regio sns ing rabobank knab revolut trade_republic abnamro bunq triodos; do
    for marker in "play.core.integrity" "safetynet" "setAttestationChallenge"; do
        echo "🔍 Contextverificatie: $bank - $marker"
        python3 dex_locate.py extracted/$bank/app $marker $bank > logs/context_${bank}_${marker}.log 2>&1
    done
done
```

**Hoe het werkt:**
1. Zoekt naar markers in DEX-bestanden
2. Filtert op bank-specifieke types (bijv. `nl.devolksbank` voor ASN)
3. Toont string-treffers en type-treffers
4. Bevestigt of markers in eigen code worden gebruikt

**Output:**
- `context_<bank>_<marker>.log` - Contextverificatie logs

---

#### Stap 7: Native Library Scan

**Doel:** Scannen van native libraries (.so bestanden) op JNI referenties naar keystore methoden en root-detectie patronen.

**Tools:**
- `native_scan.py` (Python script)

**Script:**

Zie [native_scan.py](./native_scan.py) voor het complete script.

**Commandos:**

```bash
# Native library scan voor 1 bank
python3 native_scan.py extracted/<bank>/libs/lib/arm64-v8a/

# Batch native library scan voor alle banken
for bank in asn regio sns ing rabobank knab revolut trade_republic abnamro bunq triodos; do
    echo "🔍 Native scan: $bank"
    python3 native_scan.py "extracted/$bank/libs/lib/arm64-v8a/" > logs/native_scan_${bank}.log 2>&1
done
```

**Gescande Patterns:**
- `setAttestationChallenge`
- `setUserAuthenticationRequired`
- `setIsStrongBoxBacked`
- `KeyGenParameterSpec`
- `AndroidKeyStore`
- `frida`
- `xposed`
- `magisk`
- `KeyPermanentlyInvalidatedException`
- `BiometricPrompt`
- `CryptoObject`
- `SQLCipher`
- `libsqlcipher`

**Output:**
- `native_scan_<bank>.log` - Native library scan logs

---

#### Stap 8: Dependency Metadata Check

**Doel:** Controleren welke SDK's gebundeld zijn in de app.

**Commandos:**

```bash
# Dependencies checken voor 1 bank
ls -1 "extracted/<bank>/app/*.properties" | grep -iE "(integrity|safetynet|fido|keystore|sqlcipher)"

# Batch dependency check voor alle banken
for bank in asn regio sns ing rabobank knab revolut trade_republic abnamro bunq triodos; do
    echo "🔍 Dependencies: $bank"
    ls -1 "extracted/$bank/app/*.properties" 2>/dev/null | grep -iE "(integrity|safetynet|fido|keystore|sqlcipher)" > logs/dependencies_${bank}.txt 2>&1
done
```

**Belangrijke Properties Bestanden:**
- `integrity.properties` - Play Integrity SDK versie
- `play-services-fido.properties` - FIDO2 SDK versie
- `safetynet.properties` - SafetyNet SDK versie

**Output:**
- `dependencies_<bank>.txt` - Dependency metadata

---

#### Stap 9: Definitieve Classificatie

**Doel:** Consolidatie van alle analyse resultaten om de definitieve classificatie te bepalen.

**Process:**
1. Combineer resultaten van marker analyse, contextverificatie, en native library scan
2. Corrigeer vals-positieven (markers die niet in eigen code worden gebruikt)
3. Bepaal definitieve status voor elk mechanisme
4. Document bewijsmateriaal voor elke classificatie

**Classificatie Status:**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ **NIET GEÏNSPECTEERD** | Niet gecontroleerd | Mechanisme is niet specifiek onderzocht in de analyse |

---

#### Stap 10: Documentatie Generatie

**Doel:** Genereren van de individuele analyse documenten.

**Template:**
Zie de bestaande analyse documenten voor het template:
- `statische-analyse-apparaatveiligheid-in-de-<bank>.md`

**Inhoud:**
- Kernbevindingen
- Bewijs per attestation-methode
- Wel aanwezige beveiligingsmechanismen
- Wero-specifiek (indien van toepassing)
- Native library scan resultaten
- Beperkingen van de analyse
- Reproductie commandos

---

## 🛠️ 3. BESCHRIJVING VAN ALLE GEBRUIKTE TOOLS EN SCRIPTS

### 3.1 Tools Overzicht

| Tool | Type | Functie | Locatie |
|------|------|---------|---------|
| **apkeep** | Standalone binary | APK/XAPK download | Extern (EFF) |
| **unzip** | Command-line | Uitpakken | Systeem |
| **curl** | Command-line | HTTP requests | Systeem |
| **Python 3** | Runtime | Script uitvoering | Systeem |
| **axml_min.py** | Python script | Manifest parsing | Lokaal |
| **dex_extract.py** | Python script | DEX extractie | Lokaal |
| **dex_locate.py** | Python script | Contextverificatie | Lokaal |
| **marker_analyse.sh** | Bash script | Marker analyse | Lokaal |
| **native_scan.py** | Python script | Native library scan | Lokaal |
| **run_all_vervolgstappen.sh** | Bash script | Batch verwerking | Lokaal |

### 3.2 Script Details

#### axml_min.py
- **Doel:** AndroidManifest.xml parsen
- **Taal:** Python 3
- **Dependencies:** Geen (pure Python)
- **Gebruik:** `python3 axml_min.py <manifest_path>`
- **Output:** Pakket-ID, versionName, versionCode

#### dex_extract.py
- **Doel:** DEX-bestanden extractie (strings en types)
- **Taal:** Python 3
- **Dependencies:** Geen
- **Gebruik:** `python3 dex_extract.py <dex_dir> <output_dir>`
- **Output:** strings_all.txt, types_all.txt

#### dex_locate.py
- **Doel:** Contextverificatie (eigen code types bevestigen)
- **Taal:** Python 3
- **Dependencies:** Geen
- **Gebruik:** `python3 dex_locate.py <dex_dir> <search_term> [type_filter]`
- **Output:** String-treffers en type-treffers

#### marker_analyse.sh
- **Doel:** Marker analyse voor alle banken
- **Taal:** Bash
- **Dependencies:** grep, wc
- **Gebruik:** `bash marker_analyse.sh`
- **Output:** marker_results.log

#### native_scan.py
- **Doel:** Native library scan
- **Taal:** Python 3
- **Dependencies:** Geen
- **Gebruik:** `python3 native_scan.py <native_libs_dir>`
- **Output:** Root-detectie patronen, SQLCipher, Keystore referenties

#### run_all_vervolgstappen.sh
- **Doel:** Batch verwerking van vervolgstappen
- **Taal:** Bash
- **Dependencies:** python3, unzip, mkdir
- **Gebruik:** `bash run_all_vervolgstappen.sh`
- **Output:** Alle logbestanden in logs/ directory

---

## 💻 4. VOORBEELDEN VAN COMMANDOS

### 4.1 Complete Analyse Workflow

```bash
#!/bin/bash

# Variabelen
BASE_DIR="/home/thijs/Downloads/Bank apps"
BANKS=("asn" "regio" "sns" "ing" "rabobank" "knab" "revolut" "trade_republic" "abnamro" "bunq" "triodos")

# Stap 1: APK downloaden (handmatig of via apkeep)
for bank in "${BANKS[@]}"; do
    echo "📥 Download: $bank"
    ./apkeep -a <pakket-id> .
    echo ""
done

# Stap 2: Uitpakken
for bank in "${BANKS[@]}"; do
    echo "📦 Uitpakken: $bank"
    unzip -o ${bank}.apk -d extracted/${bank} 2>/dev/null || unzip -o ${bank}.xapk -d xapk && unzip -o xapk/*.apk -d extracted/${bank}
    echo ""
done

# Stap 3: Manifest parsen
for bank in "${BANKS[@]}"; do
    echo "📄 Manifest: $bank"
    python3 axml_min.py extracted/${bank}/app/AndroidManifest.xml > logs/manifest_${bank}.log
    echo ""
done

# Stap 4: DEX extractie
for bank in "${BANKS[@]}"; do
    echo "🔍 DEX Extractie: $bank"
    python3 dex_extract.py extracted/${bank}/app extracted/${bank}/dex_out
    echo ""
done

# Stap 5: Marker analyse
bash marker_analyse.sh

# Stap 6: Contextverificatie
for bank in "${BANKS[@]}"; do
    for marker in "play.core.integrity" "safetynet" "setAttestationChallenge" "setIsStrongBoxBacked" "setUserAuthenticationRequired"; do
        echo "🔍 Contextverificatie: $bank - $marker"
        python3 dex_locate.py extracted/$bank/app $marker $bank > logs/context_${bank}_${marker}.log 2>&1
    done
done

# Stap 7: Native library scan
for bank in "${BANKS[@]}"; do
    echo "🔍 Native scan: $bank"
    python3 native_scan.py "extracted/$bank/libs/lib/arm64-v8a/" > logs/native_scan_${bank}.log 2>&1
done

# Stap 8: Dependency check
for bank in "${BANKS[@]}"; do
    echo "📦 Dependencies: $bank"
    ls -1 "extracted/$bank/app/*.properties" 2>/dev/null | grep -iE "(integrity|safetynet|fido|keystore|sqlcipher)" > logs/dependencies_${bank}.txt
done

echo "✅ Alle stappen voltooid!"
```

### 4.2 Specifieke Commandos

#### Play Integrity Detectie

```bash
# Zoeken naar Play Integrity markers
grep -iE "play.core.integrity|IntegrityManager|requestIntegrityToken" extracted/asn/dex_out/strings_all.txt

# Contextverificatie
echo "Play Integrity context voor ASN Bank:"
python3 dex_locate.py extracted/asn/app play.core.integrity devolksbank
```

#### SafetyNet Detectie

```bash
# Zoeken naar SafetyNet markers
grep -iE "safetynet|SafetyNetClient" extracted/abnamro/dex_out/strings_all.txt

# Contextverificatie
echo "SafetyNet context voor ABN AMRO:"
python3 dex_locate.py extracted/abnamro/app safetynet abnamro
```

#### Hardware Attestation Detectie

```bash
# Zoeken naar Hardware Attestation markers
grep -iE "setAttestationChallenge|attestationChallenge" extracted/trade_republic/dex_out/strings_all.txt

# Contextverificatie
echo "Hardware Attestation context voor Trade Republic:"
python3 dex_locate.py extracted/trade_republic/app setAttestationChallenge traderepublic
```

#### SQLCipher Detectie

```bash
# Zoeken naar SQLCipher markers
grep -iE "SQLCipher|libsqlcipher" extracted/abnamro/dex_out/strings_all.txt

# Native library scan
echo "Native SQLCipher voor ABN AMRO:"
python3 native_scan.py "extracted/abnamro/libs/lib/arm64-v8a/"
```

#### Root-detectie

```bash
# Native library scan voor root-detectie
echo "Root-detectie voor Revolut:"
python3 native_scan.py "extracted/revolut/app_full/libs/lib/armeabi-v7a/"

# Specifiek zoeken naar magisk/frida/xposed
grep -iE "magisk|frida|xposed" extracted/revolut/app_full/libs/lib/armeabi-v7a/libfourthline-security.so
```

---

## 🚨 5. TROUBLESHOOTING GIDS

### 5.1 Algemene Problemen

#### Probleem: apkeep download mislukt

**Symptomen:**
- Geen APK/XAPK bestand verschijnt na uitvoering
- Timeout error

**Oorzaak:**
- Pakket-ID is onjuist
- App niet beschikbaar op APKPure
- Download te groot (>300 MB)

**Oplossing:**
1. Verifieer pakket-ID:
   ```bash
   curl -sL -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "https://play.google.com/store/apps/details?id=<PAKKET-ID>"
   ```
2. Gebruik verhoogde timeout:
   ```bash
   timeout 280 ./apkeep -a <PAKKET-ID> .
   ```
3. Probeer handmatige download via APKMirror

---

#### Probleem: DEX-bestanden niet gevonden

**Symptomen:**
- `dex_extract.py` meldt: "Geen .dex bestanden gevonden!"

**Oorzaak:**
- APK is niet correct uitgepakt
- APK is een bundle (XAPK) en moet eerst worden uitgepakt
- DEX-bestanden hebben andere naam (classes.dex, classes2.dex, etc.)

**Oplossing:**
1. Controleer of APK correct is uitgepakt:
   ```bash
   ls -la extracted/<bank>/app/
   ```
2. Voor XAPK: pak eerst basis-APK uit:
   ```bash
   unzip -o <app>.xapk -d xapk
   unzip -o xapk/<basis-apk> -d extracted/<bank>
   ```
3. Controleer DEX-bestanden:
   ```bash
   find extracted/<bank> -name "*.dex"
   ```

---

#### Probleem: Contextverificatie vindt geen types

**Symptomen:**
- `dex_locate.py` toont alleen string-treffers, geen type-treffers
- Vals-positieven niet gecorrigeerd

**Oorzaak:**
- Type filter is niet specifiek genoeg
- Bank gebruikt andere package naam

**Oplossing:**
1. Bepaal de package naam:
   ```bash
   python3 axml_min.py extracted/<bank>/app/AndroidManifest.xml
   ```
2. Gebruik de juiste package naam als filter:
   ```bash
   python3 dex_locate.py extracted/<bank>/app play.core.integrity <package>
   ```
3. Voorbeelden:
   - ASN/Regio/SNS: `devolksbank`
   - ABN AMRO: `abnamro`
   - bunq: `bunq`
   - Revolut: `revolut`
   - ING: `ing`

---

#### Probleem: Native library scan vindt geen treffers

**Symptomen:**
- `native_scan.py` meldt: "❌ Scan voltooid - geen treffers"

**Oorzaak:**
- Native libraries hebben andere architectuur (arm64-v8a vs armeabi-v7a)
- Native libraries zijn niet aanwezig (sommige banken hebben geen native code)
- Patterns zijn niet aanwezig in de libraries

**Oplossing:**
1. Controleer welke native libraries aanwezig zijn:
   ```bash
   find extracted/<bank> -name "*.so"
   ```
2. Probeer andere architectuur:
   ```bash
   python3 native_scan.py "extracted/<bank>/libs/lib/armeabi-v7a/"
   ```
3. Controleer of bank native libraries heeft:
   - ING, Rabobank, Trade Republic: ❌ Geen native libraries
   - Andere banken: ✅ Hebben native libraries

---

#### Probleem: Manifest parsing mislukt

**Symptomen:**
- `axml_min.py` produceert geen output
- Foutmeldingen over binaire data

**Oorzaak:**
- Manifest is in binair AXML formaat
- Script verwacht specifiek formaat

**Oplossing:**
1. Gebruik `axml_min.py` zoals bedoeld:
   ```bash
   python3 axml_min.py extracted/<bank>/app/AndroidManifest.xml
   ```
2. Alternatief: gebruik XAPK manifest.json:
   ```bash
   cat xapk/manifest.json | jq '.version_name, .version_code, .package_name'
   ```

---

### 5.2 Specifieke Bank Problemen

#### ASN Bank, RegioBank, SNS Bank (Volksbank Groep)

**Probleem:** Gedeelde codebase, maar verschillende pakket-ID's

**Oplossing:**
- Gebruik `devolksbank` als type filter voor alle drie
- Verwacht identieke resultaten

---

#### bunq

**Probleem:** Groot aantal DEX-bestanden (12)

**Oplossing:**
- `dex_extract.py` verwerkt alle DEX-bestanden automatisch
- Verwacht langere verwerkingstijd

---

#### Revolut

**Probleem:** App en App Full varianten

**Oplossing:**
- Analyseer beide varianten:
  ```bash
  # Basis APK
  python3 dex_extract.py extracted/revolut/app extracted/revolut/dex_out
  
  # App Full APK (bevat native libraries)
  python3 dex_extract.py extracted/revolut/app_full extracted/revolut/app_full/dex_out
  ```

---

#### Trade Republic

**Probleem:** Geen native libraries

**Oplossing:**
- Native library scan overslaan voor deze bank
- Focus op Java/Kotlin analyse

---

### 5.3 Performance Problemen

#### Probleem: Langzame verwerking

**Symptomen:**
- Scripts lopen lang (>300 seconden)
- Timeout errors

**Oplossing:**
1. Verhoog timeout:
   ```bash
   timeout 600 python3 dex_extract.py extracted/bunq/app extracted/bunq/dex_out
   ```
2. Verwerk banken afzonderlijk in plaats van batch
3. Gebruik efficiëntere scripts (bv. `grep` in plaats van Python voor eenvoudige zoekopdrachten)

---

## 📊 6. SAMENVATTING VAN BEST PRACTICES

### 6.1 Algemene Tips

1. **Altijd contextverificatie uitvoeren**
   - Marker analyse alleen is niet voldoende
   - Gebruik `dex_locate.py` om vals-positieven te identificeren

2. **Document alle stappen**
   - Bewaar alle logbestanden
   - Noteer gebruikte commandos
   - Document afwijkingen

3. **Gebruik consistente naming**
   - `extracted/<bank>/` voor uitgepakte bestanden
   - `logs/<script>_<bank>.log` voor logbestanden
   - `context_<bank>_<marker>.log` voor contextverificatie

4. **Valideer resultaten**
   - Controleer op vals-positieven
   - Verifieer met meerdere methoden
   - Raadpleeg bronbestanden

---

### 6.2 Quality Assurance

1. **Cross-referentie validatie**
   - Controleer alle string-aantallen in documenten vs bronbestanden
   - Valideer classificaties tegen context logs
   - Check native library aantallen vs native_scan logs

2. **Consistentie checks**
   - Gedeelde codebase (Volksbank Groep) moet identieke resultaten tonen
   - Vals-positieven moeten worden gecorrigeerd
   - Classificaties moeten gebaseerd zijn op bevestigde eigen code

3. **Documentatie standaarden**
   - Gebruik de bestaande template voor analyse documenten
   - Voeg altijd bronvermeldingen toe
   - Gebruik de standaard classifiatiestatus symbolen

---

## 📚 7. GERELATEERDE DOCUMENTEN

- [stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md](./stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md) - Complete stappenplan
- [DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md](./DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md) - Bronopbouw documentatie
- [ANALYSE_INSTRUCTIES.vibe](./ANALYSE_INSTRUCTIES.vibe) - Master instructie document
- [VERVOLGSTAPPEN.md](./VERVOLGSTAPPEN.md) - Voortgang en vervolgstappen
- [run_all_vervolgstappen.sh](./run_all_vervolgstappen.sh) - Batch verwerking script

### Scripts:
- [axml_min.py](./axml_min.py) - Manifest parsing
- [dex_extract.py](./dex_extract.py) - DEX extractie
- [dex_locate.py](./dex_locate.py) - Contextverificatie
- [marker_analyse.sh](./marker_analyse.sh) - Marker analyse
- [native_scan.py](./native_scan.py) - Native library scan

---

## ✅ 8. VOLTOOIDE ACTIES

- [x] Consolideer alle methodologie documenten
- [x] Document stapsgewijze analyse proces
- [x] Beschrijf alle gebruikte tools en scripts
- [x] Voeg voorbeelden toe van commandos
- [x] Creëer troubleshooting gids

---

**Laatst geactualiseerd:** 7 November 2026, 22:15 CET  
**Versie:** 1.0  
**Status:** ✅ Voltooid  
**Document Type:** Methodologie Handboek  
**Doelgroep:** Toekomstige analisten, interne documentatie
