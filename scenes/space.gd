extends Node2D

@onready var shots: Node2D = $shots


func _ready() -> void:
	Util.shots_node = shots
