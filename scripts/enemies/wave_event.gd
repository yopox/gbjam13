class_name WaveEvent extends RefCounted


var delay: float
var spawns: Array
var unlucky: bool = false


func _init(t: float, enemies: Array) -> void:
	delay = t
	spawns = enemies
