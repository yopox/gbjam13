extends Node

enum Types {
	ARROW, SLASH_5, FIVE, TRIO_LOOP, HATERS, DNA, ORBITING,
	SLASH_9, WALL
}

const WEIGHTS = [
	[1.0, 0.0, 0.0],
	[0.9, 0.1, 0.0],
	[0.35, 0.65, 0.0],
	[0.25, 0.7, 0.05],
	[0.15, 0.5, 0.35],
	[0.1, 0.2, 0.7]
]

const WAVES_PER_DIFF = [
	3, 4, 4, 5, 5, 6
]

#region Enemy Generation

func gen_n_enemy(difficulty: int, n: int) -> Array[Enemy.Types]:
	var e: Array[Enemy.Types] = []
	for i in range(n): e.append(gen_enemy(difficulty))
	return e


func gen_enemy(difficulty: int) -> Enemy.Types:
	var w = WEIGHTS[difficulty]
	var r = randf()
	if r <= w[0]: return Enemy.T1.pick_random()
	if r <= w[1]: return Enemy.T2.pick_random()
	return Enemy.T3.pick_random()
	
#endregion

#region Movement Generation

func follow(n: int, delay: float, spawn: Spawn) -> Array[Spawn]:
	var s: Array[Spawn] = []
	for i in range(n):
		var s1: Spawn = Spawn.new(0.0 if i == 0 else delay, spawn.enemy, spawn.movement)
		s.append(s1)
	return s

func squad(base_movement: Movement, enemies: Array[Enemy.Types], dt: Array[float], dp: Array[Vector2]) -> Array[Spawn]:
	var n: int = len(enemies)
	var spawns: Array[Spawn] = []
	var starting_pos: Vector2 = base_movement.starting_pos
	for i in range(n):
		var s: Spawn = Spawn.new(dt[i], enemies[i], base_movement.with_starting_pos(starting_pos + dp[i]))
		spawns.append(s)
	return spawns

func circle(enemies: Array[Enemy.Types], starting_pos: Vector2, r: float, a_speed: float, a_offset: float = 0.0) -> Array[Spawn]:
	var n: int = len(enemies)
	var spawns: Array[Spawn] = []
	for i in range(n):
		var s: Spawn = Spawn.new(0, enemies[i], MovCircle.new(starting_pos, r, a_offset + i * 2 * PI / n, a_speed))
		spawns.append(s)
	return spawns

#endregion

#region Wave Generation

func gen_wave_type_for_diff(difficulty: int) -> Types:
	match difficulty:
		0: return [Types.ARROW, Types.DNA].pick_random()
		1: return [Types.ARROW, Types.DNA, Types.ORBITING].pick_random()
		2: return [Types.ARROW, Types.HATERS, Types.ORBITING, Types.SLASH_5, Types.TRIO_LOOP].pick_random()
		_: return Types.values().pick_random()


func gen_wave_for_diff(difficulty: int) -> Array[Spawn]:
	return gen_wave(gen_wave_type_for_diff(difficulty), difficulty)


func gen_wave(type: Types, difficulty: int) -> Array[Spawn]:
	match type:
		Types.DNA:
			var e = gen_enemy(difficulty)
			var mov = Util.right(16, randf_range(0.3, 0.7))
			return [
				Spawn.new(0, e, MovSine.new(mov, Vector3(24.0, 1.5, 0.0))),
				Spawn.new(0, e, MovSine.new(mov, Vector3(24.0, 1.5, PI))),
			]
		Types.ARROW:
			return squad(
				MovLinear.new(Util.right(16, randf_range(0.3, 0.7)), 0),
				gen_n_enemy(difficulty, 3),
				[0, 1.75, 0], [Vector2.ZERO, Vector2(0, -12), Vector2(0, 12)]
			)
		Types.SLASH_5:
			return squad(
				MovLinear.new(Util.right(16, 0.7), 0),
				gen_n_enemy(difficulty, 5),
				[0, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48)]
			)
		Types.SLASH_9:
			return squad(
				MovLinear.new(Util.right(16, 0.85), 0),
				gen_n_enemy(difficulty, 9),
				[0, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48), Vector2(0, -60), Vector2(0, -72), Vector2(0, -84), Vector2(0, -96)]
			)
		Types.HATERS:
			var e1 = gen_enemy(difficulty)
			var e2 = gen_enemy(difficulty)
			return [
				Spawn.new(0, e2, MovSine.new(Util.right(16, 0.375), Vector3(10.0, 1.5, 0.0))),
				Spawn.new(0, e1, MovSine.new(Util.right(16, 0.625), Vector3(10.0, 1.5, PI))),
				Spawn.new(0, e1, MovSine.new(Util.right(16, 0.125), Vector3(10.0, 1.5, PI))),
				Spawn.new(0, e2, MovSine.new(Util.right(16, 0.875), Vector3(10.0, 1.5, 0))),
			]
		Types.FIVE:
			var e = gen_n_enemy(difficulty, 5)
			return [
				Spawn.new(0, e[0], MovSine.new(Util.right(16, 0.3), Vector3(12.0, 1.5, 0.0))),
				Spawn.new(0, e[1], MovSine.new(Util.right(16, 0.7), Vector3(12.0, 1.5, PI))),
				Spawn.new(2, e[2], MovLinear.new(Util.right(16, 0.5), 0.0)),
				Spawn.new(2, e[3], MovSine.new(Util.right(16, 0.3), Vector3(12.0, 1.5, PI))),
				Spawn.new(0, e[4], MovSine.new(Util.right(16, 0.7), Vector3(12.0, 1.5, 0.0))),
			]
		Types.TRIO_LOOP:
			return squad(
				MovCircle.new(Util.right(16, 0.5), 12, 0, 2),
				gen_n_enemy(difficulty, 3),
				[0, 1.5, 1.5],
				[Vector2(0, 24), Vector2.ZERO, Vector2(0, -24)]
			)
		Types.ORBITING:
			var spawns: Array[Spawn] = [Spawn.new(0, gen_enemy(difficulty), MovLinear.new(Util.right(16, 0.5), 0))]
			spawns.append_array(circle(
				gen_n_enemy(max(0, difficulty - 2), 4),
				Util.right(16, 0.5),
				32, 1, 0
			))
			return spawns
		Types.WALL:
			var e = gen_enemy(difficulty)
			var hole = [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]].pick_random()
			var spawns: Array[Spawn] = []
			for i in range(8):
				if i in hole: continue
				spawns.append(Spawn.new(0, e, MovLinear.new(Util.right(16, 0.06 + i * 0.125), 0)))
			return spawns
	Log.err("gen_wave didn't work")
	return []

#endregion
