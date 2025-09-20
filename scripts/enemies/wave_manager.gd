class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")
const BOSS: Resource = preload("uid://6pytmswlhbgr")


var current_wave: Array[WaveEvent]


func gen_wave() -> void:
	current_wave = gen_waves()


func play() -> void:
	var stage = Progress.stage - 1
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
	if stage != 6:
		Signals.waves_ended.emit()
		await Util.wait(20)
		Signals.force_cards.emit(stage)
	else:
		await Util.wait(Values.PRE_BOSS_DELAY)
		spawn_boss()
		await Signals.boss_defeated


func spawn_enemy(spawn: Spawn) -> void:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.movement = spawn.movement
	enemy.global_position = enemy.movement.get_pos(0.0, 0.0)
	enemy.type = spawn.enemy
	add_child(enemy)


func spawn_boss() -> void:
	var boss = BOSS.instantiate()
	boss.global_position = Util.right(16, 0.5)
	add_child(boss)


func gen_waves() -> Array[WaveEvent]:
	var d: int = Progress.stage - 1
	var w: Array[WaveEvent] = []
	for i in range(Waves.WAVES_PER_DIFF[d] - 1):
		w.append(WaveEvent.new(0.0 if i == 0 else Values.WAVE_DELAY, Waves.gen_wave_for_diff(d)))
	var unlucky_i = randi_range(1, w.size() - 1)
	var unlucky_wave = WaveEvent.new(Values.WAVE_DELAY, Waves.gen_unlucky_wave(d))
	unlucky_wave.unlucky = true
	w.insert(unlucky_i, unlucky_wave)
	Progress.unlucky_wave = unlucky_i
	return w
