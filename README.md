# Bank Apps Security Analysis

Dit project bevat een uitgebreide statische beveiligingsanalyse van Nederlandse bank-applicaties.

## 📁 Project Structuur

```
Bank-Apps-Security-Analysis/
├── README.md                    # Dit bestand
├── ANALYSE_INSTRUCTIES.vibe     # Instructies voor Vibe
│
├── 📚 docs/                     # Alle documentatie
│   ├── 📊 analyses/              # Hoofdanalyses en samenvattingen
│   ├── 🏦 per-bank/              # Individuele bankanalyses
│   ├── 📚 methodology/          # Methodologische documenten
│   └── 📋 reports/              # Status- en samenwerkingsrapporten
│
├── 📦 apks/                     # Originele APK/XAPK bestanden
│   ├── abnamro/
│   ├── asn/
│   ├── bunq/
│   ├── de-volksbank/
│   ├── ing/
│   ├── knab/
│   ├── rabobank/
│   ├── revolut/
│   ├── trade-republic/
│   ├── triodos/
│   └── bvm/
│
├── 🗃️ extracted/                # Geëxtraheerde APK-inhoud
│
├── 🐧 scripts/                  # Scripts voor analyse en extractie
│   ├── analysis/
│   ├── extraction/
│   └── download/
│
├── 📝 logs/                     # Logbestanden
│   ├── context/
│   ├── extraction/
│   └── native/
│
└── 🔗 dependencies/             # Dependency lijsten
```

## 📖 Documentatie

- **Executive Summary**: Zie [`docs/analyses/executive_summary.md`](docs/analyses/executive_summary.md) voor een beknopt overzicht
- **Vergelijking Apparaatveiligheid**: Zie [`docs/analyses/vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md`](docs/analyses/vergelijking_apparaatveiligheid_en_attestation_Bank_Android_apps.md) voor een vergelijkende analyse
- **Hoofdanalyses**: Zie [`docs/analyses/`](docs/analyses/) voor uitgebreide rapporten
- **Per-bank analyses**: Zie [`docs/per-bank/`](docs/per-bank/) voor specifieke bankanalyses
- **Methodologie**: Zie [`docs/methodology/`](docs/methodology/) voor de gebruikte methoden

## 🏦 Gedekte Banken

- ABN AMRO
- ASN Bank
- Bunq
- ING
- KNAB
- Rabobank
- RegioBank
- Revolut
- SNS Bank
- Trade Republic
- Triodos
- BVM

## 🛠️ Scripts

De scripts in [`scripts/`](scripts/) zijn bedoeld voor:
- APK extractie en analyse
- Marker analyse
- Native library scanning
- Automatische download en verwerking

## 📊 Analysemethoden

Dit project maakt gebruik van:
- Statische code analyse
- APK decompilatie
- Native library analyse
- Beveiligingsmarker detectie
- Dependency analyse

## ⚠️ Opmerking

Sommige APK/XAPK bestanden zijn groot (>300MB). Overweeg om deze toe te voegen aan `.gitignore` als je deze repository op GitHub wilt plaatsen.

---

**Project Status**: Work in Progress  
**Laatste update**: November 2026
