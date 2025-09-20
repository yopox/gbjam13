class_name Enemy extends Spaceship


enum Types {
	E1, E2, E3, E4, E5, E6, E7, E8, E9
}

static var T1: Array[Types] = [Types.E1, Types.E2, Types.E3]
static var T2: Array[Types] = [Types.E4, Types.E5, Types.E6]
static var T3: Array[Types] = [Types.E7, Types.E8, Types.E9]

@onready var sprite: Sprite2D = $sprite
@onready var area: Area2D = $area

var type: Types
var movement: Movement
var chrono: float = 0.0
var speed: float = Values.ENEMY_SPEED_1


func _ready() -> void:
	super()
	(sprite.texture as AtlasTexture).region.position.x = 32 * type
	speed = get_speed()
	shots_timer.wait_time = get_shot_delay()


func _physics_process(delta: float) -> void:
	if Util.check_oob(global_position, Values.ENEMY_BUFFER):
		queue_free()
		Signals.enemy_escaped.emit()
		return
	chrono += delta
	global_position = movement.get_pos(chrono, speed)
	shots_timer.wait_time = get_shot_delay()


func heal(amount: int) -> void:
	if hp == 0: return
	hp = min(max_hp, hp + amount)


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
