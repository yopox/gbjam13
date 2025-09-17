class_name MovSine extends Movement


var y_amp: float
var y_f: float
var y_offset: float = 0.0


func _init(pos: Vector2, y_p: Vector3) -> void:
	super(pos)
	y_amp = y_p.x
	y_f = y_p.y
	y_offset = y_p.z


func get_pos(time: float, x_speed: float) -> Vector2:
	var move: Vector2 = Vector2(-time * x_speed, sin(time * y_f + y_offset) * y_amp)
	return starting_pos + move


func with_starting_pos(pos: Vector2) -> Movement:
	return MovSine.new(pos, Vector3(y_amp, y_f, y_offset))
