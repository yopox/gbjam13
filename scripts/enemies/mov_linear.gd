class_name MovLinear extends Movement


var a: float
var dir: Vector2


func _init(pos: Vector2, alpha: float) -> void:
	super(pos)
	a = alpha
	dir = Vector2.from_angle(PI + a)


func get_pos(time: float, speed: float) -> Vector2:
	return starting_pos + dir * time * speed


func with_starting_pos(pos: Vector2) -> Movement:
	return MovLinear.new(pos, a)
