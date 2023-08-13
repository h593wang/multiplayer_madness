# Everything

In this game, you fight literally _everything_.
To generate _everything_ to fight, we will need a massive pool of enemy types.
Still, for the bit to be effective, the enemies should be immediately recognizable by most players; we can't actually use _everything_.
We obtain 1000 of the most significant WikiData objects from the [List of articles every Wikipedia should have](https://meta.wikimedia.org/wiki/List_of_articles_every_Wikipedia_should_have).
The list in `pagepile_json_34426.json` can be downloaded from [Pagepile](https://pagepile.toolforge.org/api.php?id=34426&action=get_data&doit&format=json).

## Enemy Parameterization

An enemy combines some set of stats (health, speed, etc.) with some set of special characteristics (attacks, death effects, etc.).
To create enemies we will need to come up with some stats and a classication of the set of special characteristics.

### Stats

In [Vampire Survivors](https://vampire-survivors.fandom.com/wiki/Enemies#Stats), the stats are

- **Health**: maximum health
- **Power**: premitigation damage to player
- **Speed**: movement speed
- **Knockback**: proportional to distance knocked back when hit by player
- **XP**: experience dropped on death

To keep things easy, we will only directly control **Health**, **Power**, and **Speed**, setting each at one of three levels (low, normal, high).
**XP** will be proportional to how hard the enemy is to deal with.

Knockback, freeze resistance, etc. can be added later, time permitting.

### Special Characteristics

Special characteristics make enemies stronger.
There aren't actually any interesting special characteristics in Vampire Survivor, but we can instead turn to [Survivor.io's bosses](https://youtu.be/Pcp9CZLmiqg) for inspiration.

- **Ranged Attack**: launches a single straight-line projectile at the player

  - Attack Speed
  - Projectile Speed
  - Projectile Size
  - Projectile Power

- **AOE Attack**: calls an attack on a circular area

  - Attack Speed
  - Range
  - Radius
  - Power

- **Death Hazard**: upon death, an hazard is left that deals damage when the player is inside it.

  - Hazard Size
  - Hazard Power
  - Hazard Duration

- **Charge**: when within a certain radius of the player, the enemy pauses momentarily then moves at high speed for a fixed distance in a straight line toward the player
  - Charge Cooldown
  - Charge Speed
  - Range

### Bosses

The boss version of an enemy will be a bigger and amplified version with increased size and stats.
The special characteristics will also be amplified:

- **Ranged Attack**: launches multiple straight-line projectiles in the player's direction, with increased size or something
- **AOE Attack**: launches multiple attacks on circular areas, with increased size or something
- **Death Hazard**: leaves a hazardous trail
- **Charge**: enormous range
