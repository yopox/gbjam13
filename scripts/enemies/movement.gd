## Controls enemy movements. Instances of Movement should be stateless.
@abstract class_name Movement extends RefCounted

var rtl: bool = true
var starting_pos: Vector2


func _init(pos: Vector2) -> void:
	starting_pos = pos


@abstract func get_pos(time: float, x_speed: float) -> Vector2

## Returns a new movement with the given starting position
@abstract func with_starting_pos(pos: Vector2) -> Movement
