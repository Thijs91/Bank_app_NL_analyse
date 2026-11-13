# Stappenplan: statische apparaatveiligheidsanalyse van Nederlandse bankapps

Dit document beschrijft de complete, reproduceerbare werkwijze voor het statisch analyseren van Android-bankapps op apparaatbeveiliging en remote attestation. De methodiek is ontwikkeld en gevalideerd tijdens de analyses van de bunq-app (v32.4.1) en de ASN Bank-app (v1.36.3). Het doel per app: vaststellen welke methode voor remote attestation wordt gebruikt (Google Play Integrity, SafetyNet, AndroidKeyStore-hardware-attestation of geen), en in kaart brengen hoe de app apparaatbeveiligheid inricht.

## 1. Doelwitten

Verifieerde pakket-ID's op Google Play (status per november 2026):

| Bank / app | Pakket-ID | Status |
| --- | --- | --- |
| bunq | `com.bunq.android` | ✅ geanalyseerd (v32.4.1): ❌ AFWEZIG (geen attestation) |
| ASN Bank (de Volksbank) | `nl.devolksbank.asn.bankieren` | ✅ geanalyseerd (v1.36.3): ✅ ACTIEF GEBRUIKT (Play Integrity in Wero-registratie) |
| SNS Bank (de Volksbank) | `nl.devolksbank.sns.bankieren` | ✅ geanalyseerd (v1.36.3): ✅ ACTIEF GEBRUIKT (Play Integrity + Hardware Attestation) |
| RegioBank (de Volksbank) | `nl.devolksbank.regio.bankieren` | ✅ geanalyseerd (v1.36.3): ✅ ACTIEF GEBRUIKT (Play Integrity + Hardware Attestation) |
| ING | `com.ing.mobile` | ✅ geanalyseerd (v2025.25.1): ❌ AFWEZIG |
| ABN AMRO | `com.abnamro.nl.mobile.payments` | ✅ geanalyseerd (v13.34): ✅ ACTIEF GEBRUIKT (SafetyNet) |
| Rabobank | `nl.rabomobiel` | ✅ geanalyseerd (v8.1.4): ❌ AFWEZIG |
| Knab | `bvm.bvmapp` | ✅ geanalyseerd (v4.11.0): ❌ AFWEZIG |
| Revolut | `com.revolut.revolut` | ✅ geanalyseerd (Onbekend): ✅ ACTIEF GEBRUIKT (Play Integrity + SafetyNet + Root Detectie) |
| Trade Republic | `de.traderepublic.app` | ✅ geanalyseerd (v4.2645.1): ✅ ACTIEF GEBRUIKT (Play Integrity + Hardware Attestation) |
| N26 | `de.number26.android` | ❌ **Download mislukt** |
| Wero (standalone, EPI) | `eu.epicompany.wero.wallet` | ❌ **Verkeerde APK, verwijderd** |

Verificatie van een pakket-ID geschiedt met een HTTP-statuscheck op de Play Store-pagina (`200` betekent geldig):

```bash
curl -sL -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "https://play.google.com/store/apps/details?id=<PAKKET-ID>"
```

## 2. Benodigdheden

- `apkeep` (standalone Rust-binary, geen pakketbeheer nodig): `https://github.com/EFForg/apkeep/releases/download/0.17.0/apkeep-x86_64-unknown-linux-gnu`
- `python3` en `unzip`; een JRE is niet vereist (de DEX-analyse gebeurt met een eigen parser, `strings` en `jadx` zijn optioneel).
- Schrijfruimte: reken op 0,5-2 GB per app (APK plus extractie).

Randvoorwaarden van de Vibe CLI-omgeving:

- Pakketinstallatie via `apt` en `pip` is geblokkeerd; werk uitsluitend met standalone binaries (zoals `apkeep`) en pure Python zonder externe modules.
- Het commando `strings` ontbreekt in de omgeving; de native-library-scan in sectie 9 gebruikt daarom reguliere expressies in Python.
- Bash-commandos stoppen na maximaal 300 seconden; geef grote downloads een expliciete timeout (280 seconden bleek voldoende voor een bundel van 334 MB).
- De omgeving kan tussen beurten worden gereset: werkbestanden (gedownloade APK's, extracties, scripts) verdwijnen dan, maar gecreëerde canvases blijven behouden. Voer een volledige analyse daarom binnen één beurt uit, of herstart bij hervatting de download- en extractiestappen; de scripts staan integraal in dit stappenplan.

## 3. Stap 1: APK-verwerving

```bash
curl -sL -o apkeep "https://github.com/EFForg/apkeep/releases/download/0.17.0/apkeep-x86_64-unknown-linux-gnu"
chmod +x apkeep
./apkeep -a <PAKKET-ID> .
```

Aandachtspunten:

- De standaardbron is APKPure. Sommige apps worden als `.apk` geleverd, andere als `.xapk`-bundel. Een XAPK is een zip met daarin de basis-APK, configuratie-splits (zoals `config.arm64_v8a.apk`) en een `manifest.json` met `version_name`, `version_code`, `min_sdk_version` en `target_sdk_version`.
- Verkeerde pakket-ID's geven stille mislukking (bestand verschijnt niet). Controleer het ID daarom vooraf met de methode uit sectie 1.
- Downloads groter dan circa 300 MB dienen met een verhoogde timeout te worden gedraaid (bijvoorbeeld 280 seconden).

## 4. Stap 2: Uitpakken

```bash
# APK-variant
unzip -o <app>.apk -d extracted

# XAPK-variant
unzip -o <app>.xapk -d xapk
unzip -o xapk/<basis-apk> -d extracted
unzip -o xapk/config.arm64_v8a.apk -d libs        # native libraries zitten in de split
```

## 5. Stap 3: Manifest-meting (versie)

De `AndroidManifest.xml` is binair AXML. De minimale leeswijze: de string-pool start op offset 8 (UTF-8-variant met flag op bit 8); bij `START_ELEMENT`-chunks (type 0x0102) begint het attributenblok op `p + 16 + attributeStart` met attributen van elk 20 bytes (`ns`, `name`, `rawValue`, typed value). Zo worden `package`, `versionName` en `versionCode` afgelezen. Bij een XAPK-bundel zijn `version_name` en `version_code` bovendien zonder parser beschikbaar in `xapk/manifest.json`. Voor de APK-variant werkt het onderstaande script (`axml_min.py`); het leest het eerste `START_ELEMENT`-element (het `manifest`-element) en drukt `package`, `versionName` en `versionCode` af:

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

Gebruik: `python3 axml_min.py extracted/AndroidManifest.xml`. Een alternatief is `jadx` of `apkanalyzer` indien een JRE beschikbaar is.

## 6. Stap 4: DEX-extractie (strings en typen)

Elke DEX bevat een stringtabel: `string_ids_size` op offset 0x38 en `string_ids_off` op 0x3C; de typetabel (`type_ids`) op 0x40/0x44. Elke string is opgeslagen als ULEB128-lengte gevolgd door MUTF-8-gegevens en een nulbyte. Volledig extractiescript:

```python
import struct, sys, os

def uleb(data, off):
    r = 0; s = 0
    while True:
        b = data[off]; r |= (b & 0x7f) << s; off += 1
        if not (b & 0x80): return r, off
        s += 7

strings, types = [], []
for name in sorted(os.listdir(sys.argv[1])):
    if not name.endswith('.dex'): continue
    data = open(os.path.join(sys.argv[1], name), 'rb').read()
    sn, soff = struct.unpack_from('<II', data, 0x38)
    for i in range(sn):
        o = struct.unpack_from('<I', data, soff + i*4)[0]
        _, p = uleb(data, o)
        e = data.index(b'\x00', p)
        strings.append(data[p:e].decode('utf-8', 'replace'))
    tn, toff = struct.unpack_from('<II', data, 0x40)
    for i in range(tn):
        types.append(strings[struct.unpack_from('<I', data, toff + i*4)[0]])
os.makedirs(sys.argv[2], exist_ok=True)
open(os.path.join(sys.argv[2], 'strings_all.txt'), 'w').write('\n'.join(sorted(set(strings))))
open(os.path.join(sys.argv[2], 'types_all.txt'), 'w').write('\n'.join(sorted(set(types))))
```

Gebruik: `python3 dex_extract.py extracted dex_out`. Referentie-omvang: bunq leverde circa 497.000 unieke strings over 12 DEX-bestanden; ASN circa 243.000 over 6 bestanden.

## 7. Stap 5: Marker-analyse

Zoek in `strings_all.txt` en `types_all.txt` naar de onderstaande markers en classificeer per rij:

| Marker | Betekenis |
| --- | --- |
| `play.core.integrity`, `playintegrity`, `IntegrityManager`, `StandardIntegrityManager`, `requestIntegrityToken`, `cloudProjectNumber` | Google Play Integrity API |
| `safetynet`, `SafetyNetClient` | SafetyNet Attestation API |
| `setAttestationChallenge` | Directe hardware-attestation via KeyGenParameterSpec |
| `attestationChallenge`, `attestationTypes`, `KeyAttestation` (zonder de vorige marker) | Attestatie-verwerking als datamodel, geen directe aanroep |
| `droidguard` | Controleren op context: interne constanten van Google Wallet (`UC_DROIDGUARD_*`) zijn geen aanroep van de app zelf |
| `AndroidKeyStore`, `setIsStrongBoxBacked`, `IsStrongBoxAvailable`, `setUserAuthenticationRequired` | Hardware-gebonden sleutelopslag |
| `BiometricPrompt`, `CryptoObject`, `KeyPermanentlyInvalidatedException` | SCA / biometrische sleutelbinding |
| `sha256/...` (40+ tekens) en `CertificatePinner` | Certificate pinning |
| `SQLCipher`, `libsqlcipher.so` | Lokale databaseversleuteling |
| `play-services-fido`, `FIDO2_`, `attestationConveyancePreference` | FIDO2/WebAuthn-apparaatregistratie |
| `kek`, `suk`, `singleUseKeys`, `wero`-eindpunten (`wero-wallet`, `payment-means`, `consents`) | Wero-specifieke sleutelhiërarchie |
| `promon`, `arxan`, `verimatrix`, `dexguard`, `guardsquare`, `appdome`, `onespan`, `rootbeer` | Commerciële shielding- of root-detectieproducten |

Aanvullendecontext-zoeksels die in de analyses nodig bleken: `RequestIntegrityTokenUseCase`, `DeviceAttestationStatus`, `AppAttestation`, `appleNonce` (platformonafhankelijk registratiemodel), en de GMS-serviceacties (`com.google.android.gms.*.service`): een Play Integrity-integratie levert altijd een service-binding of SDK-klassen op.

## 8. Stap 6: Dependency-metadata

De APK bevat per gebundelde bibliotheek een `.properties`-bestand in de root. `ls extracted/*.properties` levert een snelle dependency-inventarisatie op. Betekenisvolle voorkomens: `integrity.properties` (Play Integrity SDK, met versienummer), `play-services-fido.properties`, `play-services-tapandpay.properties`, `play-services-wallet.properties`. Afwezigheid van `play-services-integrity` is een sterk signaal, mits de klassenzoekopdracht uit stap 5 eveneens niets oplevert.

## 9. Stap 7: Native libraries

Doorzoek de `.so`-bestanden in `libs/lib/arm64-v8a/` op JNI- en keystore-referenties. Bij een gewone APK (zonder XAPK-splits) liggen de libraries rechtstreeks in `extracted/lib/arm64-v8a/`; pas in het scan-script zo nodig het pad aan. Externe methodenamen moeten als letterlijke strings in de library of de DEX voorkomen, zodat afwezigheid van `setAttestationChallenge` in beide betekent dat de app de framework-aanroep nergens doet.

```python
import re, os
pats = re.compile(rb'setAttestationChallenge|setUserAuthenticationRequired|setIsStrongBoxBacked|'
                  rb'KeyGenParameterSpec|AndroidKeyStore|frida|xposed|magisk')
for lib in os.listdir('libs/lib/arm64-v8a'):
    data = open(os.path.join('libs/lib/arm64-v8a', lib), 'rb').read()
    for m in re.finditer(rb'[\x20-\x7e]{8,}', data):
        if pats.search(m.group()):
            print(lib, m.group().decode('latin-1')[:80])
```

Willekeurige library-namen (zoals `liba56400.so`) duiden op obfuscatie, maar niet automatisch op een shielding-product; verifieer de inhoud op productidentificatoren alvorens een conclusie te trekken.

## 10. Stap 8: Contextverificatie en vals-positieven

Elke positieve treffer dient te worden geverifieerd door vast te stellen in welk DEX-bestand de string voorkomt en welke klassen daarbij in de buurt liggen. Daarvoor dient het onderstaande script (`dex_locate.py`): het doorzoekt per DEX de stringtabel op een term en drukt treffers af, plus de typenamen die aan een optioneel trefwoord voldoen (het typefilter bepaalt of de treffer in eigen, obfuscatie- of SDK-code valt).

```python
import struct, sys, os

def uleb(data, off):
    r = 0; s = 0
    while True:
        b = data[off]; r |= (b & 0x7f) << s; off += 1
        if not (b & 0x80): return r, off
        s += 7

term = sys.argv[2].lower()
tfilter = sys.argv[3].lower() if len(sys.argv) > 3 else None
for name in sorted(os.listdir(sys.argv[1])):
    if not name.endswith('.dex'): continue
    data = open(os.path.join(sys.argv[1], name), 'rb').read()
    sn, soff = struct.unpack_from('<II', data, 0x38)
    strs = []
    for i in range(sn):
        o = struct.unpack_from('<I', data, soff + i*4)[0]
        _, p = uleb(data, o)
        e = data.index(b'\x00', p)
        strs.append(data[p:e].decode('utf-8', 'replace'))
    hits = [s for s in strs if term in s.lower()]
    if not hits: continue
    print(f"--- {name}: {len(hits)} string-treffers")
    for h in hits[:10]: print("   str:", h[:120])
    if tfilter:
        tn, toff = struct.unpack_from('<II', data, 0x40)
        types = [strs[struct.unpack_from('<I', data, toff + i*4)[0]] for i in range(tn)]
        for t in sorted(set(t for t in types if tfilter in t.lower()))[:20]:
            print("   type:", t)
```

Gebruik: `python3 dex_locate.py extracted <term> <typefilter>`; bijvoorbeeld `python3 dex_locate.py extracted droidguard wallet` (toont dat de treffer in de Google Wallet SDK ligt) of `python3 dex_locate.py extracted integrity devolksbank` (toont eigen domeincode als eigenaar van de aanroep). Gedocumenteerde vals-positieven uit de analyses:

| Zoekterm | Vals positief door |
| --- | --- |
| `frida` | de string `FRIDAY` |
| `xposed` | `ExposedDropdownMenu` (Material Components) |
| `vasco` | `CanvasCompat` (Material) |
| `vkey` | `AesGcmSivKey` (Tink), `NavKey` (androidx) |
| `seon` | `BaseOnChangeListener` |
| `datatrans` | `com.google.android.datatransport` (Firebase) |
| `attest`/`droidguard` | interne constanten van Google Wallet (`UC_DROIDGUARD_ATTESTATION`) |

Ook van toepassing: root-detectie-strings kunnen van Sentry (`RootChecker`), Onfido (`Test-keys`) of Adyen 3DS2 (`EmulatorDetectedWarning`) afkomstig zijn; pas dan de conclusie "de app blokkeert gerootte apparaten" niet zonder de eigenaar van de code vast te stellen.

## 11. Stap 9: Beoordeling per attestatie-methode

Classificeer per app de drie methoden op drie niveaus:

1. Afwezig: geen klassen, geen strings, geen dependency, geen native referentie.
2. Aanwezig maar niet als zodanig aanroepbaar: SDK-klassen of modellen aanwezig zonder gebruikssporen (bijvoorbeeld een model met een `attestationChallenge`-veld).
3. Actief gebruikt: gebruikssporen in eigen domeincode (use-case-klassen, repository-klassen, databevatten) of een service-binding.

De status "actief gebruikt" is het zwaarste bewijs en vereist minimaal één van: een aanroepende klasse van de bank zelf, een veld dat het token in een verzoek modelleert, of een GMS-service-binding.

Formulieringsregel: formuleer elke conclusie expliciet client-zijdig ("de app initieert zelf geen attestation"). De classificatie betreft uitsluitend attestation die de bank-app zelf aanroept. Integriteitscontroles die volledig binnen andere Google Play Services-diensten plaatsvinden (zoals DroidGuard-onderbouwde controles binnen Google Wallet-tokenisatie of een `MEETS_STRONG_INTEGRITY`-verdict dat door een Google-dienst intern wordt afgedwongen) blijven voor statische analyse onzichtbaar en zijn niet aan de methodiek van de bank-app toerekenbaar. Vermeld deze beperking in elk rapport; claim daarom nooit "de app ondergaat nergens attestation", maar "de app initieert zelf geen attestation".

## 12. Rapportagesjabloon

Rapporteer per app in vaste volgorde: (1) kopgegevens met pakket-ID, versie en analysevorm; (2) kernbevindingen als punten; (3) bewijstabel per attestatie-methode; (4) tabel met aanwezige beveiligingsmechanismen; (5) Wero-specifieke sectie indien van toepassing; (6) SDK-tabel; (7) beperkingen van de analyse; (8) voorgestelde dynamische vervolgstappen; (9) reproductiecommando's. Deze opbouw is gebruikt in de bunq- en ASN-documenten en maakt apps onderling vergelijkbaar. De canvases met de bunq-analyse en de ASN-analyse dienen als referentievoorbeelden en blijven tussen sessies behouden; raadpleeg ze voor de exacte opbouw van kopgegevens, bewijstabellen en de formulering van conclusies.

## 13. Beperkingen en dynamische vervolgstappen

Statische analyse ziet geen server-side beleid, remote-configuratie of voorwaardelijk geactiveerde paden. Voor volledige zekerheid: Frida-hooks op `com.google.android.play.core.integrity.*` en `KeyGenParameterSpec.Builder`, `mitmproxy` tijdens de relevante flow, en het draaien van de app zonder Google Play-diensten. De afwezigheid van `setAttestationChallenge` in zowel DEX als native libraries sluit directe hardware-attestation vrijwel volledig uit.

Twee principiële beperkingen gelden daarbij:

- Attestatievormen die volledig binnen Google Play Services plaatsvinden (zoals het hardware-onderbouwde `MEETS_STRONG_INTEGRITY`-verdict dat door een Google-dienst intern wordt afgedwongen) kunnen statisch niet worden uitgesloten. De analyse bewijst uitsluitend welke attestation de app zelf initieert (zie de formulieringsregel in sectie 11).
- De dynamische vervolgstappen zijn via de Vibe CLI niet uitvoerbaar: de omgeving bevat geen Android-runtime of emulator. Daarnaast vereist monitoring van een echte betalingsflow een account met saldo bij de betreffende bank. Beschouw deze stappen daarom als een handreiking voor lokale uitvoering met een eigen toestel en account, niet als onderdeel van het geautomatiseerde stappenplan.

## 14. Bekende resultaten tot nu toe

| App | Play Integrity | SafetyNet | Hardware-attestation | Bijzonderheden |
| --- | --- | --- | --- | --- |
| bunq v32.4.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | SCA via StrongBox-Keystore, native signing (`libsigner.so`), SQLCipher, 10+ pins |
| ASN Bank v1.36.3 | ✅ ACTIEF GEBRUIKT (SDK 1.6.0, actief in Wero-registratie) | ❌ AFWEZIG | ❌ AFWEZIG | FIDO2, iProov/Veriff, FingerprintJS Pro, KEK/SUK-hiërarchie, 4 pins |
| SNS Bank v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | Volksbank codebase, gelijk aan ASN |
| RegioBank v1.36.3 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | Volksbank codebase, gelijk aan ASN/SNS |
| ING v2025.25.1 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | Gelijk aan bunq benadering |
| ABN AMRO v13.34 | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | SafetyNet Attestation API |
| Rabobank v8.1.4 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | SQLCipher, Certificate Pinning |
| Knab v4.11.0 | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | Vals-positieven in markers |
| Revolut | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | Native root-detectie, SQLCipher |
| Trade Republic v4.2645.1 | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | Certificate Pinning |

Aanvullende context uit de Wero-merchantdocumentatie (VR Payment en PPRO): EPI schrijft de wallet-flow voor (wallets, payment-means, consents) maar stelt geen publieke attestation-eisen; apparaatbeveiliging is een beleidskeuze van de deelnemende bank. Dit verklaart waarom banken tegen dezelfde EPI-infrastructuur verschillende methodieken hanteren.