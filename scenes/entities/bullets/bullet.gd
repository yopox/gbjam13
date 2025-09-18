class_name Bullet extends Node2D

@onready var area: Area2D = $area

var dir: Vector2 = Vector2.ZERO
var lifetime: float = 0.0
var enemy: bool = false
var damage: int = 0


func _ready():
	if damage == 0:
		Log.err("Bullet damage still at 0.")
	area.collision_layer = 8 if enemy else 2
	area.collision_mask = 1 if enemy else 4


func _physics_process(delta: float) -> void:
	if Util.check_oob(position, Values.BULLET_BUFFER):
		queue_free()
		return
	lifetime += delta
	move(delta)


func move(delta: float) -> void:
	var speed: float = Values.SHOT_SPEED
	if not enemy:
		speed += Progress.shot_speed_boost
		if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
			speed += Values.D4_SHOT_SPEED_UP
	elif Progress.has(Power.ID.DIAMS_7) and Progress.unlucky:
		speed *= Values.D7_ENEMY_SHOT_SPEED_RATIO
	position += delta * speed * dir * (2 - min(lifetime, 1))
