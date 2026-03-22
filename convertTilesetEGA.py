import sys
from PIL import Image

EGA_PALETTE = [
    (0, 0, 0), (0, 0, 170), (0, 170, 0), (0, 170, 170),
    (170, 0, 0), (170, 0, 170), (170, 85, 0), (170, 170, 170),
    (85, 85, 85), (85, 85, 255), (85, 255, 85), (85, 255, 255),
    (255, 85, 85), (255, 85, 255), (255, 255, 85), (255, 255, 255)
]

def closest_ega_color(color):
    return min(
        range(len(EGA_PALETTE)),
        key=lambda i: sum((color[j] - EGA_PALETTE[i][j])**2 for j in range(3))
    )

def convert_to_interleaved_words(image):
    image = image.resize((16, 16))
    image = image.convert("RGB")

    width_bytes = image.width // 8
    height = image.height

    planes = [[[0]*width_bytes for _ in range(height)] for _ in range(4)]

    for y in range(height):
        for x in range(0, image.width, 8):
            plane_bytes = [0]*4

            for bit in range(8):
                pixel = image.getpixel((x+bit, y))
                ega = closest_ega_color(pixel)

                for p in range(4):
                    plane_bytes[p] |= ((ega >> p) & 1) << (7-bit)

            byte_index = x // 8
            for p in range(4):
                planes[p][y][byte_index] = plane_bytes[p]

    words = []

    for y in range(height):
        for byte_index in range(0, width_bytes, 2):
            for p in range(4):
                b1 = planes[p][y][byte_index]
                b2 = planes[p][y][byte_index+1] if byte_index+1 < width_bytes else 0
                word = (b2 << 8) | b1
                words.append(word)

    return words


def format_sprite(words, sprite_index, first_sprite=False, words_per_line=8):
    lines = []

    for i in range(0, len(words), words_per_line):
        chunk = words[i:i+words_per_line]
        formatted = []

        for w in chunk:
            word_str = f"{w:04X}"
            if word_str[0] in "ABCDEF":
                word_str = "0" + word_str
            formatted.append(f"{word_str}h")

        line = ", ".join(formatted)

        # Première ligne du sprite
        if i == 0:
            if first_sprite:
                prefix = "tileset DW "
            else:
                prefix = "        DW "
            line = prefix + line + f" ;sprite {sprite_index}"
        else:
            line = "        DW " + line

        lines.append(line)

    return "\n".join(lines)


def load_sprites(image_path):
    image = Image.open(image_path)

    sprites = []
    sprite_w, sprite_h = 16, 16

    for y in range(0, image.height, sprite_h):
        for x in range(0, image.width, sprite_w):
            sprite = image.crop((x, y, x+sprite_w, y+sprite_h))
            sprites.append(sprite)

    return sprites


def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py input.bmp [output.asm]")
        return

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.asm"

    sprites = load_sprites(input_file)

    output_lines = []

    for i, sprite in enumerate(sprites):
        words = convert_to_interleaved_words(sprite)

        block = format_sprite(
            words,
            sprite_index=i,
            first_sprite=(i == 0)
        )

        output_lines.append(block)

        if i != len(sprites) - 1:
            output_lines.append("")  # ligne vide entre sprites

    with open(output_file, "w") as f:
        f.write("\n".join(output_lines))

    print(f"ASM généré: {output_file}")


if __name__ == "__main__":
    main()