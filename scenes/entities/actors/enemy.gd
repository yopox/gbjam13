class_name Enemy extends Spaceship


enum Types {
	E1, E2, E3
}

@onready var area: Area2D = $area

var type: Types
var movement: Movement
var chrono: float = 0.0


func _ready() -> void:
	super()
	# TODO: Stats depending on the type of enemy
	shots_timer.wait_time = Values.ENEMY_SHOT_SPEED


func _physics_process(delta: float) -> void:
	if Util.check_oob(global_position, Values.ENEMY_BUFFER):
		print("Queue free enemy")
		queue_free()
		return
	chrono += delta
	global_position = movement.get_pos(chrono)


func get_damage() -> int:
	return Values.ENEMY_DAMAGE
