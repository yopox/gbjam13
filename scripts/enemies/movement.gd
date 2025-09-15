## Controls enemy movements. Instances of Movement should be stateless.
@abstract class_name Movement extends RefCounted

var rtl: bool = true
var starting_pos: Vector2


func _init(pos: Vector2) -> void:
	starting_pos = pos


@abstract func get_pos(time: float) -> Vector2
