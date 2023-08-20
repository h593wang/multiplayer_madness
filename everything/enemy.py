from dataclasses import dataclass
from enum import Enum
from typing import Optional

from dataclasses_json import DataClassJsonMixin

class Level(Enum):
    NORMAL = "NORMAL"
    LOW = "LOW"
    HIGH = "HIGH"

    @classmethod
    def from_prompt(cls, prompt: str) -> "Level":
        selection = input(f"{prompt} [l/N/h]: ").lower().strip()
        return {
            "": Level.NORMAL,
            "l": Level.LOW,
            "n": Level.NORMAL,
            "h": Level.HIGH,
        }[selection]


@dataclass(kw_only=True, frozen=True)
class ProjectileAttack(DataClassJsonMixin):
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL
    projectile_size: Level = Level.NORMAL
    projectile_speed: Level = Level.NORMAL

    @classmethod
    def from_prompts(cls, prefix: str = "") -> "ProjectileAttack":
        prefix = f"{prefix}Projectile Attack > "
        return cls(
            attack_power=Level.from_prompt(f"{prefix}Attack Power"),
            attack_range=Level.from_prompt(f"{prefix}Attack Range"),
            attack_speed=Level.from_prompt(f"{prefix}Attack Speed"),
            projectile_size=Level.from_prompt(f"{prefix}Projectile Size"),
            projectile_speed=Level.from_prompt(f"{prefix}Projectile Speed"),
        )


@dataclass(kw_only=True, frozen=True)
class AreaAttack(DataClassJsonMixin):
    area_size: Level = Level.NORMAL
    attack_delay: Level = Level.NORMAL
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL

    @classmethod
    def from_prompts(cls, prefix: str = "") -> "AreaAttack":
        prefix = f"{prefix}Area Attack > "
        return cls(
            area_size=Level.from_prompt(f"{prefix}Area Size"),
            attack_delay=Level.from_prompt(f"{prefix}Attack Delay"),
            attack_power=Level.from_prompt(f"{prefix}Attack Power"),
            attack_range=Level.from_prompt(f"{prefix}Attack Range"),
            attack_speed=Level.from_prompt(f"{prefix}Attack Speed"),
        )


@dataclass(kw_only=True, frozen=True)
class ChargeAttack(DataClassJsonMixin):
    attack_delay: Level = Level.NORMAL
    attack_power: Level = Level.NORMAL
    attack_range: Level = Level.NORMAL
    attack_speed: Level = Level.NORMAL
    charge_speed: Level = Level.NORMAL

    @classmethod
    def from_prompts(cls, prefix: str = "") -> "ChargeAttack":
        prefix = f"{prefix}Charge Attack > "
        return cls(
            attack_delay=Level.from_prompt(f"{prefix}Attack Delay"),
            attack_power=Level.from_prompt(f"{prefix}Attack Power"),
            attack_range=Level.from_prompt(f"{prefix}Attack Range"),
            attack_speed=Level.from_prompt(f"{prefix}Attack Speed"),
            charge_speed=Level.from_prompt(f"{prefix}Charge Speed"),
        )


@dataclass(kw_only=True, frozen=True)
class Hazard(DataClassJsonMixin):
    attack_power: Level = Level.NORMAL
    hazard_duration: Level = Level.NORMAL
    hazard_size: Level = Level.NORMAL

    @classmethod
    def from_prompts(cls, prefix: str = "") -> "Hazard":
        prefix = f"{prefix}Hazard > "
        return cls(
            attack_power=Level.from_prompt(f"{prefix}Attack Power"),
            hazard_duration=Level.from_prompt(f"{prefix}Hazard Duration"),
            hazard_size=Level.from_prompt(f"{prefix}Hazard Size"),
        )


@dataclass(kw_only=True, frozen=True)
class Enemy(DataClassJsonMixin):
    name: str
    entity_id: Optional[str] = None
    image_path: str
    image_width: int
    image_height: int

    # STATS
    health: Level = Level.NORMAL
    power: Optional[Level] = Level.NORMAL
    speed: Level = Level.NORMAL

    # SPECIALS
    projectile_attack: Optional[ProjectileAttack] = None
    area_attack: Optional[AreaAttack] = None
    charge_attack: Optional[ChargeAttack] = None
    hazard: Optional[Hazard] = None


if __name__ == "__main__":
    universe = Enemy(
        name="Universe",
        entity_id="Q1",
        image_path="Hubble_ultra_deep_field.jpg",
        image_height=240,
        image_width=240,
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

    with open("everything/universe.json", "w") as f:
        f.write(serialized)
