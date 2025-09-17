class_name MovCircle extends Movement

var r: float
var offset: float
var speed: float


func _init(pos: Vector2, circle_r: float, circle_alpha: float, circle_speed: float) -> void:
	super(pos)
	r = circle_r
	offset = circle_alpha
	speed = circle_speed


func get_pos(time: float, x_speed: float) -> Vector2:
	return starting_pos + time * x_speed * Vector2(-1, 0) + Vector2.from_angle(offset + time * speed) * r


func with_starting_pos(pos: Vector2) -> Movement:
	return MovCircle.new(pos, r, offset, speed)
