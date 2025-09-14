class_name Bullet extends Node2D


var dir: Vector2 = Vector2.ZERO
var lifetime: float = 0.0


func _physics_process(delta: float) -> void:
	if check_oob(): return
	lifetime += delta
	move(delta)


func move(delta: float) -> void:
	position += delta * Values.SHOT_SPEED * dir * (2 - min(lifetime, 1))


func check_oob() -> bool:
	if position.x > Values.SCREEN_W + Values.BULLET_BUFFER:
		queue_free()
		return true
	elif position.x < Values.BULLET_BUFFER:
		queue_free()
		return true
	elif position.y < Values.BULLET_BUFFER:
		queue_free()
		return true
	elif position.y > Values.UI_Y + Values.BULLET_BUFFER:
		queue_free()
		return true
	return false
