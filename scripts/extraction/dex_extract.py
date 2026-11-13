#!/usr/bin/env python3
"""
DEX Extractie Script
Extract strings en types uit DEX-bestanden
Bron: stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md, sectie 6
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


def extract_dex_file(dex_path, output_dir):
    """Extract strings and types from a single DEX file"""
    try:
        data = open(dex_path, 'rb').read()
    except FileNotFoundError:
        print(f"  Warning: DEX file not found: {dex_path}")
        return [], []
    except Exception as e:
        print(f"  Error reading {dex_path}: {e}")
        return [], []

    strings = []
    types = []

    # Read string table
    sn, soff = struct.unpack_from('<II', data, 0x38)
    for i in range(sn):
        o = struct.unpack_from('<I', data, soff + i * 4)[0]
        _, p = uleb(data, o)
        try:
            e = data.index(b'\x00', p)
            strings.append(data[p:e].decode('utf-8', 'replace'))
        except ValueError:
            # No null terminator found
            pass

    # Read type table
    tn, toff = struct.unpack_from('<II', data, 0x40)
    for i in range(tn):
        types.append(strings[struct.unpack_from('<I', data, toff + i * 4)[0]])

    return strings, types


def main():
    if len(sys.argv) != 3:
        print(f"Gebruik: {sys.argv[0]} <dex_directory> <output_directory>")
        print("Voorbeeld: python3 dex_extract.py extracted/sns/app extracted/sns/dex_out")
        sys.exit(1)

    dex_dir = sys.argv[1]
    output_dir = sys.argv[2]

    print(f"Extractie DEX bestanden uit: {dex_dir}")
    print(f"Output directory: {output_dir}")

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    all_strings = []
    all_types = []

    # Process all .dex files in the directory
    dex_files = sorted([f for f in os.listdir(dex_dir) if f.endswith('.dex')])
    
    if not dex_files:
        print("  Geen .dex bestanden gevonden!")
        print(f"  Beschikbare bestanden in {dex_dir}:")
        for f in os.listdir(dex_dir):
            print(f"    - {f}")
        sys.exit(1)

    print(f"  Aantal DEX bestanden: {len(dex_files)}")
    
    for dex_file in dex_files:
        print(f"  Verwerken: {dex_file}")
        dex_path = os.path.join(dex_dir, dex_file)
        strings, types = extract_dex_file(dex_path, output_dir)
        all_strings.extend(strings)
        all_types.extend(types)

    # Write output files
    strings_file = os.path.join(output_dir, 'strings_all.txt')
    types_file = os.path.join(output_dir, 'types_all.txt')

    # Write unique strings
    unique_strings = sorted(set(all_strings))
    with open(strings_file, 'w') as f:
        f.write('\n'.join(unique_strings))

    # Write unique types
    unique_types = sorted(set(all_types))
    with open(types_file, 'w') as f:
        f.write('\n'.join(unique_types))

    print(f"\n  Resultaten:")
    print(f"    - Aantal unieke strings: {len(unique_strings):,}")
    print(f"    - Aantal unieke types: {len(unique_types):,}")
    print(f"    - strings_all.txt: {strings_file}")
    print(f"    - types_all.txt: {types_file}")


if __name__ == '__main__':
    main()
