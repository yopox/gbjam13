extends Node

enum Types {
	ARROW, SLASH_5, FIVE, TRIO_LOOP, HATERS, DNA, ORBITING,
	SLASH_9, WALL
}


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


func gen_wave(type: Types) -> Array[Spawn]:
	# TODO: Add wave difficulty and generate enemies
	match type:
		Types.ARROW:
			return squad(
				MovLinear.new(Util.right(16, 0.5), 0),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 0], [Vector2.ZERO, Vector2(0, -12), Vector2(0, 12)]
			)
		Types.SLASH_5:
			return squad(
				MovLinear.new(Util.right(16, 0.7), 0),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48)]
			)
		Types.SLASH_9:
			return squad(
				MovLinear.new(Util.right(16, 0.85), 0),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48), Vector2(0, -60), Vector2(0, -72), Vector2(0, -84), Vector2(0, -96)]
			)
		Types.DNA:
			return [
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.5), Vector3(24.0, 1.5, 0.0))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.5), Vector3(24.0, 1.5, PI))),
			]
		Types.HATERS:
			return [
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.375), Vector3(10.0, 1.5, 0.0))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.625), Vector3(10.0, 1.5, PI))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.125), Vector3(10.0, 1.5, PI))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.875), Vector3(10.0, 1.5, 0))),
			]
		Types.FIVE:
			return [
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.3), Vector3(12.0, 1.5, 0.0))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.7), Vector3(12.0, 1.5, PI))),
				Spawn.new(2, Enemy.Types.E1, MovLinear.new(Util.right(16, 0.5), 0.0)),
				Spawn.new(2, Enemy.Types.E1, MovSine.new(Util.right(16, 0.3), Vector3(12.0, 1.5, PI))),
				Spawn.new(0, Enemy.Types.E1, MovSine.new(Util.right(16, 0.7), Vector3(12.0, 1.5, 0.0))),
			]
		Types.TRIO_LOOP:
			return squad(
				MovCircle.new(Util.right(16, 0.5), 12, 0, 2),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.5, 1.5],
				[Vector2(0, 24), Vector2.ZERO, Vector2(0, -24)]
			)
		Types.ORBITING:
			var spawns: Array[Spawn] = [Spawn.new(0, Enemy.Types.E1, MovLinear.new(Util.right(16, 0.5), 0))]
			spawns.append_array(circle(
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				Util.right(16, 0.5),
				32, 1, 0
			))
			return spawns
		Types.WALL:
			var hole = [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]].pick_random()
			var spawns: Array[Spawn] = []
			for i in range(8):
				if i in hole: continue
				spawns.append(Spawn.new(0, Enemy.Types.E1, MovLinear.new(Util.right(16, 0.06 + i * 0.125), 0)))
			return spawns
	Log.err("gen_wave didn't work")
	return []
