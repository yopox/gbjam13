class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")


var current_wave: Array[WaveEvent]


func gen_wave() -> void:
	current_wave = gen_waves()


func play() -> void:
	for event in current_wave:
		await Util.wait(event.delay)
		for spawn in event.spawns:
			await Util.wait(spawn.delay)
			spawn_enemy(spawn)
			Signals.enemy_spawned.emit()
	Signals.wave_ended.emit()


func spawn_enemy(spawn: Spawn) -> void:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.movement = spawn.movement
	enemy.global_position = enemy.movement.get_pos(0.0, 0.0)
	enemy.type = spawn.enemy
	add_child(enemy)


func gen_waves() -> Array[WaveEvent]:
	var d: int = Progress.stage
	var w: Array[WaveEvent] = []
	for i in range(Waves.WAVES_PER_DIFF[d]):
		w.append(WaveEvent.new(0.0 if i == 0 else 4.0, Waves.gen_wave_for_diff(d)))
	return w
