from dataclasses import dataclass
from enum import Enum
from typing import Optional
from dataclasses_json import DataClassJsonMixin

class Level(Enum):
    NORMAL = "NORMAL"
    LOW = "LOW"
    HIGH = "HIGH"


@dataclass(kw_only=True, frozen=True)
class ProjectileAttack(DataClassJsonMixin):
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL
    projectile_size: Level = Level.NORMAL
    projectile_speed: Level = Level.NORMAL

@dataclass(kw_only=True, frozen=True)
class AreaAttack(DataClassJsonMixin):
    area_size: Level = Level.NORMAL
    attack_delay: Level = Level.NORMAL
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL

@dataclass(kw_only=True, frozen=True)
class ChargeAttack(DataClassJsonMixin):
    attack_delay: Level = Level.NORMAL
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL
    charge_speed: Level = Level.NORMAL

@dataclass(kw_only=True, frozen=True)
class Hazard(DataClassJsonMixin):
    attack_power: Level = Level.NORMAL
    hazard_duration: Level = Level.NORMAL
    hazard_size: Level = Level.NORMAL

@dataclass(kw_only=True, frozen=True)
class Enemy(DataClassJsonMixin):
    name: str
    image_path: str

    # STATS
    health: Level = Level.NORMAL
    power: Level = Level.NORMAL
    speed: Level = Level.NORMAL

    # SPECIALS
    projectile_attack: Optional[ProjectileAttack] = None
    area_attack: Optional[AreaAttack] = None
    charge_attack: Optional[ChargeAttack] = None
    hazard: Optional[Hazard] = None


if __name__ == "__main__":
    universe = Enemy(
        name="Universe",
        image_path="Hubble_ultra_deep_field.jpg",
        health=Level.HIGH,
        power=Level.HIGH,
        speed=Level.LOW,
        area_attack=AreaAttack(
            area_size=Level.HIGH,
            attack_delay=Level.HIGH,
            attack_power=Level.HIGH,
            attack_range=Level.HIGH,
            attack_speed=Level.LOW,
        ),
        projectile_attack=ProjectileAttack(
            attack_power=Level.NORMAL,
            attack_range=Level.HIGH,
            attack_speed=Level.HIGH,
            projectile_size=Level.LOW,
            projectile_speed=Level.HIGH,
        )
    )

    serialized = universe.to_json(indent=2)
    deserialized = Enemy.from_json(serialized)
    assert deserialized == universe

    with open("everything/enemies/universe.json", "w") as f:
        f.write(serialized)
