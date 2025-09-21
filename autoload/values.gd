extends Node

# —————— UI ——————
const SCREEN_W: int = 160
const SCREEN_H: int = 144
const UI_Y: int = 130
const SPLASH_DURATION: float = 2.0
const TRANSITION_COLOR_DELAY: float = 0.15

# ————— SHIP —————
## Invisible wall for the ship
const SHIP_XMAX: int = 80
const SHIP_HULL: int = 20
const SHIP_DAMAGE: int = 6
const SHIP_SPEED: float = 45.0
const SHIP_SHOT_DELAY: float = 0.8
const SHOT_SPEED: float = 64.0
const SHIELD_LENGTH: float = 4.0
const SHIELD_RELOAD: float = 16.0
const MISSILE_RELOAD: float = 8.0
const MISSILE_DAMAGE_RATIO: float = 4.0
const MISSILE_DAMAGE_AREA: float = 32.0
const HEAL_AFTER_STAGE_RATIO: float = 0.25

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
const ENEMY_SHOT_DELAY_1: float = SHIP_SHOT_DELAY * 3.0
const ENEMY_SHOT_DELAY_2: float = SHIP_SHOT_DELAY * 2.5
const ENEMY_SHOT_DELAY_3: float = SHIP_SHOT_DELAY * 2.0
const ENEMY_BUFFER: float = 64

const BOSS_DAMAGE: int = ENEMY_DAMAGE_1
const BOSS_HP: int = 500
const BOSS_SHOT_DELAY: float = SHIP_SHOT_DELAY * 0.75
const BOSS_IDLE_WAIT: float = 5.0
const BOSS_SPEED: float = SHIP_SPEED * 2.0
const BOSS_DX: float = -42
const BOSS_TARGET_SHIP_MOVE_INTERVAL: float = 0.5
const BOSS_TARGET_SHIP_MOVES: int = 8
const BOSS_MOVING_MOVE_INTERVAL: float = 0.5
const BOSS_MOVING_MOVES: int = 8
const BOSS_MOVING_SHOT_DELAY: float = BOSS_SHOT_DELAY / 2.0
const BOSS_UNLUCKY_SHOT_DELAY: float = BOSS_SHOT_DELAY * 1.15
const BOSS_SIN_AMP: float = UI_Y / 3.0
const BOSS_SIN_FREQ: float = 2.0
const BOSS_IDLE_SPAWN_WAIT: float = 3.25
const BOSS_REINFORCEMENT_LINES: int = 8

# ———— SPACE —————
const WAVE_DELAY: float = 4.0
const POST_UNLUCKY_WAVE_DELAY: float = 4.0
const UNLUCKY_WAVE_DURATION: float = 15.0
const PRE_BOSS_DELAY: float = 5.0

# ———— POWERS ————
const S1_DAMAGE_PER_UNLUCK: float = 0.25
const S2_CANT_SHOOT_MS: float = 5000
const S3_ENEMY_DAMAGE_BOOST: int = 2
const S4_MISSILE_RADIUS_RATIO: float = 2.0
const S5_DAMAGE_UP: int = 1
const S6_DAMAGE_PER_HULL: float = 0.2
const S7_TRIPLE_SHOT_ANGLE: float = PI / 10
const S8_CHARGED_DAMAGE_UP: float = 1.5
const S9_AUTO_AIM_RADIUS: float = 48.0
const S9_AUTO_AIM_ANGLE_RATIO: float = 0.4

const C1_DOUBLE_SHOT_CHANCE_PER_UNLUCK: float = 0.1
const C1_DOUBLE_SHOT_DELAY: float = 0.2
const C2_SPEED_DOWN_RATIO: float = 0.6
const C3_ENEMY_SHOT_SPEED_RATIO: float = 1.5
const C4_SHORTER_INTERVALS_RATIO: float = 0.66
const C5_SPEED_UP: float = SHIP_SPEED / 2.0
const C6_UNLUCK_UP: int = 2

const H1_DODGE_CHANCE_PER_UNLUCK: float = 0.1
const H3_ENEMY_HEAL: int = 10
const H4_LONGER_SHIELDS_RATIO: float = 2.0
const H5_HULL_UP: int = 5
const H6_REGEN_EVERY_X_KILLS: int = 10
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
const D8_DIAGONAL_SHOT_ANGLE: float = PI / 5
