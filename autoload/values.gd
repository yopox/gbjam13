extends Node

# —————— UI ——————
const SCREEN_W: int = 160
const SCREEN_H: int = 144
const UI_Y: int = 130

# ————— SHIP —————
## Invisible wall for the ship
const SHIP_XMAX: int = 80
const SHIP_HULL: int = 20
const SHIP_DAMAGE: int = 6
const SHIP_SPEED: float = 45.0
const SHIP_SHOT_DELAY: float = 0.8
const SHOT_SPEED: float = 64.0

# ———— ENEMIES ———
## Margin around the screen before the bullet is freed
const BULLET_BUFFER: int = 12
const SPAWN_Y_MID: float = UI_Y / 2.0
const ENEMY_DAMAGE_1: int = 2
const ENEMY_DAMAGE_2: int = 3
const ENEMY_DAMAGE_3: int = 4
const ENEMY_SPEED_1: float = SHIP_SPEED * 0.45
const ENEMY_SPEED_2: float = SHIP_SPEED * 0.5
const ENEMY_SPEED_3: float = SHIP_SPEED * 0.55
const ENEMY_SHOT_DELAY_1: float = SHIP_SHOT_DELAY * 2.25
const ENEMY_SHOT_DELAY_2: float = SHIP_SHOT_DELAY * 2.0
const ENEMY_SHOT_DELAY_3: float = SHIP_SHOT_DELAY * 1.5
const ENEMY_BUFFER: float = 64

# ———— POWERS ————
const S1_DAMAGE_PER_UNLUCK: float = 0.25
const S3_ENEMY_DAMAGE: int = 1
const S4_MISSILE_RADIUS: float = 48
const S5_DAMAGE_UP: int = 1
const S6_DAMAGE_PER_HULL: float = 0.2
const S7_TRIPLE_SHOT_ANGLE: float = PI / 7
const S8_CHARGED_DAMAGE_UP: float = 1.5
const S9_AUTO_AIM_RANGE: float = 32

const C1_DOUBLE_SHOT_CHANCE_PER_UNLUCK: float = 0.1
const C1_DOUBLE_SHOT_DELAY: float = 0.2
const C2_ELITE_RATE_UP: float = 0.15
const C3_ENEMY_SHOT_SPEED_UP: float = SHOT_SPEED / 2.0
const C4_SHORTER_INTERVALS_RATIO: float = 0.66
const C5_SPEED_UP: float = SHIP_SPEED / 2.0
const C6_UNLUCK_UP: int = 2

const H1_DODGE_CHANCE_PER_UNLUCK: float = 0.1
const H3_ENEMY_HEAL: int = 10
const H4_LONGER_SHIELDS_RATIO: float = 2.0
const H5_HULL_UP: int = 5
const H6_REGEN_EVERY_X_KILLS: int = 12
const H6_REGEN: int = 1
const H8_REVIVE_REPAIR_RATIO: float = 0.5

const D1_RELOAD_FASTER_PER_UNLUCK_RATIO: float = 0.95
const D2_SHOT_SPREAD_ABS: float = PI / 3
const D3_SLOWER_SHOT_RATIO: float = 0.45
const D4_SHOT_SPEED_UP: float = SHIP_SPEED / 2.0
const D5_SHOT_DELAY_DOWN_RATIO: float = 0.75
const D6_SHOT_DELAY_DOWN_EVERY_X_KILLS: int = 6
const D6_SHOT_DELAY_DOWN_RATIO: float = 0.85
const D7_ENEMY_SHOT_SPEED_RATIO: float = 0.4
const D8_DIAGONAL_SHOT_ANGLE: float = PI / 4
