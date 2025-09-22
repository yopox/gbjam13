class_name Enemy extends Spaceship


enum Types {
	E1, E2, E3, E4, E5, E6
}

enum ShotType {
	REGULAR, DOUBLE, SINGLE_REPEAT, TARGET_PLAYER
}

static var T1: Array[Types] = [Types.E1, Types.E2]
static var T2: Array[Types] = [Types.E3, Types.E4]
static var T3: Array[Types] = [Types.E5, Types.E6]

@onready var sprite: Sprite2D = $sprite
@onready var area: Area2D = $area

var type: Types
var movement: Movement
var chrono: float = 0.0
var speed: float = Values.ENEMY_SPEED_1
var id: int = -1


func _ready() -> void:
	max_hp = get_max_hp()
	super()
	(sprite.texture as AtlasTexture).region.position.x = 32 * type
	speed = get_speed()
	shots_timer.wait_time = get_shot_delay()


func _physics_process(delta: float) -> void:
	if Util.hit_stop: return
	if hp > 0 and (global_position.x < -Values.ENEMY_BUFFER / 2.0\
		or global_position.y < -2 * Values.ENEMY_BUFFER or global_position.y > Values.UI_Y + 2 * Values.ENEMY_BUFFER):
		Signals.enemy_escaped.emit()
		queue_free()
		return
	chrono += delta
	global_position = movement.get_pos(chrono, speed)
	shots_timer.wait_time = get_shot_delay()


func heal(amount: int) -> void:
	if hp == 0: return
	hp = min(max_hp, hp + amount)


func get_max_hp() -> int:
	if type in T2: return Values.ENEMY_HP_2
	if type in T3: return Values.ENEMY_HP_3
	return Values.ENEMY_HP_1


func get_speed() -> float:
	if type in T2: return Values.ENEMY_SPEED_2
	if type in T3: return Values.ENEMY_SPEED_3
	return Values.ENEMY_SPEED_1


func get_damage() -> int:
	var boost: int = 0
	if Progress.has(Power.ID.SPADES_3) and Progress.unlucky:
		boost += Values.S3_ENEMY_DAMAGE_BOOST
	if type in T2: return Values.ENEMY_DAMAGE_2 + boost
	if type in T3: return Values.ENEMY_DAMAGE_3 + boost
	return Values.ENEMY_DAMAGE_1 + boost


func get_shot_delay() -> float:
	if type in T2: return Values.ENEMY_SHOT_DELAY_2
	if type in T3: return Values.ENEMY_SHOT_DELAY_3
	return Values.ENEMY_SHOT_DELAY_1


func get_shot_type() -> ShotType:
	match type:
		Types.E1, Types.E5: return ShotType.DOUBLE
		Types.E3: return ShotType.SINGLE_REPEAT
		Types.E4, Types.E6: return ShotType.TARGET_PLAYER
		_: return ShotType.REGULAR
