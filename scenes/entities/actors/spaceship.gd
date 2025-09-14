class_name Spaceship extends Node2D

const BULLET: Resource = preload("uid://whpdohlupewc")

@export var enemy: bool = true
@export var shots_anchor: Node2D

var shots_timer: Timer


func _ready() -> void:
	create_timer()


func shoot() -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.global_position = shots_anchor.global_position
	bullet.dir = Vector2(-1 if enemy else 1, 0)
	Util.shots_node.add_child(bullet)


func create_timer() -> void:
	shots_timer = Timer.new()
	shots_timer.autostart = true
	shots_timer.one_shot = false
	shots_timer.wait_time = Values.SHIP_SHOT_SPEED
	shots_timer.timeout.connect(shoot)
	add_child(shots_timer)
