@abstract class_name Spaceship extends Node2D

signal hit(spaceship: Spaceship)

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
	blinker.blink_over.connect(blink_over)
	hp = max_hp
	hitbox.area_entered.connect(do_hit)


@abstract func get_damage() -> int


func shoot() -> void:
	if hp == 0: return
	var bullet: Bullet = BULLET.instantiate()
	bullet.enemy = enemy
	bullet.damage = get_damage()
	bullet.global_position = shots_anchor.global_position
	bullet.dir = Vector2(-1 if enemy else 1, 0)
	Util.shots_node.add_child(bullet)


func do_hit(area: Area2D) -> void:
	if hit_invul: return
	
	# damage
	var parent = area.get_parent()
	if parent is Bullet:
		damage(parent.damage)
		parent.queue_free()
	elif parent is Spaceship:
		damage(parent.get_damage())
		parent.damage(get_damage())


func damage(value: int) -> void:
	if hit_invul: return
	hit_invul = true
	hp = max(0, hp - value)
	#Log.info("Spaceship hit, damage:", value, "HP:", hp)
	# animations
	blinker.hit()
	# TODO: death animation
	hit.emit(self)


func blink_over() -> void:
	hit_invul = false
	if hp == 0: queue_free()


func create_timer() -> void:
	shots_timer = Timer.new()
	shots_timer.autostart = true
	shots_timer.one_shot = false
	shots_timer.wait_time = Values.SHIP_SHOT_DELAY
	shots_timer.timeout.connect(shoot)
	add_child(shots_timer)
