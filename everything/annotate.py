import json
import os
import shutil
from typing import Any, Mapping, Optional

import requests
from PIL import Image
from wikidata.client import Client

from .enemy import Level, ProjectileAttack, AreaAttack, ChargeAttack, Hazard, Enemy
from .entity_enemy_map import EntityEnemyMap

DATA_DIR = "everything/data"
ENTITY_DIR = os.path.join(DATA_DIR, "entity")
IMAGE_DIR = os.path.join(DATA_DIR, "image")
PREVIEW_DIR = os.path.join(DATA_DIR, "preview")

def load_entity_ids(
        pile_filename: str = "everything/pagepile_json_34426.json",
) -> list[str]:
    with open(pile_filename) as f:
        pile = json.load(f)
    return sorted(pile["pages"], key=lambda id: int(id[1:]))

def get_extension(file_name: str) -> str:
    raw_extension: str = os.path.splitext(file_name)[-1]
    extension = raw_extension.lstrip(" .").lower()
    return extension

IMAGE_EXTENSIONS = set(("jpeg", "jpg", "png"))
def is_image(image_name: str) -> bool:
    return get_extension(image_name) in IMAGE_EXTENSIONS

def load_entity_data(entity_id: str, client: Client) -> Mapping[str, Any]:
    local_entity_path = os.path.join(ENTITY_DIR, f"{entity_id}.json")
    if os.path.exists(local_entity_path):
        with open(local_entity_path) as f:
            entity_data = json.load(f)
    else:
        entity = client.get(entity_id, load=True)
        entity_data = entity.data
        with open(local_entity_path, "w") as f:
            json.dump(entity_data, f)
    return entity_data

def get_image_names(entity_data: Mapping[str, Any]) -> list[str]:
    images: list[str] = []
    for item in entity_data["claims"].get("P18", []):
        image_name = item["mainsnak"]["datavalue"]["value"].replace(" ", "_")
        if is_image(image_name):
            images.append(image_name)
    return images

THUMB_BASE_URL = "https://commons.wikipedia.org/w/thumb.php"
def get_thumb_url(name: str, width: int = 240) -> tuple[str, str]:
    return f"{THUMB_BASE_URL}?width={width}&f={name}"

USER_AGENT_HEADER = {
    "User-Agent": "EverythingSurvivor/scraper/1.0",
    "From": "contact@ugo-ii.com",
}
def save_image_preview(entity_id: str, image_name: str) -> str:
    entity_dir = os.path.join(IMAGE_DIR, entity_id)
    os.makedirs(entity_dir, exist_ok=True)

    local_path = os.path.join(entity_dir, image_name)
    if not os.path.exists(local_path):
        thumb_url = get_thumb_url(image_name)
        response = requests.get(thumb_url, headers=USER_AGENT_HEADER)
        assert response.ok, thumb_url
        with open(local_path, "wb") as f:
            f.write(response.content)
    return local_path

if __name__ == "__main__":
    client = Client()
    entity_ids = load_entity_ids()
    entity_enemy_map = EntityEnemyMap.load_json_file(filename="everything/enemies_no_special.json")
    for entity_id in entity_ids:
        if entity_id in entity_enemy_map:
            continue

        i = len(entity_enemy_map) + 1
        entity_data = load_entity_data(entity_id=entity_id, client=client)
        title: str = entity_data["labels"]["en"]["value"]
        print(f"{i:04d}/{len(entity_ids)} | {entity_id} | {title}")

        image_names = get_image_names(entity_data)
        if len(image_names) == 0:
            print("\tEXCLUDING: no image found")
            entity_enemy_map.exclude_entity(
                entity_id=entity_id,
                reason="no image",
            )
            continue

        print(f"\t{len(image_names)} images found.")
        local_image_paths = [
            save_image_preview(
                entity_id=entity_id,
                image_name=image_name,
            )
            for image_name in image_names
        ]
        for i, (image_name, local_path) in enumerate(zip(image_names, local_image_paths)):
            ext = get_extension(local_path)
            preview_path = os.path.join(PREVIEW_DIR, f"{i+1}.{ext}")
            # can't use symlinks for VS Code preview :(
            shutil.copy(src=local_path, dst=preview_path)
        selection = input(f"\tPrefered image (1..{len(image_names)}, or a reason to reject): ")
        try:
            selection_index = int(selection) - 1
            selected_image_name = image_names[selection_index]
            selected_local_image_path = local_image_paths[selection_index]
        except:
            print("\tEXCLUDING: images rejected")
            entity_enemy_map.exclude_entity(
                entity_id=entity_id,
                reason=f"images rejected: {selection}"
            )
            continue

        width, height = Image.open(selected_local_image_path).size

        health = Level.from_prompt("\tHealth")
        # power = Level.from_prompt("\tPower")
        speed = Level.from_prompt("\tSpeed")

        # projectile_attack: Optional[ProjectileAttack] = None
        # if input("\tProjectile Attack? [y/N]: ").lower().strip() in set(("y", "ye", "yes")):
        #     projectile_attack = ProjectileAttack.from_prompts(prefix="\t")

        # area_attack: Optional[AreaAttack] = None
        # if input("\tArea Attack? [y/N]: ").lower().strip() in set(("y", "ye", "yes")):
        #     area_attack = AreaAttack.from_prompts(prefix="\t")

        # charge_attack: Optional[ChargeAttack] = None
        # if input("\tCharge Attack? [y/N]: ").lower().strip() in set(("y", "ye", "yes")):
        #     charge_attack = ChargeAttack.from_prompts(prefix="\t")

        # hazard: Optional[Hazard] = None
        # if input("\tHazard? [y/N]: ").lower().strip() in set(("y", "ye", "yes")):
        #     hazard = Hazard.from_prompts(prefix="\t")

        enemy = Enemy(
            name=title,
            entity_id=entity_id,
            image_path=image_name,
            image_width=width,
            image_height=height,
            health=health,
            power=None,
            speed=speed,
        )
        if input("\tConfirm [Y/n]: ").lower().strip() not in set(("n", "no")):
            entity_enemy_map.add_enemy(enemy)
            entity_enemy_map.save_json_file(filename="everything/enemies_no_special.json")

    entity_enemy_map.save_json_file(filename="everything/enemies_no_special.json")
