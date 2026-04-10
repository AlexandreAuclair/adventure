import xml.etree.ElementTree as ET

# Flags Tiled (bits 32)
FLIP_H = 0x80000000
FLIP_V = 0x40000000
FLIP_D = 0x20000000
FLAG_MASK = ~(FLIP_H | FLIP_V | FLIP_D)


def parse_tmx(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Trouver le premier tileset
    tileset = root.find("tileset")
    firstgid = int(tileset.attrib["firstgid"])

    # Trouver le layer
    layer = root.find("layer")
    data = layer.find("data")

    if data.attrib.get("encoding") != "csv":
        raise Exception("Le TMX doit être en encoding CSV")

    raw_csv = data.text.strip().replace("\n", "")
    gids = [int(x) for x in raw_csv.split(",")]

    tiles = []

    for gid in gids:
        if gid == 0:
            tiles.append(0)
            continue

        # enlever les flags
        gid = gid & FLAG_MASK

        # convertir en index local
        tile_id = gid - firstgid

        tiles.append(tile_id)

    return tiles


def write_asm(tiles, width, output_file):
    with open(output_file, "w") as f:
        for i in range(0, len(tiles), width):
            row = tiles[i:i+width]

            line = "    db " + ",".join(f"{t:02X}h" for t in row)
            f.write(line + "\n")


if __name__ == "__main__":
    input_file = "map/map2.tmx"
    output_file = "map.asm"

    tiles = parse_tmx(input_file)

    # ⚠️ ajuste selon ta map
    width = 20  

    write_asm(tiles, width, output_file)

    print("Conversion terminée !")