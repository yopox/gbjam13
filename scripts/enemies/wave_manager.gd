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
	enemy.global_position = enemy.movement.get_pos(0.0, 0.0)
	add_child(enemy)


func gen_waves(difficulty: int) -> Array[WaveEvent]:
	# TODO: Generate waves
	return [
		WaveEvent.new(0.0, Waves.gen_wave(Waves.Types.WALL)),
	]
