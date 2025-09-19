class_name Footer extends Control

@onready var hull_bar: Bar = $hull/bar
@onready var unlucky_bar: Bar = $unlucky/bar


func _on_ship_hit(spaceship: Spaceship) -> void:
	hull_bar.set_ratio(1.0 * spaceship.hp / spaceship.max_hp)


func set_unlucky_ratio(ratio: float) -> void:
	unlucky_bar.set_ratio(ratio)
