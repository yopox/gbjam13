class_name MovCircle extends Movement

var x_speed
var h_dir: Vector2
var r: float
var offset: float
var speed: float


func _init(pos: Vector2, horizontal_speed: float, circle_r: float, circle_alpha: float, circle_speed: float) -> void:
	super(pos)
	x_speed = horizontal_speed
	h_dir = Vector2(-1, 0) * x_speed
	r = circle_r
	offset = circle_alpha
	speed = circle_speed


func get_pos(time: float) -> Vector2:
	return starting_pos + time * h_dir + Vector2.from_angle(offset + time * speed) * r


func with_starting_pos(pos: Vector2) -> Movement:
	return MovCircle.new(pos, x_speed, r, offset, speed)
