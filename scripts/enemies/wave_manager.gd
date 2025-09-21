class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")
const BOSS: Resource = preload("uid://6pytmswlhbgr")


var current_wave: Array[WaveEvent]


func _ready() -> void:
	Signals.boss_reinforcement.connect(boss_reinforcement)


func gen_wave() -> void:
	current_wave = gen_waves()


func play() -> void:
	var stage: int = Progress.stage - 1
	for event in current_wave:
		await Util.wait(event.delay)
		if event.unlucky:
			Signals.unlucky_wave.emit()
		for spawn in event.spawns:
			await Util.wait(spawn.delay)
			spawn_enemy(spawn)
		if event.unlucky:
			await Util.wait(Values.UNLUCKY_WAVE_DELAY)
	if stage != 6:
		Signals.waves_ended.emit()
		await Util.wait(20)
		Signals.force_cards.emit(stage)
	else:
		await Util.wait(Values.PRE_BOSS_DELAY / 2.0)
		Signals.send_notification.emit("Something comes!")
		await Util.wait(Values.PRE_BOSS_DELAY / 2.0)
		spawn_boss()


func spawn_enemy(spawn: Spawn) -> void:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.movement = spawn.movement
	enemy.global_position = enemy.movement.get_pos(0.0, 0.0)
	enemy.type = spawn.enemy
	enemy.id = Util.enemy_id_count
	Util.enemy_id_count += 1
	add_child(enemy)
	Signals.enemy_spawned.emit(enemy)


func spawn_boss() -> void:
	var boss = BOSS.instantiate()
	boss.global_position = Util.right(16, 0.5)
	add_child(boss)


func boss_reinforcement(boss_pos: Vector2) -> void:
	for i in range(Values.BOSS_REINFORCEMENT_LINES):
		var pos: Vector2 = Util.right(16, (i + 1.0) / (Values.BOSS_REINFORCEMENT_LINES + 1.0))
		if abs(pos.y - boss_pos.y) < 16.0: continue
		var spawn = Spawn.new(0, Waves.gen_enemy(6), MovSine.new(pos, Vector3(8.0, 1.5, 0.0)))
		spawn_enemy(spawn)


func gen_waves() -> Array[WaveEvent]:
	var d: int = Progress.stage - 1
	var w: Array[WaveEvent] = []
	for i in range(Waves.WAVES_PER_DIFF[d] - 1):
		w.append(WaveEvent.new(0.0 if i == 0 else Values.WAVE_DELAY, Waves.gen_wave_for_diff(d)))
	if w.size() > 0:
		var unlucky_i = randi_range(1, w.size())
		var unlucky_wave = WaveEvent.new(Values.WAVE_DELAY, Waves.gen_unlucky_wave(d))
		unlucky_wave.unlucky = true
		w.insert(unlucky_i, unlucky_wave)
		Progress.unlucky_wave = unlucky_i
	return w
