extends Node2D

@onready var shots: Node2D = $shots
@onready var unlucky_timer: Timer = $unlucky_timer
@onready var wave_manager: WaveManager = $wave_manager
@onready var footer: Footer = $footer

var enemies: int = 0
var defeated: int = 0
var escaped: int = 0
var ended: bool = false

func _ready() -> void:
	Progress.last_killed = 0
	Progress.last_total = 0
	Progress.shield_ready = true
	Util.shots_node = shots
	Util.enemy_node = wave_manager
	Signals.unlucky_wave.connect(unlucky_wave)
	Signals.enemy_spawned.connect(enemy_spawned)
	Signals.enemy_dead.connect(enemy_dead)
	Signals.enemy_escaped.connect(enemy_escaped)
	Signals.waves_ended.connect(waves_ended)
	Signals.force_cards.connect(force_cards)
	wave_manager.gen_wave()
	wave_manager.play()


func unlucky_wave() -> void:
	Progress.unlucky = true
	Log.info("UNLUCKY")
	# TODO: heal enemies on screen (HEARTS_3)
	
	if Progress.has(Power.ID.HEARTS_7):
		Progress.shield_ready = true
		Progress.shield_reload.stop()
	
	# TODO: visual effect for the unlucky wave
	var unlucky_duration = Values.UNLUCKY_WAVE_DURATION
	if Progress.has(Power.ID.CLUBS_4): unlucky_duration *= Values.C4_SHORTER_INTERVALS_RATIO
	unlucky_timer.wait_time = unlucky_duration
	unlucky_timer.start()
	await unlucky_timer.timeout
	footer.set_unlucky_ratio(0)
	Progress.unlucky = false
	Log.info("UNLUCKY finished")


func _process(_delta: float) -> void:
	if Progress.unlucky:
		footer.set_unlucky_ratio(unlucky_timer.time_left / unlucky_timer.wait_time)
	footer.update_shield_ratio()
	footer.update_missile_ratio()


func enemy_spawned() -> void:
	enemies += 1


func enemy_dead() -> void:
	defeated += 1
	check_over()


func enemy_escaped() -> void:
	escaped += 1
	check_over()


func waves_ended() -> void:
	ended = true


func check_over() -> void:
	if not ended: return 
	if not enemies == defeated + escaped: return
	Progress.last_total = enemies
	Progress.last_killed = defeated
	Signals.change_scene.emit(Util.Scenes.CARDS)


func force_cards(stage: int) -> void:
	if stage == Progress.stage:
		Log.err("Transition to the cards state had to be triggered manually")
		Signals.change_scene.emit(Util.Scenes.CARDS)
