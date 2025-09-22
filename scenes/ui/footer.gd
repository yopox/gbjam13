class_name Footer extends Control

@onready var hull_bar: Bar = $hull/bar
@onready var unlucky_bar: Bar = $unlucky/bar
@onready var shield_label: Label = $shield/label
@onready var shield_bar: Bar = $shield/bar
@onready var missile_label: Label = $missile/label
@onready var missile_bar: Bar = $missile/bar
@onready var ankh: Node2D = $ankh
@onready var boss_bar: Bar = $boss/bar
@onready var notification: Control = $notification
@onready var notification_text: Label = $notification/text


func _ready() -> void:
	ankh.visible = Progress.ankh
	notification.visible = false
	Signals.consume_ankh.connect(consume_ankh)
	Signals.boss_spawned.connect(boss_spawned)
	Signals.send_notification.connect(show_notification)


func _on_ship_hp_changed(spaceship: Spaceship) -> void:
	hull_bar.set_ratio(1.0 * spaceship.hp / spaceship.max_hp)


func boss_spawned(boss: Boss) -> void:
	boss_bar.set_ratio(1.0)
	boss.hp_changed.connect(_on_boss_hp_changed)


func _on_boss_hp_changed(spaceship: Spaceship) -> void:
	boss_bar.set_ratio(1.0 * spaceship.hp / spaceship.max_hp)


func consume_ankh() -> void:
	ankh.visible = false


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
			if timer.is_stopped():
				r = 0
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


func show_notification(text: String) -> void:
	notification_text.text = text
	notification_text.modulate = Palettes.GRAY[1]
	notification.visible = true
	await Util.wait(Values.TRANSITION_COLOR_DELAY / 2)
	notification_text.modulate = Palettes.GRAY[2]
	await Util.wait(Values.TRANSITION_COLOR_DELAY / 2)
	notification_text.modulate = Palettes.GRAY[3]
	await Util.wait(Values.NOTIFICATION_DURATION)
	notification_text.modulate = Palettes.GRAY[2]
	await Util.wait(Values.TRANSITION_COLOR_DELAY / 2)
	notification_text.modulate = Palettes.GRAY[1]
	await Util.wait(Values.TRANSITION_COLOR_DELAY / 2)
	notification.visible = false
