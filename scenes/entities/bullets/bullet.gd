class_name Bullet extends Node2D

@onready var area: Area2D = $area

var dir: Vector2 = Vector2.ZERO
var lifetime: float = 0.0
var enemy: bool = false


func _ready():
	area.collision_layer = 8 if enemy else 2
	area.collision_mask = 1 if enemy else 4


func _physics_process(delta: float) -> void:
	if Util.check_oob(position, Values.BULLET_BUFFER): 
		queue_free()
		return
	lifetime += delta
	move(delta)


func move(delta: float) -> void:
	position += delta * Values.SHOT_SPEED * dir * (2 - min(lifetime, 1))
