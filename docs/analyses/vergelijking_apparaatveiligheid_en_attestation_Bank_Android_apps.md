# Vergelijking: apparaatveiligheid en attestation in Bank-Android-apps

Deze vergelijking bundelt de statische analyses van Nederlandse en internationale bank apps. Alle analyses zijn CLI-gebaseerd bevestigd met contextverificatie waar mogelijk.

**Onderzochte apps:**
- ABN AMRO (v13.34, `com.abnamro.nl.mobile.payments`)
- ASN Bank (v1.36.3, `nl.devolksbank.asn.bankieren`, onderdeel van de Volksbank)
- bunq (v32.4.1, `com.bunq.android`)
- ING (v2025.25.1, `com.ing.mobile`)
- Knab (v4.11.0, `bvm.bvmapp`)
- Rabobank (v8.1.4, `nl.rabomobiel`)
- RegioBank (v1.36.3, `nl.devolksbank.regio.bankieren`, onderdeel van de Volksbank)
- Revolut (v10.153.1, `com.revolut.revolut`)
- SNS Bank (v1.36.3, `nl.devolksbank.sns.bankieren`, onderdeel van de Volksbank)
- Trade Republic (v4.2645.1, `de.traderepublic.app`)
- Triodos Bank (v5.13.7, `com.triodos.bankingnl`)

Dit document zet de bevindingen naast elkaar op basis van de individuele analyses in:
`statische-analyse-apparaatveiligheid-in-de-###.md`

---

## Vergelijkingstabel

| Aspect | ABN AMRO | ASN Bank | bunq | ING | Knab | Rabobank | RegioBank | Revolut | SNS Bank | Trade Republic | Triodos |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Versie** | 13.34 | 1.36.3 | 32.4.1 | 2025.25.1 | 4.11.0 | 8.1.4 | 1.36.3 | 10.153.1 | 1.36.3 | 4.2645.1 | 5.13.7 |
| **Pakketnaam** | com.abnamro.nl.mobile.payments | nl.devolksbank.asn.bankieren | com.bunq.android | com.ing.mobile | bvm.bvmapp | nl.rabomobiel | nl.devolksbank.regio.bankieren | com.revolut.revolut | nl.devolksbank.sns.bankieren | de.traderepublic.app | com.triodos.bankingnl |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Google Play Integrity API** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **SafetyNet** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Directe hardware-attestation (`setAttestationChallenge`)** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG |
| **FIDO2/WebAuthn** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **StrongBox** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **Biometrie / SCA** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **setUserAuthenticationRequired** | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT |
| **Certificate pinning** | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ⚠️ AANWEZIG (NIET ACTIEF) | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❓ NIET GEÏNSPECTEERD |
| **SQLCipher** | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ⚠️ AANWEZIG (NIET ACTIEF) | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Native root-detectie** | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Native signing-componenten** | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ✅ Aanwezig | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❓ Niet geïdentificeerd | ❌ AFWEZIG | ❌ AFWEZIG | ✅ Aanwezig |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Identiteitsverificatie** | Onbekend | Onfido, Incode, iProov, Veriff, Innovalor | Onfido, Incode | Onbekend | iProov, ML Kit OCR | Onbekend | iProov | Onbekend | iProov | Onbekend | Onbekend |
| **Apparaatvingerprinting** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT (FingerprintJS Pro) | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Kaartbetalingen / 3DS** | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT (Adyen 3DS2) | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Google Pay** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG |
| **Telemetrie** | Onbekend | Firebase Crashlytics | Sentry | Onbekend | Onbekend | Onbekend | Onbekend | Onbekend | Onbekend | Onbekend | Onbekend |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Wero-implementatie** | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ❌ AFWEZIG | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT | ❌ AFWEZIG | ✅ ACTIEF GEBRUIKT |
| **Wero-validatiemethode** | ❌ Geen Wero | ✅ Play Integrity + FIDO2 | ✅ Hardware-binding | ❌ Geen Wero | ❌ Geen Wero | ❌ Geen Wero | ✅ Play Integrity | ❌ Geen Wero | ✅ Play Integrity | ❌ Geen Wero | ✅ Server-side |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Obfuscatie** | Onbekend | Zwaar (R8) | Licht (R8) | Onbekend | Onbekend | Onbekend | Zwaar (R8) | Onbekend | Zwaar (R8) | Onbekend | Onbekend |
| **Schaal van de app** | Onbekend | 6 DEX, ~243K strings | 12 DEX, ~497K strings | 9 DEX, ~468K strings | 7 DEX | 8 DEX | 6 DEX, ~381K strings | 22 DEX | 6 DEX, ~381K strings | 2 DEX | 2 DEX, ~82K strings |

---

## 📖 Legenda Classificatie Status

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
| ❓ **NIET GEÏNSPECTEERD** | Niet gecontroleerd | Mechanisme is niet specifiek onderzocht in de analyse |

---

## Interpretatie

### Attestation Strategieën

De banken hanteren drie hoofdbenaderingen voor apparaatveiligheid en remote attestation:

#### 1. **Volledige Attestation Stack (2 banken)**
- **Revolut**: Combineert **Google Play Integrity API** en **SafetyNet** voor maximale dekking, plus **native root-detectie** en **SQLCipher** voor databaseversleuteling.
- **Trade Republic**: Gebruikt **Google Play Integrity API** + **AndroidKeyStore-hardware-attestation** (`setAttestationChallenge`) voor een diepgaande hardware-gebonden benadering.

#### 2. **Play Integrity Focus (Volksbank Groep - 3 banken)**
- **ASN Bank, RegioBank, SNS Bank**: Alle drie gebruiken **Google Play Integrity API ✅ ACTIEF GEBRUIKT** in hun Wero-implementatie, gecombineerd met **FIDO2/WebAuthn**. Geen SafetyNet of directe hardware-attestation. Deze banken delen dezelfde codebase.

#### 3. **Geen Actieve Attestation (6 banken)**
- **ABN AMRO**: Vertrouwt op **SafetyNet** (niet Play Integrity) voor remote attestation.
- **bunq**: Geen remote attestation, maar wel **StrongBox-gebonden sleutels**, **SQLCipher**, en een **server-side vertrouwd-apparaatmodel**.
- **ING**: Geen remote attestation-mechanismen, maar wel **setUserAuthenticationRequired** (StrongBox vals-positief).
- **Knab**: Geen actieve attestation. **Play Integrity** en **SafetyNet** zijn ❌ AFWEZIG (vals-positief in marker analyse; geen bvm types in contextverificatie). **StrongBox**, **setUserAuthenticationRequired**, **Certificate pinning** en **BiometricPrompt** zijn ⚠️ AANWEZIG (NIET ACTIEF).
- **Rabobank**: Geen actieve attestation. **SafetyNet** is ❌ AFWEZIG (vals-positief; geen nl.rabomobiel types). **StrongBox**, **setUserAuthenticationRequired** en **SQLCipher** zijn ⚠️ AANWEZIG (NIET ACTIEF). Wel **Certificate pinning** ✅ ACTIEF GEBRUIKT (CertificatePinner.kt in eigen code) en **BiometricPrompt** ✅ ACTIEF GEBRUIKT (nl.rabomobiel types bevestigd).
- **Triodos**: Geen remote attestation, maar wel **native root-detectie** en een eigen **Wero-implementatie**.

### Wero-implementaties

| Bank | Wero Status | Validatiemethode | Attestation Mechanisme |
|------|-------------|------------------|------------------------|
| ABN AMRO | ❌ AFWEZIG | Geen | Geen |
| ASN Bank | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Google Play Integrity API |
| bunq | ✅ ACTIEF GEBRUIKT | Server-side Validatie | Hardware-binding |
| ING | ❌ AFWEZIG | Geen | Geen |
| Knab | ❌ AFWEZIG | Geen | Geen |
| Rabobank | ❌ AFWEZIG | Geen | Geen |
| RegioBank | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Google Play Integrity API |
| Revolut | ❌ AFWEZIG | Geen | Geen |
| SNS Bank | ✅ ACTIEF GEBRUIKT | Play Integrity Token Validatie | Google Play Integrity API |
| Trade Republic | ❌ AFWEZIG | Geen | Geen |
| Triodos | ✅ ACTIEF GEBRUIKT | Server-side Validatie | Geen (native root-detectie) |

Opmerkelijk:
- **Volksbank (ASN/Regio/SNS)** koppelt Play Integrity expliciet aan de wallet-registratie met server-gegenereerde nonce en Google Cloud projectnummer.
- **bunq** en **Triodos** implementeren Wero **zonder** app-side attestation, met validatie volledig server-side.
- **Revolut** en **Trade Republic** gebruiken robuuste attestation-mechanismen, maar hebben **geen** Wero-implementatie.

### Beveiligingsniveaus

#### Meervoudige attestation + extra beveiligingslagen
- **Revolut**: Play Integrity + SafetyNet + Native root-detectie + SQLCipher
- **Trade Republic**: Play Integrity + Hardware-attestation + Certificate pinning
- **Triodos**: Wero + Native root-detectie + StrongBox

#### Enkel attestation of sterke cryptografie
- **ASN Bank / RegioBank / SNS Bank**: Play Integrity + FIDO2
- **ABN AMRO**: SafetyNet + SQLCipher
- **bunq**: StrongBox + SQLCipher + Native signing
- **Rabobank**: Certificate pinning ✅ ACTIEF GEBRUIKT + BiometricPrompt ✅ ACTIEF GEBRUIKT

#### Geen actieve attestation, beperkte cryptografie
- **ING**: setUserAuthenticationRequired (StrongBox vals-positief)
- **Knab**: Geen actieve mechanismen bevestigd in eigen code (Play Integrity, SafetyNet, StrongBox, Certificate pinning, BiometricPrompt alle vals-positief of afwezig)

---

## Beperkingen

1. **Statische analyse**: Alle analyses zijn statisch uitgevoerd op de beschikbare APK/XAPK-bestanden. Dynamische gedragingen, server-side controles en remote-configuratie blijven onzichtbaar.

2. **Versie-specifiek**: De analyses betreffen specifieke versies van de apps. Latere versies kunnen afwijken in implementatie.

3. **Contextverificatie**: Contextverificatie is nu uitgevoerd voor Knab en Rabobank. Bevestigd dat Play Integrity (Knab), SafetyNet (Knab, Rabobank), StrongBox (Knab, Rabobank), setUserAuthenticationRequired (Knab, Rabobank), SQLCipher (Rabobank) en Certificate pinning (Knab) vals-positieven zijn. Certificate pinning (Rabobank) en BiometricPrompt (Rabobank) zijn bevestigd als actief gebruikt in eigen code.

4. **Native code**: Native libraries (`.so`-bestanden) zijn gescand op specifieke strings, maar een volledige reverse-engineering is niet uitgevoerd.

5. **Obfuscatie**: Banken zoals ASN, RegioBank, SNS Bank en Revolut gebruiken zware obfuscatie (R8), wat de analyse bemoeilijkt.

6. **Server-side beslissingen**: De uiteindelijke risicobeslissing wordt in alle gevallen server-side genomen. De aanwezigheid van een mechanisme in de app bewijst niet dat deze daadwerkelijk wordt afgedwongen.

---

## Conclusies

1. **Volksbank Groep (ASN, Regio, SNS)** toont de meest transparante implementatie van **Google Play Integrity API** voor Wero-walletregistratie, gecombineerd met **FIDO2/WebAuthn** voor apparaatregistratie.

2. **Revolut** heeft **meervoudige attestation** (Play Integrity + SafetyNet) en **native root-detectie**, maar mist Wero-integratie.

3. **Trade Republic** is de enige bank die **AndroidKeyStore-hardware-attestation** (`setAttestationChallenge`) actief gebruikt, naas Play Integrity.

4. **bunq** en **Triodos** kiezen voor een **attestation-loos model** met sterke focus op hardware-gebonden cryptografie en server-side validatie.

5. **ABN AMRO** is de enige traditionele Nederlandse bank die **SafetyNet** gebruikt (in plaats van Play Integrity).

6. **Wero-adoptie** is beperkt tot 5 banken: Volksbank Groep (ASN, Regio, SNS), bunq en Triodos. De meerderheid van de banken (6 van 11) heeft nog geen Wero-implementatie.

---

*Laatst geactualiseerd: 7 november 2026*
*Analyse gebaseerd op CLI-verificatie van statische APK-extracties*
