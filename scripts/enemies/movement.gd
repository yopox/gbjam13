@abstract class_name Movement extends RefCounted

var chrono: float = 0.0
var rtl: bool = true
var starting_pos: Vector2


func _init(pos: Vector2) -> void:
	starting_pos = pos


@abstract func get_pos() -> Vector2
