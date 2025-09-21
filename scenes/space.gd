extends Node2D

@onready var ship: Node2D = $ship
@onready var shots: Node2D = $shots
@onready var unlucky_timer: Timer = $unlucky_timer
@onready var wave_manager: WaveManager = $wave_manager
@onready var footer: Footer = $footer

var enemies: int = 0
var defeated: int = 0
var escaped: int = 0
var ended: bool = false

func _ready() -> void:
	Signals.starfield_speed.emit(Values.STARFIELD_STAGE_RATIO ** Progress.stage)
	Progress.last_killed.clear()
	Progress.last_total.clear()
	Progress.shield_ready = true
	Progress.missile_ready = true
	Util.shots_node = shots
	Util.enemy_node = wave_manager
	Signals.unlucky_wave.connect(unlucky_wave)
	Signals.enemy_spawned.connect(enemy_spawned)
	Signals.enemy_dead.connect(enemy_dead)
	Signals.enemy_escaped.connect(enemy_escaped)
	Signals.waves_ended.connect(waves_ended)
	Signals.force_cards.connect(force_cards)
	Signals.boss_defeated.connect(boss_defeated)
	wave_manager.gen_wave()
	wave_manager.play()
	footer._on_ship_hp_changed(ship)
	Signals.send_notification.emit(stage_text())


func stage_text() -> String:
	if Progress.stage == 7: return "Final Stage!"
	return "Stage %s" % Progress.stage


func unlucky_wave() -> void:
	Progress.unlucky = true
	Signals.starfield_speed.emit((Values.STARFIELD_STAGE_RATIO ** Progress.stage) * Values.STARFIELD_UNLUCKY_RATIO)
	Signals.send_notification.emit("Unlucky!")
	
	if Progress.has(Power.ID.HEARTS_3):
		for e in Util.enemy_node.get_children():
			if e is Enemy:
				e.heal(Values.H3_ENEMY_HEAL)
	
	if Progress.has(Power.ID.HEARTS_7):
		Progress.shield_ready = true
		Progress.shield_reload.stop()
	
	var unlucky_duration = Values.UNLUCKY_WAVE_DURATION
	if Progress.has(Power.ID.CLUBS_4): unlucky_duration *= Values.C4_SHORTER_INTERVALS_RATIO
	unlucky_timer.wait_time = unlucky_duration
	unlucky_timer.start()
	await unlucky_timer.timeout
	Signals.starfield_speed.emit(Values.STARFIELD_STAGE_RATIO ** Progress.stage)
	footer.set_unlucky_ratio(0)
	Progress.unlucky = false
	Signals.unlucky_over.emit()


func _process(_delta: float) -> void:
	if Progress.unlucky:
		footer.set_unlucky_ratio(unlucky_timer.time_left / unlucky_timer.wait_time)
	footer.update_shield_ratio()
	footer.update_missile_ratio()


func enemy_spawned(enemy: Enemy) -> void:
	Progress.last_total[enemy.id] = true


func enemy_dead(enemy: Enemy) -> void:
	Progress.last_killed[enemy.id] = true
	Progress.total_killed += 1
	check_over()


func enemy_escaped() -> void:
	escaped += 1
	check_over()


func waves_ended() -> void:
	ended = true


func check_over() -> void:
	if not ended: return
	if Progress.last_total.size() > Progress.last_killed.size() + escaped:
		return
	if Progress.stage != 7:
		Log.info("Killed", Progress.last_killed.size(), "out of", Progress.last_total.size(), "+", escaped, "escaped.")
		Signals.change_scene.emit(Util.Scenes.CARDS)


func boss_defeated() -> void:
	Progress.boss_defeated = true
	Signals.change_scene.emit(Util.Scenes.GAME_OVER)


func force_cards(stage: int) -> void:
	if stage == Progress.stage:
		Log.err("Transition to the cards state had to be triggered manually")
		Signals.change_scene.emit(Util.Scenes.CARDS)
