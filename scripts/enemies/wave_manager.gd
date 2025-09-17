class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")


var difficulty: int = 0
var current_wave: Array[WaveEvent]


func _ready() -> void:
	current_wave = gen_waves(0)
	play()


func play() -> void:
	Log.info("Wave start")
	for event in current_wave:
		await Util.wait(event.delay)
		for spawn in event.spawns:
			await Util.wait(spawn.delay)
			spawn_enemy(spawn)
	Log.info("Wave end")
	current_wave = []


func spawn_enemy(spawn: Spawn) -> void:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.movement = spawn.movement
	enemy.global_position = enemy.movement.get_pos(0.0, 0.0)
	enemy.type = spawn.enemy
	add_child(enemy)


func gen_waves(difficulty: int) -> Array[WaveEvent]:
	var w: Array[WaveEvent] = []
	for i in range(Waves.WAVES_PER_DIFF[difficulty]):
		w.append(WaveEvent.new(0.0 if i == 0 else 4.0, Waves.gen_wave_for_diff(difficulty)))
	return w
