# Documentatie Opbouw: Statische Apparaatveiligheidsanalyse Bank Apps

**Datum:** 2025  
**Versie:** 1.0  
**Doel:** Documenteren hoe de statische-analyse-XXX documenten zijn opgebouwd en welke bronbestanden worden gebruikt

---

## 📋 Overzicht

Dit document beschrijft de **bronopbouw** van de `statische-analyse-apparaatveiligheid-in-de-XXX.md` documenten. Het legde uit:
- Welke **bronbestanden** worden gebruikt
- Hoe de **informatie stroomt** van bron naar document
- Welke **scripts** worden toegepast
- Hoe **consistentie** wordt gewaarborgd

---

## 🎯 Doel van de Statische-Analyse Documenten

De `statische-analyse-XXX.md` documenten hebben als doel:
1. **Classificeren** van attestatie-mechanismen (Play Integrity, SafetyNet, Hardware Attestation)
2. **Documenteren** van beveiligingsmechanismen in bankapps
3. **Bewijzen** leveren voor elke classificatie
4. **Reproduceerbaarheid** garanderen via gedetailleerde bronvermelding

---

## 📁 Bronbestanden Hiërarchie

De statische-analyse documenten zijn opgebouwd uit **vier hoofdcategorieën** van bronbestanden:

```
📁 /home/thijs/Downloads/Bank apps/
├── extracted/<bank>/              # (1) Geëxtraheerde APK data
│   ├── app/                        #   - DEX-bestanden (classes.dex, etc.)
│   │   ├── classes.dex             #   - AndroidManifest.xml
│   │   ├── classes2.dex            #   - *.properties (SDK metadata)
│   │   └── ...
│   ├── dex_out/                    # (2) DEX extractie output
│   │   ├── strings_all.txt         #   - Alle unieke strings
│   │   └── types_all.txt           #   - Alle unieke types
│   └── libs/                       #   - Native libraries
│       └── lib/arm64-v8a/*.so      #
│
├── context_*.log                   # (3) Contextverificatie logs
├── native_scan_*.log               #   - Native library scan logs
├── dependencies_*.txt              #   - Dependency metadata
├── marker_results.log              #   - Marker analyse resultaten
├── dex_extract_results.log         #   - DEX extractie logs
└── manifest_results.log            #   - Manifest parsing logs
```

---

## 🔍 Details per Broncategorie

### **Categorie 1: Geëxtraheerde APK Data**
**Locatie:** `extracted/<bank>/`

#### **1.1 DEX Bestanden**
- **Bestanden:** `classes.dex`, `classes2.dex`, `classes3.dex`, ...
- **Inhoud:** Gecompileerde Java/Kotlin bytecode
- **Gebruik:**
  - Directe analyse op attestatie markers
  - Contextverificatie (welke types gebruiken markers?)
- **Script:** `dex_locate.py` (Stap 8 in stappenplan)
- **Voorbeeld:** ASN Bank heeft 6 DEX-bestanden, bunq heeft 12

#### **1.2 AndroidManifest.xml**
- **Bestand:** `extracted/<bank>/app/AndroidManifest.xml`
- **Inhoud:** Binaire AXML met app metadata
- **Gebruik:**
  - Pakket-ID (`package`)
  - Versie informatie (`versionName`, `versionCode`)
  - Min/Target SDK (`minSdkVersion`, `targetSdkVersion`)
- **Script:** `axml_min.py` (Stap 5 in stappenplan)

#### **1.3 Properties Bestanden**
- **Bestanden:** `*.properties` in `extracted/<bank>/app/`
- **Inhoud:** SDK versie informatie
- **Voorbeelden:**
  - `integrity.properties` → Play Integrity SDK versie (bv. 1.6.0)
  - `play-services-fido.properties` → FIDO2 SDK versie (bv. 21.0.0)
  - `safetynet.properties` → SafetyNet SDK versie (bv. 18.1.0)
- **Gebruik:** Bevestigen welke SDK's gebundeld zijn

#### **1.4 Native Libraries**
- **Locatie:** `extracted/<bank>/libs/lib/arm64-v8a/*.so`
- **Inhoud:** Gecompileerde native code (C/C++)
- **Gebruik:**
  - Scannen op JNI referenties naar keystore methoden
  - Detecteren van root-detectie (magisk, xposed, frida)
- **Script:** `native_scan.py` (Stap 9 in stappenplan)

---

### **Categorie 2: DEX Extractie Output**
**Locatie:** `extracted/<bank>/dex_out/`

#### **2.1 strings_all.txt**
- **Inhoud:** Alle unieke strings uit alle DEX-bestanden
- **Gebruik:**
  - **Marker analyse** (zoeken naar attestatie-gerelateerde terms)
  - Basis voor classificatie
- **Voorbeeld:**
  - ASN: 242.848 unieke strings
  - bunq: 497.249 unieke strings
  - Triodos: 68.163 unieke strings
- **Script:** `dex_extract.py` (Stap 6 in stappenplan)

#### **2.2 types_all.txt**
- **Inhoud:** Alle unieke types (klassennamen) uit alle DEX-bestanden
- **Gebruik:**
  - Contextverificatie (welke types gebruiken markers?)
  - Filteren van vals-positieven
- **Voorbeeld:**
  - ASN: 65.465 unieke types
  - bunq: 130.121 unieke types
- **Script:** `dex_extract.py` (Stap 6 in stappenplan)

---

### **Categorie 3: Analyse Logbestanden**
**Locatie:** `/home/thijs/Downloads/Bank apps/` (root)

#### **3.1 Contextverificatie Logs**
- **Patroon:** `context_<bank>_<marker>.log`
- **Inhoud:** Resultaten van `dex_locate.py` script
- **Doel:** Bepalen of markers in **eigen code** of **SDK code** zitten
- **Voorbeelden:**
  - `context_asn_playintegrity.log` → Bevestigt Play Integrity in eigen code (nl.devolksbank types)
  - `context_bunq_strongbox.log` → Bevestigt StrongBox in eigen code (com.bunq types)
  - `context_ing_playintegrity.log` → Geen treffers (vals-positief)
- **Script:** `python3 dex_locate.py extracted <term> <typefilter>`

#### **3.2 Native Library Scan Logs**
- **Patroon:** `native_scan_<bank>.log`
- **Inhoud:** Resultaten van native library scan
- **Doel:** Detecteren van:
  - Keystore methoden (`setAttestationChallenge`, `setIsStrongBoxBacked`)
  - Root-detectie (magisk, xposed, frida-gadget)
- **Voorbeelden:**
  - `native_scan_asn.log` → Geen root-detectie, geen keystore methoden
  - `native_scan_triodos.log` → Root-detectie in libfourthline-security.so
  - `native_scan_revolut.log` → Root-detectie + SQLCipher
- **Script:** `python3 native_scan.py extracted/<bank>/libs/lib/arm64-v8a/`

#### **3.3 Dependency Metadata**
- **Patroon:** `dependencies_<bank>.txt`
- **Inhoud:** Lijst van gebundelde SDK's en versies
- **Doel:** Bevestigen welke attestatie-SDK's aanwezig zijn
- **Voorbeeld:** `dependencies_asn.txt` → Bevat `integrity.properties` (v1.6.0)

#### **3.4 Marker Analyse Resultaten**
- **Bestand:** `marker_results.log`
- **Inhoud:** Samenvatting van marker zoekopdrachten
- **Doel:** Snelle overzicht van welke markers waar voorkomen

#### **3.5 DEX Extractie Logs**
- **Bestand:** `dex_extract_results.log`
- **Inhoud:** Output van DEX extractie proces
- **Doel:** Verificatie dat extractie succesvol was

#### **3.6 Manifest Parsing Logs**
- **Bestand:** `manifest_results.log`
- **Inhoud:** Output van manifest parsing
- **Doel:** Verificatie van package, versie, SDK levels

---

## 📊 Informatie Stroom: Bron → Document

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        BRONBESTANDEN (Input)                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  📁 extracted/<bank>/app/                                                 │
│     ├── classes.dex, classes2.dex, ...    │ DEX Bestanden                │
│     ├── AndroidManifest.xml             │ App Metadata                 │
│     └── *.properties                     │ SDK Versies                  │
│                                                                             │
│  📁 extracted/<bank>/dex_out/                                            │
│     ├── strings_all.txt                  │ Alle Strings (242K-497K)    │
│     └── types_all.txt                    │ Alle Types (65K-130K)       │
│                                                                             │
│  📁 /home/thijs/Downloads/Bank apps/                                     │
│     ├── context_<bank>_<marker>.log      │ Context Verificatie         │
│     ├── native_scan_<bank>.log           │ Native Library Scan          │
│     ├── dependencies_<bank>.txt          │ SDK Dependencies             │
│     └── marker_results.log               │ Marker Analyse               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                      ANALYSE SCRIPTS (Processing)                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. axml_min.py                          │ Manifest → Package/Version  │
│  2. dex_extract.py                       │ DEX → strings_all.txt       │
│  3. dex_locate.py                       │ strings → Context            │
│  4. native_scan.py                      │ .so → JNI References         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                 STATISCHE-ANALYSE-XXX DOCUMENTEN (Output)                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  • statische-analyse-apparaatveiligheid-in-de-asn-bank...md              │
│  • statische-analyse-apparaatveiligheid-in-de-bunq...md                 │
│  • statische-analyse-apparaatveiligheid-in-de-triodos...md             │
│  • statische-analyse-apparaatveiligheid-in-de-ing...md                 │
│  • ...                                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📝 Structuur van een Statische-Analyse Document

Elk `statische-analyse-XXX.md` document volgt een **vaste structuur**:

### **Sectie 1: Kopgegevens**
```markdown
# Statische analyse: apparaatveiligheid en remote attestation in de <Bank> Android-app (<versie>)

**Onderzocht pakket:** `<pakket-id>` (<Bank>), `versionName` <versie> (`versionCode` <code>)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt
```

**Bronnen:**
- Pakket-ID: `AndroidManifest.xml` (via `axml_min.py`)
- Versie: `AndroidManifest.xml` of `xapk/manifest.json`

---

### **Sectie 2: Kernbevindingen**
```markdown
## Kernbevindingen

- De <Bank>-app gebruikt <mechanisme> ✅ ACTIEF GEBRUIKT / ❌ AFWEZIG
- <Mechanisme 2> is ✅ ACTIEF GEBRUIKT / ❌ AFWEZIG
```

**Bronnen:**
- Marker analyse (`strings_all.txt`)
- Contextverificatie (`context_<bank>_<marker>.log`)
- Native scan (`native_scan_<bank>.log`)

---

### **Sectie 3: Bewijs per Attestatie-Methode**
```markdown
## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ✅ ACTIEF GEBRUIKT | `integrity.properties` (vX.X.X), klassen `com.google.android.play.core.integrity.*` |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen in <N> unieke strings |
| Hardware Attestation | ❌ AFWEZIG | `setAttestationChallenge` ontbreekt in alle DEX-bestanden |
```

**Bronnen:**
- Aantal strings: `strings_all.txt` (line count)
- SDK versies: `*.properties` bestanden
- Marker presence/absence: `strings_all.txt` (grep resultaten)

---

### **Sectie 4: Wel Aangetziene Beveiligingsmechanismen**
```markdown
## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Play Integrity | Gebundeld SDK vX.X.X, gebruikssporen in eigen code |
| FIDO2/WebAuthn | Dependency `play-services-fido` (versie X.X.X) |
| Hardware-gebonden cryptografie | `setIsStrongBoxBacked` aanwezig |
```

**Bronnen:**
- SDK dependencies: `dependencies_<bank>.txt`
- Code presence: `strings_all.txt` + contextverificatie

---

### **Sectie 5: Wero-Specifiek**
```markdown
## Wero-specifiek

- Wero-implementatie is eigen werk van <Bank>
- Endpoints: `/wero/wallet`, `/wero/consent/`
- Sleutelbeheer: KEK/SUK hiërarchie
```

**Bronnen:**
- Wero endpoints: `strings_all.txt` (grep "wero")
- Code analyse: `dex_locate.py` met filter op bank package

---

### **Sectie 6: Aanwezige SDK's**
```markdown
## Aanwezige verificatie- en betalingsgerelateerde SDK's

| SDK | Doel | Versie |
| --- | --- | --- |
| Google Play Integrity SDK | App-integriteit | 1.6.0 |
| play-services-fido | FIDO2/WebAuthn | 21.0.0 |
```

**Bronnen:**
- `*.properties` bestanden in `extracted/<bank>/app/`

---

### **Sectie 7: Native Libraries**
```markdown
## Native Libraries

- 14 native libraries in `lib/arm64-v8a/`
- Root-detectie: ❌ AFWEZIG / ✅ ACTIEF GEBRUIKT (libfourthline-security.so)
- `setAttestationChallenge`: ❌ AFWEZIG in native code
```

**Bronnen:**
- `native_scan_<bank>.log`
- Directe inspectie van `.so` bestanden

---

### **Sectie 8: Reproductie**
```markdown
## Reproductie

```bash
# APK ophalen
apkeep -a <pakket-id> .

# Uitpakken
unzip -o <apk>.xapk -d xapk
unzip -o xapk/<basis-apk>.apk -d <bank>_extracted

# DEX extractie
python3 dex_extract.py <bank>_extracted <bank>_extracted/dex_out

# Zoeken
grep -ri "play.core.integrity"   # SDK-klassen
```
```

**Doel:** Reproduceerbaarheid van de analyse

---

## 🔄 Consistentie Mechanismen

### **1. Leidende Documenten**
- **`statische-analyse-XXX-CLI.md`** > `statische-analyse-XXX.md` (web)
- CLI-geverifieerde documenten zijn **leidend** bij tegenstrijdigheden
- Voorbeeld: ASN Bank CLI-versie is leidend voor ASN

### **2. Cross-Referentie**
- Alle documenten verwijzen naar:
  - `strings_all.txt` (aantal strings)
  - `types_all.txt` (aantal types)
  - `context_<bank>_<marker>.log` (bevestiging eigen code)
  - `native_scan_<bank>.log` (native code analyse)

### **3. Kwaliteitscontrole**
- `KWALITEITSCONTROLE_RAPPORT.md` verifieert:
  - DEX extractie compleet voor alle banken
  - Native library scans aanwezig
  - Contextverificatie uitgevoerd
  - Classificaties consistent

---

## 📌 Voorbeeld: ASN Bank Analyse

### **Bronbestanden:**
```
📁 extracted/asn/
├── app/
│   ├── classes.dex, classes2.dex, ..., classes6.dex  # 6 DEX-bestanden
│   ├── AndroidManifest.xml                          # package: nl.devolksbank.asn.bankieren
│   └── integrity.properties                         # v1.6.0
├── dex_out/
│   ├── strings_all.txt                               # 242.848 strings
│   └── types_all.txt                                 # 65.465 types
└── libs/lib/arm64-v8a/                                # 14 native libraries
    ├── liba56400.so, libbf34f.so, ...
```

### **Logbestanden:**
```
📄 context_asn_playintegrity.log     # Bevestigt RequestIntegrityTokenUseCase
📄 context_asn_requestintegrity.log   # Bevestigt RequestIntegrityTokenUseCase
📄 native_scan_asn.log                # Geen root-detectie, geen keystore methoden
📄 dependencies_asn.txt               # integrity.properties, fido.properties
```

### **Resultaat:**
- `statische-analyse-apparaatveiligheid-in-de-asn-bank-android-app-v1-36-3-CLI.md`
- Classificatie: Play Integrity ✅, SafetyNet ❌, Hardware Attestation ❌

---

## 🔍 Hoe Te Verifiëren

### **Verifieer een Classificatie**
1. **Check strings_all.txt:**
   ```bash
   grep "play.core.integrity" extracted/<bank>/dex_out/strings_all.txt
   ```

2. **Check context log:**
   ```bash
   cat context_<bank>_playintegrity.log
   ```
   → Moet bank-eigen types tonen (bv. `nl.devolksbank`, `com.bunq`)

3. **Check native scan log:**
   ```bash
   cat native_scan_<bank>.log
   ```
   → Moet geen `setAttestationChallenge` tonen voor Hardware Attestation ❌

---

## 📚 Gerelateerde Documenten

| Document | Doel | Relatie tot Statische-Analyse Documenten |
|----------|------|-------------------------------------------|
| `stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md` | **Methodologie** | Beschrijft HOE de analyse uitgevoerd wordt |
| `DOCUMENTATIE_OPBOUW_STATISCHE_ANALYSE.md` | **Dit document** | Beschrijft WAAR de documenten op gebaseerd zijn |
| `KWALITEITSCONTROLE_RAPPORT.md` | **Validatie** | Verifieert dat alle stappen correct uitgevoerd zijn |
| `ANALYSE_INSTRUCTIES.vibe` | **Instructies** | Overzicht van alle analyses en resultaten |
| `MARKER_ANALYSE.md` | **Samenvatting** | Marker analyse resultaten voor alle banken |

---

## 🏷️ Versie Geschiedenis

| Versie | Datum | Wijzigingen | Auteur |
|--------|-------|--------------|--------|
| 1.0 | 2025 | Initiële documentatie opbouw | CLI Analyse |

---

## 📌 Contact

Voor vragen over deze documentatie of de analyse methodologie, raadpleeg:
- `stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md`
- De individuele statische-analyse documenten

---

*Dit document beschrijft de bronopbouw van de statische-analyse documenten. Voor de analyse methodologie zelf, zie het stappenplan.*
