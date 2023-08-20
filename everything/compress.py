import json

with open("everything/enemies_no_special.json") as f:
    enemies: dict[str, dict] = json.load(f)["enemies"]

keys = (
    "name",
    "image_path",
    "image_width",
    "image_height",
    "health",
    "speed",
)
compressed = [
    { key: enemy[key] for key in keys }
    for enemy in enemies.values()
]

with open("everything/enemies_no_special_compressed.json", "w") as f:
    json.dump(compressed, f)
