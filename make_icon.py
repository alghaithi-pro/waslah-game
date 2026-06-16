from PIL import Image, ImageDraw, ImageFont
import os, math

def make_icon(size):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Background: deep navy blue
    r = int(size * 0.22)
    d.rounded_rectangle([0, 0, size, size], radius=r, fill=(18, 30, 100, 255))

    # Draw 4 letter tiles in a 2x2 grid pattern
    cols = [(42, 67, 168), (30, 50, 140), (52, 80, 180), (38, 60, 155)]
    margin = size * 0.06
    gap = size * 0.03
    tile_size = (size - 2 * margin - gap) / 2

    positions = [
        (margin, margin),
        (margin + tile_size + gap, margin),
        (margin, margin + tile_size + gap),
        (margin + tile_size + gap, margin + tile_size + gap),
    ]

    letters = ['و', 'ص', 'ل', 'ة']

    for i, (x, y) in enumerate(positions):
        # Tile shadow
        d.rounded_rectangle(
            [x + 2, y + 3, x + tile_size + 2, y + tile_size + 3],
            radius=int(tile_size * 0.18),
            fill=(10, 18, 70, 180)
        )
        # Tile background
        d.rounded_rectangle(
            [x, y, x + tile_size, y + tile_size],
            radius=int(tile_size * 0.18),
            fill=cols[i]
        )
        # Letter
        font_size = int(tile_size * 0.55)
        try:
            fnt = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", font_size)
        except:
            fnt = ImageFont.load_default()
        bbox = d.textbbox((0, 0), letters[i], font=fnt)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        tx = x + (tile_size - tw) / 2 - bbox[0]
        ty = y + (tile_size - th) / 2 - bbox[1]
        d.text((tx, ty), letters[i], fill=(255, 255, 255, 255), font=fnt)

    # Gold connecting dots
    gold = (255, 193, 0, 200)
    dot_r = max(3, int(size * 0.025))
    center = size / 2
    d.ellipse([center - dot_r, center - dot_r, center + dot_r, center + dot_r], fill=gold)

    return img

os.makedirs(r"C:\Users\fathl\waslah_game\assets\icon", exist_ok=True)
make_icon(1024).save(r"C:\Users\fathl\waslah_game\assets\icon\icon.png")
print("1024 done")

sizes = {
    "mipmap-mdpi": 48, "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96, "mipmap-xxhdpi": 144, "mipmap-xxxhdpi": 192
}
for folder, sz in sizes.items():
    path = rf"C:\Users\fathl\waslah_game\android\app\src\main\res\{folder}"
    os.makedirs(path, exist_ok=True)
    make_icon(sz).save(f"{path}\\ic_launcher.png")
    make_icon(sz).save(f"{path}\\ic_launcher_round.png")
    print(f"  {folder}: {sz}px")
print("All icons done!")
