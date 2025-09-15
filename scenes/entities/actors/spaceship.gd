@abstract class_name Spaceship extends Node2D

const BULLET: Resource = preload("uid://whpdohlupewc")

@export var enemy: bool = true
@export var hitbox: Area2D
@export var blinker: Blinker
@export var shots_anchor: Node2D
@export var max_hp: int = 10

var hp: int
var shots_timer: Timer
var hit_invul: bool = false


func _ready() -> void:
	create_timer()
	hp = max_hp
	hitbox.area_entered.connect(hit)


@abstract func get_damage() -> int


func shoot() -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.enemy = enemy
	bullet.damage = get_damage()
	bullet.global_position = shots_anchor.global_position
	bullet.dir = Vector2(-1 if enemy else 1, 0)
	Util.shots_node.add_child(bullet)


func hit(area: Area2D) -> void:
	if hit_invul: return
	# animation
	blinker.hit()
	if area.get_parent() is Bullet:
		# TODO: bullet damage
		area.get_parent().queue_free()
	elif area.get_parent() is Spaceship:
		# TODO: contact damage
		pass

func create_timer() -> void:
	shots_timer = Timer.new()
	shots_timer.autostart = true
	shots_timer.one_shot = false
	shots_timer.wait_time = Values.SHIP_SHOT_SPEED
	shots_timer.timeout.connect(shoot)
	add_child(shots_timer)
