class_name Footer extends Control

@onready var hull_bar: Bar = $hull/bar
@onready var unlucky_bar: Bar = $unlucky/bar
@onready var shield_label: Label = $shield/label
@onready var shield_bar: Bar = $shield/bar
@onready var missile_label: Label = $missile/label
@onready var missile_bar: Bar = $missile/bar


func _on_ship_hit(spaceship: Spaceship) -> void:
	hull_bar.set_ratio(1.0 * spaceship.hp / spaceship.max_hp)


func set_unlucky_ratio(ratio: float) -> void:
	unlucky_bar.set_ratio(ratio)


func update_shield_ratio() -> void:
	if Progress.shield_ready:
		shield_bar.set_ratio(1.0)
	else:
		var timer = Progress.shield_timer
		if timer.is_stopped():
			shield_bar.loading = true
			timer = Progress.shield_reload
			var r = 1 - timer.time_left / timer.wait_time
			shield_bar.set_ratio(r)
		else:
			shield_bar.loading = false
			var r = timer.time_left / timer.wait_time
			shield_bar.set_ratio(r)
	if Progress.has(Power.ID.HEARTS_2) and Progress.unlucky:
		shield_label.modulate = Palettes.GRAY[1]


func update_missile_ratio() -> void:
	if Progress.missile_ready:
		missile_bar.set_ratio(1.0)
	else:
		var timer = Progress.missile_reload
		var r = 1 - timer.time_left / timer.wait_time
		missile_bar.set_ratio(r)
