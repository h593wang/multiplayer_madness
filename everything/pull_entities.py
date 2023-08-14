import json
import os
from wikidata.client import Client

with open("everything/pagepile_json_34426.json") as f:
    pile = json.load(f)
entity_ids: list[str] = pile["pages"]

client = Client()
for entity_id in entity_ids:
    local_path = os.path.join("everything/data/entity", f"{entity_id}.json")
    if os.path.exists(local_path):
        continue
    entity = client.get(entity_id, load=True)
    with open(local_path, "w") as f:
        json.dump(entity.data, f)
