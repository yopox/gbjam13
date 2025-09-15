extends Control

@onready var hull_bar: Bar = $hull/bar


func _on_ship_hit(spaceship: Spaceship) -> void:
	hull_bar.set_ratio(1.0 * spaceship.hp / spaceship.max_hp)
