extends Node

enum Types {
	FOLLOW_2, FOLLOW_3, CROSSERS_2, CROSSERS_3, SIDE_HUNTERS,
	ARROW, SLASH_5, FIVE, TRIO_LOOP, HATERS, DNA, ORBITING,
	SLASH_7, WALL, SIDE_HUNTERS_6,
	FOLLOW_CIRCLE_3, CIRCLE_4, UNLUCKY_1, SINE_6, WHEEL, CONCENTRIC, SINE_12,
}

const WEIGHTS = [
	[1.0, 0.0, 0.0],
	[0.9, 0.1, 0.0],
	[0.35, 0.65, 0.0],
	[0.25, 0.7, 0.05],
	[0.15, 0.5, 0.35],
	[0.1, 0.2, 0.7],
	[0.3, 0.3, 0.4],
]

const WAVES_PER_DIFF = [
	3, 3, 4, 5, 6, 7, 8
]

#region Enemy Generation

func gen_n_enemy(difficulty: int, n: int) -> Array[Enemy.Types]:
	var e: Array[Enemy.Types] = []
	for i in range(n): e.append(gen_enemy(difficulty))
	return e


func gen_enemy(difficulty: int) -> Enemy.Types:
	var w = WEIGHTS[difficulty]
	var r: float = randf()
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
		0: return [Types.ARROW, Types.DNA, Types.FOLLOW_2, Types.CROSSERS_2, Types.SIDE_HUNTERS].pick_random()
		1: return [Types.ARROW, Types.DNA, Types.ORBITING, Types.SIDE_HUNTERS, Types.FOLLOW_3, Types.CROSSERS_2, Types.CROSSERS_3].pick_random()
		2: return [Types.HATERS, Types.ORBITING, Types.SIDE_HUNTERS_6, Types.SLASH_5, Types.TRIO_LOOP, Types.FOLLOW_2, Types.FOLLOW_3, Types.CROSSERS_3].pick_random()
		_: return Types.values().pick_random()


func unlucky_wave_for_diff(difficulty: int) -> Types:
	match difficulty:
		0: return [Types.FOLLOW_CIRCLE_3, Types.CIRCLE_4].pick_random()
		1: return [Types.UNLUCKY_1, Types.SINE_6].pick_random()
		2: return [Types.CONCENTRIC, Types.WHEEL, Types.SINE_12].pick_random()
		_: return Types.values().pick_random()


func gen_unlucky_wave(difficulty: int) -> Array:
	return gen_wave(unlucky_wave_for_diff(difficulty), difficulty)


func gen_wave_for_diff(difficulty: int) -> Array:
	return gen_wave(gen_wave_type_for_diff(difficulty), difficulty)


func linear_angle(from: Vector2, to_x: float, to_y: float) -> float:
	Log.info(from, to_x, to_y, from.angle_to(Vector2(to_x, to_y)))
	return Vector2(-1, 0).angle_to(Vector2(to_x, to_y) - from)


func gen_wave(type: Types, difficulty: int) -> Array:
	match type:
		Types.FOLLOW_2:
			var e = gen_enemy(difficulty)
			var mov = MovSine.new(Util.right(16, randf_range(0.2, 0.8)), Vector3(12.0, 1.0, 0.0))
			var spawn = Spawn.new(0, e, mov)
			return follow(2, 1.5, spawn)
		Types.FOLLOW_CIRCLE_3:
			var e = gen_enemy(difficulty)
			var mov = MovCircle.new(Util.right(16, randf_range(0.3, 0.7)), 28, 0.0, 1.5)
			var spawn = Spawn.new(0, e, mov)
			return follow(3, 1.2, spawn)
		Types.FOLLOW_3:
			var e = gen_enemy(difficulty)
			var mov = MovCircle.new(Util.right(16, randf_range(0.3, 0.7)), 12.0, 0.0, 1.0)
			var spawn = Spawn.new(0, e, mov)
			return follow(3, 1.5, spawn)
		Types.CROSSERS_2:
			var e = gen_enemy(difficulty)
			var starting = Util.right(16, randf_range(0.35, 0.65))
			var a = PI / 8 * randf_range(-1, 1)
			var spawn = Spawn.new(0, e, MovLinear.new(starting, a))
			return follow(2, 1.5, spawn)
		Types.CROSSERS_3:
			var e = gen_enemy(difficulty)
			var starting = Util.right(16, randf_range(0.35, 0.65))
			var a = PI / 8 * randf_range(-1, 1)
			var spawn = Spawn.new(0, e, MovLinear.new(starting, a))
			return follow(3, 1.5, spawn)
		Types.SIDE_HUNTERS:
			var e = gen_enemy(difficulty)
			return [
				Spawn.new(0, e, MovLinear.new(Util.right(16, 0.2), linear_angle(Util.right(16, 0.2), 0, Values.UI_Y / 2.0 - 16))),
				Spawn.new(0, e, MovLinear.new(Util.right(16, 0.8), linear_angle(Util.right(16, 0.8), 0, Values.UI_Y / 2.0 + 16))),
			]
		Types.SIDE_HUNTERS_6:
			var e = gen_enemy(difficulty)
			var down = MovLinear.new(Util.right(16, 0.2), linear_angle(Util.right(16, 0.2), 0, Values.UI_Y / 2.0 - 16))
			var up = MovLinear.new(Util.right(16, 0.8), linear_angle(Util.right(16, 0.8), 0, Values.UI_Y / 2.0 + 16))
			return [
				Spawn.new(0, e, down),
				Spawn.new(0, e, up),
				Spawn.new(1.5, e, down),
				Spawn.new(0, e, up),
				Spawn.new(1.5, e, down),
				Spawn.new(0, e, up),
			]
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
		Types.SLASH_7:
			var dy: float = Values.UI_Y / 8.0
			return squad(
				MovLinear.new(Util.right(16, 1), 0),
				gen_n_enemy(difficulty, 7),
				[0, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25],
				[Vector2(0, -dy * 1), Vector2(0, -dy * 2), Vector2(0, -dy * 3), Vector2(0, -dy * 4), Vector2(0, -dy * 5), Vector2(0, -dy * 6), Vector2(0, -dy * 7)]
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
		Types.CONCENTRIC:
			var spawns: Array = []
			spawns.append_array(circle(
				gen_n_enemy(max(0, difficulty - 2), 6),
				Util.right(64, 0.5),
				48, -1, 0
			))
			spawns.append_array(circle(
				gen_n_enemy(difficulty, 3),
				Util.right(64, 0.5),
				16, 0.5, 0
			))
			spawns.append(Wait.new(4.0))
			return spawns
		Types.CIRCLE_4:
			var spawns: Array = []
			spawns.append_array(circle(
				gen_n_enemy(max(0, difficulty), 4),
				Util.right(48, 0.5),
				32, -1.2, 0
			))
			spawns.append(Wait.new(2.0))
			return spawns
		Types.UNLUCKY_1:
			var e = gen_n_enemy(difficulty, 3)
			var s: Array[Spawn] = []
			s.append(Spawn.new(0, e[0], MovSine.new(Util.right(16, 0.5), Vector3(12, 2, 0))))
			s.append_array(squad(MovSine.new(Util.right(16, 0.5), Vector3(8, 3, 0)), [e[1], e[1]], [1.5, 0.0], [Vector2(0, 24), Vector2(0, -24)]))
			s.append_array(squad(MovSine.new(Util.right(16, 0.5), Vector3(4, 3, 0)), [e[2], e[2], e[2]], [1.5, 0, 0], [Vector2(0, 32), Vector2.ZERO, Vector2(0, -32)]))
			return s
		Types.WHEEL:
			var s: Array = []
			s.append_array(circle(
				gen_n_enemy(max(0, difficulty - 1), 12),
				Util.right(64, randf_range(0.45, 0.55)),
				48, 0.5, 0
			))
			s.append(Wait.new(5.0))
			return s
		Types.SINE_6:
			var s: Array = []
			var e: Array[Enemy.Types] = gen_n_enemy(difficulty, 3)
			var sin_param: Vector3 = Vector3(16, 2, 0)
			for i in range(2):
				s.append(Spawn.new(0.0 if i == 0 else 2.0, e[i], MovSine.new(Util.right(16, 0.25), sin_param)))
				s.append(Spawn.new(0, e[i], MovSine.new(Util.right(16, 0.5), sin_param)))
				s.append(Spawn.new(0, e[i], MovSine.new(Util.right(16, 0.75), sin_param)))
			s.append(Wait.new(2.0))
			return s
		Types.SINE_12:
			var s: Array = []
			var e: Array[Enemy.Types] = gen_n_enemy(difficulty, 4)
			var sin_param: Vector3 = Vector3(16, 2, 0)
			for i in range(4):
				s.append(Spawn.new(0.0 if i == 0 else 1.5, e[i], MovSine.new(Util.right(16, 0.25), sin_param)))
				s.append(Spawn.new(0, e[i], MovSine.new(Util.right(16, 0.5), sin_param)))
				s.append(Spawn.new(0, e[i], MovSine.new(Util.right(16, 0.75), sin_param)))
			s.append(Wait.new(2.0))
			return s
	Log.err("gen_wave didn't work")
	return []

#endregion
