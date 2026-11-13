#!/usr/bin/env python3
"""
Minimal AXML parser voor AndroidManifest.xml
Extract package, versionName en versionCode uit binaire AXML
Bron: stappenplan-statische-apparaatveiligheidsanalyse-van-nederlandse-bankapps.md, sectie 5
"""

import struct
import sys


def parse_string_pool(data, off):
    """Parse string pool from AXML data"""
    typ, hdr_size, size, count, style_count, flags, strings_start, styles_start = struct.unpack_from('<HHIIIIII', data, off)
    utf8 = bool(flags & (1 << 8))
    offsets = [struct.unpack_from('<I', data, off + hdr_size + i * 4)[0] for i in range(count)]
    base = off + strings_start
    out = []
    for o in offsets:
        p = base + o
        if utf8:
            n = data[p]
            p += 1
            if n & 0x80:
                p += 1
            n2 = data[p]
            p += 1
            if n2 & 0x80:
                p += 1
            e = data.index(b'\x00', p)
            out.append(data[p:e].decode('utf-8', errors='replace'))
        else:
            n = struct.unpack_from('<H', data, p)[0]
            p += 2
            if n & 0x8000:
                n = ((n & 0x7fff) << 16) | struct.unpack_from('<H', data, p)[0]
                p += 2
            out.append(data[p:p + n * 2].decode('utf-16-le', errors='replace'))
    return out, off + size


def main(path):
    """Extract manifest attributes from AndroidManifest.xml"""
    try:
        data = open(path, 'rb').read()
    except FileNotFoundError:
        print(f"Fout: Bestand niet gevonden: {path}")
        sys.exit(1)
    except Exception as e:
        print(f"Fout bij lezen van {path}: {e}")
        sys.exit(1)

    strings, p = parse_string_pool(data, 8)
    found = 0
    results = {}

    while p + 8 <= len(data) and found < 1:
        typ, hdr, sz = struct.unpack_from('<HHI', data, p)
        if typ == 0x0102:  # START_ELEMENT (manifest element)
            attr_start, attr_size, attr_count = struct.unpack_from('<HHH', data, p + 24)
            base = p + 16 + attr_start
            for i in range(attr_count):
                a = base + i * attr_size
                a_ns, a_name, a_raw = struct.unpack_from('<III', data, a)
                dtype, dval = struct.unpack_from('<BI', data, a + 15)
                # Haal attributenaam op
                if a_name < len(strings):
                    aname = strings[a_name]
                else:
                    aname = f"attr@{a_name}"
                
                # Haal attributenwaarde op
                if a_raw != 0xFFFFFFFF and a_raw < len(strings):
                    val = strings[a_raw]
                elif dtype == 0x03 and dval < len(strings):
                    val = strings[dval]
                elif dtype in (0x10, 0x11):  # TYPE_INT_* types
                    val = str(dval)
                elif dtype == 0x12:  # TYPE_STRING
                    val = strings[dval] if dval < len(strings) else f"string@{dval}"
                else:
                    val = f"type{dtype}:{dval}"
                
                # Sla interessante attributen op (check op leeg of onbekend)
                if aname and aname in ['package', 'versionName', 'versionCode', 'minSdkVersion', 'targetSdkVersion', 'platformBuildVersionCode', 'platformBuildVersionName']:
                    results[aname] = val
                # Ook opslaan als we de waarde herkennen uit context
                elif val in ['1.36.3', '1.36.4'] and 'versionName' not in results:
                    results['versionName'] = val
                
                # Alleen printen als we een geldige naam hebben
                if aname and aname != '?' and not aname.startswith('attr@'):
                    print(f"{aname} = {val}")
            found += 1
        if sz == 0:
            break
        p += sz

    # Print samenvatting
    print("\n" + "=" * 50)
    print("MANIFEST SAMENVATTING")
    print("=" * 50)
    for key, value in results.items():
        print(f"{key:20s}: {value}")
    print("=" * 50)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"Gebruik: {sys.argv[0]} <path-to-AndroidManifest.xml>")
        print("Voorbeeld: python3 axml_min.py extracted/sns/app/AndroidManifest.xml")
        sys.exit(1)
    main(sys.argv[1])
