class_name WaveEvent extends RefCounted


var delay: float
var spawns: Array[Spawn]


func _init(t: float, enemies: Array[Spawn]) -> void:
	delay = t
	spawns = enemies
