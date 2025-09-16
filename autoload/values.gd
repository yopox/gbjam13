extends Node

# —————— UI ——————
const SCREEN_W: int = 160
const SCREEN_H: int = 144
const UI_Y: int = 130

# ————— SHIP —————
## Invisible wall for the ship
const SHIP_XMAX: int = 80
const SHIP_DAMAGE: int = 6
const SHIP_SPEED: float = 45.0
const SHIP_SHOT_DELAY: float = 0.5
const SHOT_SPEED: float = 64.0

# ———— ENEMIES ———
## Margin around the screen before the bullet is freed
const BULLET_BUFFER: int = 12
const SPAWN_Y_MID: float = UI_Y / 2.0
const ENEMY_DAMAGE: int = 2
const ENEMY_SPEED: float = SHIP_SPEED * 0.35
const ENEMY_SHOT_DELAY: float = SHIP_SHOT_DELAY * 2.0
const ENEMY_BUFFER: float = 64
