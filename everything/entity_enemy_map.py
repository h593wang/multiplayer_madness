from dataclasses import dataclass, field
import os
from typing import Optional

from dataclasses_json import DataClassJsonMixin

from .enemy import Enemy


DEFAULT_FILENAME = "everything/enemies.json"


@dataclass(kw_only=True)
class EntityEnemyMap(DataClassJsonMixin):
    enemies: dict[str, Enemy] = field(default_factory=dict)
    excluded: dict[str, str] = field(default_factory=dict)

    def __post_init__(self):
        assert len(set(self.enemies.keys()) & set(self.excluded.keys())) == 0

    def __contains__(self, entity_id: str) -> bool:
        return entity_id in self.enemies or entity_id in self.excluded

    def __len__(self) -> int:
        return len(self.enemies) + len(self.excluded)

    def entity_ids(self) -> set[str]:
        return set(self.enemies.keys()) | set(self.excluded.keys())

    def add_enemy(self, enemy: Enemy) -> None:
        entity_id = enemy.entity_id
        assert entity_id is not None
        assert entity_id not in self
        self.enemies[entity_id] = enemy

    def exclude_entity(self, entity_id: str, reason: str) -> None:
        assert entity_id not in self
        self.excluded[entity_id] = reason

    @classmethod
    def load_json_file(
        cls,
        filename: str = DEFAULT_FILENAME,
    ) -> Optional["EntityEnemyMap"]:
        if os.path.exists(filename):
            with open(filename) as f:
                return cls.from_json(f.read())
        return None

    def save_json_file(
        self,
        filename: str = DEFAULT_FILENAME,
    ):
        with open(filename, "w") as f:
            f.write(self.to_json(indent=2))


if __name__ == "__main__":
    entity_enemy_map = EntityEnemyMap()
    with open("everything/universe.json") as f:
        universe = Enemy.from_json(f.read())
    entity_enemy_map.add_enemy(universe)

    entity_enemy_map.save_json_file()
    assert EntityEnemyMap.load_json_file() == entity_enemy_map
