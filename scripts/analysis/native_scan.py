#!/usr/bin/env python3
"""
Native Library Scan Script
Scan .so bestanden op JNI referenties naar keystore methoden
Bron: stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md, sectie 9
"""

import re
import os
import sys


def main():
    if len(sys.argv) != 2:
        print(f"Gebruik: {sys.argv[0]} <native_libs_directory>")
        print("Voorbeeld: python3 native_scan.py extracted/sns/libs/lib/arm64-v8a/lib/arm64-v8a/")
        sys.exit(1)

    lib_dir = sys.argv[1]

    if not os.path.isdir(lib_dir):
        print(f"Fout: Directory niet gevonden: {lib_dir}")
        sys.exit(1)

    # Patterns om naar te zoeken
    patterns = [
        rb'setAttestationChallenge',
        rb'setUserAuthenticationRequired',
        rb'setIsStrongBoxBacked',
        rb'KeyGenParameterSpec',
        rb'AndroidKeyStore',
        rb'frida',
        rb'xposed',
        rb'magisk',
        rb'KeyPermanentlyInvalidatedException',
        rb'BiometricPrompt',
        rb'CryptoObject',
        rb'SQLCipher',
        rb'libsqlcipher',
    ]

    compiled_pattern = re.compile(rb'|'.join(patterns))

    print(f"Scannen: {lib_dir}")
    print()

    found_any = False

    # Scan alle .so bestanden
    for lib_file in sorted(os.listdir(lib_dir)):
        if not lib_file.endswith('.so'):
            continue

        lib_path = os.path.join(lib_dir, lib_file)
        print(f"  Scannen: {lib_file}")

        try:
            with open(lib_path, 'rb') as f:
                data = f.read()
        except Exception as e:
            print(f"    Fout bij lezen: {e}")
            continue

        # Zoek naar patterns
        matches = []
        for m in re.finditer(rb'[\x20-\x7e]{8,}', data):
            chunk = m.group()
            if compiled_pattern.search(chunk):
                matches.append(chunk.decode('latin-1', errors='replace'))

        if matches:
            found_any = True
            print(f"    ✅ Treffers gevonden:")
            for match in sorted(set(matches))[:10]:
                print(f"      - {match[:100]}")
        else:
            print(f"    ❌ Geen treffers")

    print()
    if found_any:
        print("✅ Scan voltooid - treffers gevonden")
    else:
        print("❌ Scan voltooid - geen treffers")


if __name__ == '__main__':
    main()
