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

def convert_to_interleaved_words(file_path):
    image = Image.open(file_path)
    image = image.resize((32, 32))
    image = image.convert("RGB")

    width_bytes = image.width // 8  # 40 bytes par ligne
    height = image.height

    # [plane][y][byte]
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

    # Interleave par ligne + convertir en WORD
    words = []

    for y in range(height):
        for byte_index in range(0, width_bytes, 2):  # 2 bytes = 1 word
            for p in range(4):
                b1 = planes[p][y][byte_index]
                b2 = planes[p][y][byte_index+1] if byte_index+1 < width_bytes else 0
                word = (b2 << 8) | b1   # little endian
                words.append(word)

    return words

def format_words_to_asm(words, words_per_line=8):
    lines = []

    for i in range(0, len(words), words_per_line):
        chunk = words[i:i+words_per_line]
        formatted = []

        for w in chunk:
            word_str = f"{w:04X}"

            # ajoute 0 si commence par A-F
            if word_str[0] in "ABCDEF":
                word_str = "0" + word_str

            formatted.append(f"{word_str}h")

        lines.append("DW " + ", ".join(formatted))

    return "\n".join(lines)

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py input.bmp [output.asm]")
        return

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.asm"

    words = convert_to_interleaved_words(input_file)
    asm = format_words_to_asm(words)

    with open(output_file, "w") as f:
        f.write(asm)

    print(f"ASM généré: {output_file}")

if __name__ == "__main__":
    main()
