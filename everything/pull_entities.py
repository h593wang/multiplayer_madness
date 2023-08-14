import hashlib
import json
import os
from typing import Optional

import requests
from wikidata.client import Client

EXCLUDE = {
    "Q5": "nudity"
}

def md5(s: str) -> str:
    return hashlib.md5(s.encode("utf-8")).hexdigest()

def get_thumb(name: str) -> tuple[str, str]:
    url = f"{THUMB_BASE_URL}?width={IMG_WIDTH}&f={name}"
    return url, name

def get_svg(name: str) -> str:
    # https://stackoverflow.com/a/34402875
    h = md5(name)
    url = f"{IMAGE_BASE_URL}/{h[0]}/{h[0:2]}/{name}"
    return url, name

def get_tif(name: str) -> str:
    h = md5(name)
    thumb_name = f"lossy-page1-640px-{name}.jpg"
    url = f"{TIF_THUMB_BASE_URL}/{h[0]}/{h[0:2]}/{name}/{thumb_name}"
    return url, thumb_name

USER_AGENT_HEADER = {
    "User-Agent": "EverythingSurvivor/scraper/1.0",
    "From": "contact@ugo-ii.com",
}
DATA_DIR = "everything/data"
ENTITY_DIR = os.path.join(DATA_DIR, "entity")
IMAGE_DIR = os.path.join(DATA_DIR, "image")
THUMB_BASE_URL = "https://commons.wikipedia.org/w/thumb.php"
IMAGE_BASE_URL = "https://upload.wikimedia.org/wikipedia/commons"
TIF_THUMB_BASE_URL = "https://upload.wikimedia.org/wikipedia/commons/thumb"
IMG_WIDTH = 400
IMAGE_EXTENSIONS = dict(
    gif=get_thumb,
    jpeg=get_thumb,
    jpg=get_thumb,
    png=get_thumb,
    svg=get_svg,
    tif=get_tif,
)
ENTITY_TO_IMAGE_PATH = os.path.join(DATA_DIR, "entity_to_image.json")

def get_extension(file_name: str) -> str:
    raw_extension: str = os.path.splitext(file_name)[-1]
    extension = raw_extension.lstrip(" .").lower()
    return extension

def is_image(image_name: str) -> bool:
    return get_extension(image_name) in IMAGE_EXTENSIONS

def get_image(image_name: str) -> tuple[str, str]:
    return IMAGE_EXTENSIONS[get_extension(image_name)](image_name)

with open("everything/pagepile_json_34426.json") as f:
    pile = json.load(f)
entity_ids: list[str] = pile["pages"]
entity_ids = list(filter(lambda id: id not in EXCLUDE, entity_ids))
entity_ids.sort(key=lambda id: int(id[1:]))

client = Client()
entity_to_image: dict[str, str] = {}
for i, entity_id in enumerate(entity_ids):
    local_entity_path = os.path.join(ENTITY_DIR, f"{entity_id}.json")
    if os.path.exists(local_entity_path):
        with open(local_entity_path) as f:
            entity_data = json.load(f)
    else:
        entity = client.get(entity_id, load=True)
        entity_data = entity.data
        with open(local_entity_path, "w") as f:
            json.dump(entity_data, f)

    title: str = entity_data["labels"]["en"]["value"]
    print(f"{i:04d}\t{entity_id}\t{title}")

    image_name: Optional[str] = None
    for j, item in enumerate(entity_data["claims"].get("P18", [])):
        maybe_image_name = item["mainsnak"]["datavalue"]["value"].replace(" ", "_")
        if not is_image(maybe_image_name):
            continue
        image_url, image_name = get_image(maybe_image_name)
        entity_to_image[entity_id] = image_name
        print(f"\t\t\t{j}\t{image_name}")

        local_image_path = os.path.join(IMAGE_DIR, image_name)
        if not os.path.exists(local_image_path):
            response = requests.get(image_url, headers=USER_AGENT_HEADER)
            assert response.ok
            with open(local_image_path, "wb") as f:
                f.write(response.content)
        break

    if image_name is None:
        print("\t\t\tNO IMAGE FOUND")

with open(ENTITY_TO_IMAGE_PATH, "w") as f:
    json.dump(entity_to_image, f, indent=2)
