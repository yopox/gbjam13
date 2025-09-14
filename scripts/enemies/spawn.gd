class_name Spawn extends RefCounted


var delay: float
var enemy: Enemy.Types
var movement: Movement


func _init(t: float, e_type: Enemy.Types, mov: Movement) -> void:
	delay = t
	enemy = e_type
	movement = mov
