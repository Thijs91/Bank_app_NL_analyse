#!/usr/bin/env python3
"""
DEX Locate Script
Locate strings in DEX files and show type context
Bron: stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md, sectie 10
"""

import struct
import sys
import os


def uleb(data, off):
    """Read ULEB128 value from data at offset"""
    r = 0
    s = 0
    while True:
        b = data[off]
        r |= (b & 0x7f) << s
        off += 1
        if not (b & 0x80):
            return r, off
        s += 7


def main():
    if len(sys.argv) < 3:
        print(f"Gebruik: {sys.argv[0]} <dex_directory> <search_term> [type_filter]")
        print("Voorbeeld: python3 dex_locate.py extracted/sns/app playintegrity devolksbank")
        print("Voorbeeld: python3 dex_locate.py extracted/rabobank/app safetynet")
        sys.exit(1)

    dex_dir = sys.argv[1]
    term = sys.argv[2].lower()
    tfilter = sys.argv[3].lower() if len(sys.argv) > 3 else None

    print(f"Zoeken naar: '{term}' in {dex_dir}")
    if tfilter:
        print(f"Type filter: '{tfilter}'")
    print()

    # Process all .dex files in the directory
    dex_files = sorted([f for f in os.listdir(dex_dir) if f.endswith('.dex')])
    
    if not dex_files:
        print("Geen .dex bestanden gevonden!")
        return

    print(f"Aantal DEX bestanden: {len(dex_files)}")
    print()

    for dex_file in dex_files:
        dex_path = os.path.join(dex_dir, dex_file)
        data = open(dex_path, 'rb').read()

        # Read string table
        sn, soff = struct.unpack_from('<II', data, 0x38)
        strings = []
        for i in range(sn):
            o = struct.unpack_from('<I', data, soff + i * 4)[0]
            _, p = uleb(data, o)
            try:
                e = data.index(b'\x00', p)
                strings.append(data[p:e].decode('utf-8', 'replace'))
            except ValueError:
                pass

        # Search for term in strings
        hits = [s for s in strings if term in s.lower()]
        if not hits:
            continue

        print(f"--- {dex_file}: {len(hits)} string-treffers")
        for h in hits[:10]:
            print(f"   str: {h[:120]}")

        if tfilter:
            # Read type table
            tn, toff = struct.unpack_from('<II', data, 0x40)
            types = [strings[struct.unpack_from('<I', data, toff + i * 4)[0]] for i in range(tn)]
            matching_types = [t for t in types if tfilter in t.lower()]
            unique_matching = sorted(set(matching_types))[:20]
            for t in unique_matching:
                print(f"   type: {t}")

    print()
    print("Zoekopdracht voltooid.")


if __name__ == '__main__':
    main()
