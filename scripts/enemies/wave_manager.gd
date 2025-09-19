class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")


var current_wave: Array[WaveEvent]


func gen_wave() -> void:
	current_wave = gen_waves()


func play() -> void:
	for event in current_wave:
		await Util.wait(event.delay)
		if event.unlucky:
			Signals.unlucky_wave.emit()
		for spawn in event.spawns:
			await Util.wait(spawn.delay)
			spawn_enemy(spawn)
			Signals.enemy_spawned.emit()
		if event.unlucky:
			await Util.wait(Values.POST_UNLUCKY_WAVE_DELAY)
	Signals.waves_ended.emit()


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
		w.append(WaveEvent.new(0.0 if i == 0 else Values.WAVE_DELAY, Waves.gen_wave_for_diff(d)))
	var unlucky_i = randi_range(1, w.size() - 1)
	var unlucky_wave = WaveEvent.new(Values.WAVE_DELAY, Waves.gen_unlucky_wave(d))
	unlucky_wave.unlucky = true
	w.insert(unlucky_i, unlucky_wave)
	Progress.unlucky_wave = unlucky_i
	return w
