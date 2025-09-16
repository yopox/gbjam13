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
		WaveEvent.new(0.0, Waves.gen_wave(Waves.Types.SLASH_9)),
	]

	
func follow(n: int, delay: float, spawn: Spawn) -> Array[Spawn]:
	var s: Array[Spawn] = []
	for i in range(n):
		var s1: Spawn = Spawn.new(0.0 if i == 0 else delay, spawn.enemy, spawn.movement)
		s.append(s1)
	return s


static func squad(base_movement: Movement, enemies: Array[Enemy.Types], dt: Array[float], dp: Array[Vector2]) -> Array[Spawn]:
	var n: int = len(enemies)
	var spawns: Array[Spawn] = []
	var starting_pos: Vector2 = base_movement.starting_pos
	for i in range(n):
		var s: Spawn = Spawn.new(dt[i], enemies[i], base_movement.with_starting_pos(starting_pos + dp[i]))
		spawns.append(s)
	return spawns


func circle(enemies: Array[Enemy.Types], starting_pos: Vector2, x_speed: float, r: float, a_speed: float, a_offset: float = 0.0) -> Array[Spawn]:
	var n: int = len(enemies)
	var spawns: Array[Spawn] = []
	for i in range(n):
		var s: Spawn = Spawn.new(0, enemies[i], MovCircle.new(starting_pos, x_speed, r, a_offset + i * 2 * PI / n, a_speed))
		spawns.append(s)
	return spawns
