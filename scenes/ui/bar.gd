class_name Bar extends Control


@onready var r1: ColorRect = $r1
@onready var r2: ColorRect = $r2

@export var loading: bool
@export var label: Label
@export var icon: Sprite2D = null
@export var ratio: float = 0.0
@export var width: int = 16


func _ready() -> void:
	r1.size.x = width
	r2.size.x = width
	set_ratio(ratio)


func set_ratio(r: float) -> void:
	ratio = r
	if ratio * width < 1.0:
		r2.size.x = 0
	else:
		r2.size.x = ceil(ratio * width)
	update_label()


func update_label() -> void:
	var color: Color
	if not loading:
		color = Palettes.GRAY[1] if ratio < 0.001 else Palettes.GRAY[3]
	else:
		color = Palettes.GRAY[3] if ratio > 0.999 else Palettes.GRAY[1]
	label.modulate = color
	if icon != null: icon.modulate = color
