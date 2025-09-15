class_name WaveManager extends Node

const ENEMY: Resource = preload("uid://dc6wmh3trl2n4")


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
	# TODO: set enemy sprite
	enemy.movement = spawn.movement
	enemy.global_position = enemy.movement.get_pos(0.0)
	add_child(enemy)


func gen_waves(difficulty: int) -> Array[WaveEvent]:
	# TODO: Generate waves
	return [
		WaveEvent.new(0.0, [
			Spawn.new(
				1.0,
				Enemy.Types.E2,
				MovSine.new(Vector2(172, Values.SPAWN_Y_MID - 16), Values.ENEMY_SPEED, Vector3(10, 4, PI))
			),
			Spawn.new(
				0.0,
				Enemy.Types.E2,
				MovSine.new(Vector2(172, Values.SPAWN_Y_MID + 16), Values.ENEMY_SPEED, Vector3(10, 4, 0))
			)
		]),
		WaveEvent.new(5.0, follow(5, 1.25, Spawn.new(
			0.0,
			Enemy.Types.E3,
			MovSine.new(Vector2(172, Values.SPAWN_Y_MID), Values.ENEMY_SPEED, Vector3(12, 2, 0))
		)))
	]

	
func follow(n: int, delay: float, spawn: Spawn) -> Array[Spawn]:
	var s: Array[Spawn] = []
	for i in range(n):
		var s1: Spawn = Spawn.new(0.0 if i == 0 else delay, spawn.enemy, spawn.movement)
		s.append(s1)
	return s
