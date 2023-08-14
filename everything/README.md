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

#### Projectile Attack

When within `[Attack Range]` of the player, the enemy launches a straight-line projectile of size `[Projectile Size]` at a speed of `[Projectile Speed]` toward the player's current direction, dealing `[Attack Power]` damage if it hits the player. Cooldown is decreased by `[Attack Speed]`.

#### Area Attack

When within `[Attack Range]` of the player, the enemy charges for `[Attack Delay]`, then performs an area attack of radius `[Area Size]` on the player's location when the attack began charging, dealing `[Attack Power]` damage if it hits the player. Cooldown is decreased by `[Attack Speed]`.

#### Charge Attack

When within `[Attack Range]` of the player, the enemy pauses for `[Attack Delay]`, then moves at `[Charge Speed]` for a distance proportional to `[Attack Range]` in a straight line toward the player, dealing `[Attack Power]` damage if it hits the player. Cooldown is decreased by `[Attack Speed]`.

#### Hazard

Upon death, the enemy leaves a hazardous area of radius `[Hazard Size]` at its current position lasting for `[Hazard Duration]`, dealing `[Attack Power]` damage repeatedly when the player is in the area.

### Bosses

The boss version of an enemy will be a bigger and amplified version with increased size and stats.
The special characteristics will also be amplified:

- **Ranged Attack**: launches a spread of multiple projectiles at the same time or in quick succession.
- **Area Attack**: launches multiple attacks at once or in quick succession.
- **Charge Attack**: already made difficult by the boss' increased size, the attack also gains enormous range and speed.
- **Hazard**: continuously leaves a hazardous trail wherever the boss goes.
