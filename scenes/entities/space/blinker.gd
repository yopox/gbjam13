class_name Blinker extends Node2D

@onready var particles: CPUParticles2D = $particles

signal blink_over()

@export var sprite: Sprite2D
@export var intervals: int = 2
@export var blink_step: float = 0.35
@export var flip_frame: bool = false

var is_blinking: bool = false
var disappear: bool = false


func hit() -> void:
	is_blinking = true
	set_state(true)
	for i in range(2 * intervals - 1):
		set_state(i % 2 != 0)
		await Util.wait(blink_step)
	if not disappear: set_state(true)
	blink_over.emit()
	is_blinking = false


func set_state(normal: bool) -> void:
	if flip_frame:
		sprite.frame = 0 if normal else 1
	else:
		sprite.visible = normal
