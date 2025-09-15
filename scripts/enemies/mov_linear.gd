class_name MovLinear extends Movement


var a: float
var dir: Vector2
var s: float


func _init(pos: Vector2, alpha: float, speed: float) -> void:
	super(pos)
	a = alpha
	dir = Vector2.from_angle(PI + a)
	s = speed


func get_pos(time: float) -> Vector2:
	return starting_pos + dir * time * s


func with_starting_pos(pos: Vector2) -> Movement:
	return MovLinear.new(pos, a, s)
