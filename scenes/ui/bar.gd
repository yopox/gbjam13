@tool
extends Control


@onready var r1: ColorRect = $r1
@onready var r2: ColorRect = $r2

@export var width: int = 16:
	set(new_width):
		width = new_width
		if not is_node_ready(): await ready
		r1.size.x = new_width
		r2.size.x = new_width


func set_ratio(ratio: float) -> void:
	r2.size.x = ceil(ratio * width)
