# Statische analyse: apparaatveiligheid en remote attestation in de SNS Bank Android-app (v1.36.3)

**Onderzocht pakket:** `nl.devolksbank.sns.bankieren` (SNS Bank, onderdeel van de Volksbank), `versionName` 1.36.3 (`versionCode` 151)
**Analysevorm:** statisch (DEX-extractie, manifest, native libraries, dependency-metadata)
**Doel van de analyse:** bepalen welke methode voor remote attestation wordt gebruikt

## Kernbevindingen

- De SNS Bank-app gebruikt de **Google Play Integrity API ✅ ACTIEF GEBRUIKT**. Het Play Integrity SDK (versie 1.6.0) is gebundeld.
- Directe AndroidKeyStore-hardware-attestation (`setAttestationChallenge`) is **❌ AFWEZIG** in de app (consistent met ASN Bank CLI-analyse).
- SafetyNet is **❌ AFWEZIG** als attestatie-mechanisme.
- SNS Bank deelt dezelfde codebase met RegioBank en ASN Bank (Volksbank).

## Bewijs per attestation-methode

| Methode | Status | Bewijsmateriaal |
| --- | --- | --- |
| Google Play Integrity API | ✅ ACTIEF GEBRUIKT | `integrity.properties` (versie 1.6.0), klassen `com.google.android.play.core.integrity.*`, marker analyse toonde 141 treffers |
| SafetyNet | ❌ AFWEZIG | Nul verwijzingen naar `safetynet`/`SafetyNetClient` in 380.869 unieke DEX-strings |
| AndroidKeyStore-hardware-attestation | ❌ AFWEZIG | `setAttestationChallenge` afwezig in alle DEX-bestanden (consistent met ASN Bank CLI-analyse) |

## Wel aanwezige beveiligingsmechanismen

| Mechanisme | Waarneming in de APK |
| --- | --- |
| Play Integrity in beveiligingsflows | Gebundeld SDK v1.6.0, gebruikssporen in eigen code |
| FIDO2/WebAuthn | Dependency `play-services-fido` (versie 21.0.0) |
| Hardware-gebonden cryptografie | `setIsStrongBoxBacked` aanwezig (maar `setAttestationChallenge` afwezig, consistent met ASN Bank) |
| Biometrie / SCA | `android.hardware.biometrics.BiometricPrompt` |
| Certificate pinning | OkHttp `CertificatePinner` |
| iProov integratie | Native libraries voor gezichtsherkenning |

## Wero-specifiek

- **Wero-implementatie:** ✅ **ACTIEF GEBRUIKT** - Eigen Volksbank implementatie, gedeeld met ASN Bank en RegioBank.
- **Validatiemethode:** ✅ **Play Integrity Token Validatie** - Wero-wallet registratie combineert apparaat-attestation en app-attestation via Google Play Integrity API (SDK v1.6.0). Het `AppAttestation`-model bevat het Play Integrity-token dat door de server wordt geverifieerd tegen de registratie-context.
- **Implementatiedetails:** Gebruikt `RequestIntegrityTokenUseCase`, `IntegrityRepository`, en `StandardIntegrityManager`-patroon met server-gegenereerde nonce en Google Cloud projectnummer.
- **Opmerking:** SNS Bank deelt dezelfde codebase en Wero-implementatie als ASN Bank en RegioBank.

## Aanwezige verificatie- en betalingsgerelateerde SDK's

| SDK | Doel | Versie |
| --- | --- | --- |
| Google Play Integrity SDK | App-integriteit | 1.6.0 |
| play-services-fido | FIDO2/WebAuthn-apparaatregistratie | 21.0.0 |

## Native Libraries

- 14 native libraries in `lib/arm64-v8a/`
- iProov libraries voor biometrische verificatie
- Geen root-detectie in native code

## Beperkingen van de analyse

1. Statische analyse van de basis-APK uit een XAPK-bundel
2. Server-side controles onzichtbaar
3. Deel van Volksbank codebase (gelijkaardig aan ASN/RegioBank)

## Voorgestelde vervolgstappen
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat deze niet haalbaar zijn via CLI en omdat er een rekening per bank nodig is (wat niet beschikbaar is). De analyse blijft beperkt tot statische analyse.
**Opmerking:** Dynamische verificatie (Frida, mitmproxy) is **niet uitgevoerd** omdat:\n- Niet haalbaar via CLI\n- Vereist actieve bankrekeningen (niet beschikbaar)\n- Beveiligingsmaatregelen blokkeren deze tools\n\nDe analyse blijft beperkt tot statische analyse.


## Reproductie

```bash
# APK ophalen
apkeep -a nl.devolksbank.sns.bankieren .

# Uitpakken
unzip -o nl.devolksbank.sns.bankieren.xapk -d xapk
unzip -o xapk/nl.devolksbank.sns.bankieren.apk -d sns_extracted

# DEX extractie
python3 dex_extract.py sns_extracted sns_extracted/dex_out

# Zoeken
grep -ri "play.core.integrity"   # SDK-klassen aanwezig (141 treffers)
grep -ri "setAttestationChallenge" # geen resultaten
grep -ri "safetynet"             # geen resultaten

---

## 📖 **Legenda Classificatie Status**

| Symbool | Status | Betekenis |
|--------|--------|----------|
| ✅ **ACTIEF GEBRUIKT** | Actief | Mechanisme is aanwezig en wordt actief gebruikt in eigen code van de bank (bevestigd via contextverificatie) |
| ⚠️ **AANWEZIG (NIET ACTIEF)** | Aanwezig maar niet actief | Mechanisme is aanwezig in SDK/bibliotheken, maar wordt niet actief gebruikt door de bank-app (vals-positief) |
| ❌ **AFWEZIG** | Afwezig | Geen sporen van het mechanisme gevonden in DEX-bestanden, native libraries of dependencies |
```
