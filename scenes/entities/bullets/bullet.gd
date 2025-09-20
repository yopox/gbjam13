class_name Bullet extends Node2D

@onready var sprite: Sprite2D = $sprite
@onready var area: Area2D = $area
@onready var shape: CollisionShape2D = $area/shape


var dir: Vector2 = Vector2.ZERO
var damage: int = 0
var enemy: bool = false
var missile: bool = false
var boom: bool = false

var lifetime: float = 0.0
var warped: bool = false


func _ready():
	if damage == 0:
		Log.err("Bullet damage still at 0.")
	area.collision_layer = 8 if enemy else 2
	area.collision_mask = 1 if enemy else 4
	if not enemy and Progress.has(Power.ID.DIAMS_2) and Progress.unlucky:
		dir = Vector2(2, randf_range(-1, 1)).normalized()
	if enemy:
		sprite.modulate = Palettes.GRAY[2]


func _physics_process(delta: float) -> void:
	if not enemy and Progress.has(Power.ID.DIAMS_9):
		if Util.check_oob(position, 0):
			if warped:
				queue_free()
			else:
				position = Vector2(fposmod(position.x, Values.SCREEN_W), fposmod(position.y, Values.UI_Y))
				warped = true
	elif Util.check_oob(position, Values.BULLET_BUFFER):
		queue_free()
		return
	lifetime += delta
	move(delta)


func move(delta: float) -> void:
	var speed: float = Values.SHOT_SPEED
	if not enemy:
		speed += Progress.shot_speed_boost
		if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
			speed += Values.D4_SHOT_SPEED_UP
		if Progress.has(Power.ID.DIAMS_3) and Progress.unlucky:
			speed *= Values.D3_SLOWER_SHOT_RATIO
	else:
		if Progress.has(Power.ID.DIAMS_7) and Progress.unlucky:
			speed *= Values.D7_ENEMY_SHOT_SPEED_RATIO
		if Progress.has(Power.ID.CLUBS_3) and Progress.unlucky:
			speed *= Values.C3_ENEMY_SHOT_SPEED_RATIO
	
	var d = dir
	if missile and not enemy and Progress.has(Power.ID.SPADES_9):
		var e = Util.enemy_node.get_children()
		e = e.filter(func(n: Node): return n is Node2D and n.global_position.x > global_position.x)
		if e.size() > 0:
			var ed = e.map(func(n: Node2D): return [n.position.distance_to(position), n])
			ed.sort_custom(func(i, j): return i[0] < j[0])
			var seg: Vector2 = ed[0][1].global_position - global_position
			if seg.length() <= Values.S9_AUTO_AIM_RADIUS:
				var r = Values.S9_AUTO_AIM_ANGLE_RATIO
				d = Vector2.from_angle(dir.angle() * (1 - r) + seg.angle() * r)
	
	position += delta * speed * d * (2 - min(lifetime, 1))


func set_missile() -> void:
	missile = true
	await ready
	(sprite.texture as AtlasTexture).region.position.x = 24
	(shape.shape as RectangleShape2D).size = Vector2(4, 4)
