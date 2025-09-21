extends Node2D

const STAR_TEXTURE = preload("uid://dkoyghpqr33rk")
const SPEED_RATIO: String = "speed"

var ratio: float = 1.0

func _ready() -> void:
	for i in range(Values.STAR_COUNT):
		spawn_star()
	Signals.starfield_speed.connect(set_starfield_speed)


func set_starfield_speed(r: float) -> void:
	ratio = r


func _process(delta: float) -> void:
	for star: Sprite2D in get_children():
		star.position.x -= delta * Values.STARFIELD_SPEED * ratio * star.get_meta(SPEED_RATIO)
		if star.position.x < 0:
			star.position.x = Values.SCREEN_W
			star.position.y = randi_range(0, Values.SCREEN_H)


func spawn_star() -> void:
	var star = Sprite2D.new()
	star.texture = STAR_TEXTURE
	star.position = Vector2(randi_range(0, Values.SCREEN_W), randi_range(0, Values.SCREEN_H))
	star.set_meta(SPEED_RATIO, [1.0, 2.0, 4.0].pick_random())
	add_child(star)
