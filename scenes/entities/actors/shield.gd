class_name Shield extends Node2D

@onready var sprite: Sprite2D = $sprite
@onready var area: Area2D = $area

@onready var blinker: Blinker = $blinker
@onready var timer: Timer = $timer
@onready var reload: Timer = $reload

@export var enemy: bool = false


func enable() -> void:
	Progress.shield_ready = false
	timer.wait_time = Values.SHIELD_LENGTH
	if not enemy and Progress.has(Power.ID.HEARTS_4):
		timer.wait_time *= Values.H4_LONGER_SHIELDS_RATIO
	timer.start()
	sprite.visible = true
	area.monitoring = true
	Log.info("Shield enabled")
	Progress.shield_usages += 1
	await timer.timeout
	disable()


func disable() -> void:
	blinker.hit()
	await blinker.blink_over
	sprite.visible = false
	area.monitoring = false
	if Progress.shield_ready: return # HEARTS_7
	reload.wait_time = Values.SHIELD_RELOAD
	if Progress.has(Power.ID.DIAMS_1):
		reload.wait_time *= Values.D1_RELOAD_FASTER_PER_UNLUCK_RATIO ** Progress.get_bad_luck()
	reload.start()
	await reload.timeout
	Progress.shield_ready = true
	


func _on_area_area_entered(a: Area2D) -> void:
	var parent = a.get_parent()
	if parent is Bullet and parent.enemy != enemy:
		if not enemy and Progress.has(Power.ID.HEARTS_9):
			(parent as Bullet).enemy = !parent.enemy
			(parent as Bullet).dir = Vector2.from_angle(PI - (parent as Bullet).dir.angle())
			(parent as Bullet).damage *= Values.H9_DEFLECTED_SHOT_DAMAGE_RATIO
			(parent as Bullet).area.collision_layer = 2
			(parent as Bullet).area.collision_mask = 4
		else:
			parent.queue_free()
