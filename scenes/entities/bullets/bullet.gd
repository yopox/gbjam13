class_name Bullet extends Node2D


var dir: Vector2 = Vector2.ZERO
var lifetime: float = 0.0


func _physics_process(delta: float) -> void:
	if Util.check_oob(position, Values.BULLET_BUFFER): 
		queue_free()
		return
	lifetime += delta
	move(delta)


func move(delta: float) -> void:
	position += delta * Values.SHOT_SPEED * dir * (2 - min(lifetime, 1))
