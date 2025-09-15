class_name MovSine extends Movement


var x_s: float
var y_amp: float
var y_f: float
var y_offset: float = 0.0


func _init(pos: Vector2, x_speed: float, y_p: Vector3) -> void:
	super(pos)
	x_s = x_speed
	y_amp = y_p.x
	y_f = y_p.y
	y_offset = y_p.z


func get_pos(time: float) -> Vector2:
	var move: Vector2 = Vector2(-time * x_s, sin(time * y_f + y_offset) * y_amp)
	return starting_pos + move
