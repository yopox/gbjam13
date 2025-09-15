class_name Blinker extends Node2D

@onready var particles: CPUParticles2D = $particles

signal blink_over()

@export var sprite: Sprite2D
@export var intervals: int = 2
@export var blink_step: float = 0.35


func hit() -> void:
	sprite.visible = true
	for i in range(2 * intervals - 1):
		sprite.visible = !sprite.visible
		await Util.wait(blink_step)
	sprite.visible = true
	# TODO: emit particles
	blink_over.emit()
