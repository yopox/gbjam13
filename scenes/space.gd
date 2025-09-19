extends Node2D

@onready var shots: Node2D = $shots
@onready var wave_manager: WaveManager = $wave_manager

var enemies: int = 0
var defeated: int = 0
var escaped: int = 0
var ended: bool = false

func _ready() -> void:
	Progress.last_killed = 0
	Progress.last_total = 0
	Util.shots_node = shots
	Signals.enemy_spawned.connect(enemy_spawned)
	Signals.enemy_dead.connect(enemy_dead)
	Signals.enemy_escaped.connect(enemy_escaped)
	Signals.wave_ended.connect(wave_ended)
	wave_manager.gen_wave()
	wave_manager.play()


func enemy_spawned() -> void:
	enemies += 1


func enemy_dead() -> void:
	defeated += 1
	check_over()


func enemy_escaped() -> void:
	escaped += 1
	check_over()


func wave_ended() -> void:
	ended = true


func check_over() -> void:
	if not ended: return 
	if not enemies == defeated + escaped: return
	Progress.last_total = enemies
	Progress.last_killed = defeated
	Signals.change_scene.emit(Util.Scenes.CARDS)
