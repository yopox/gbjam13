extends Node

enum Types {
	ARROW, SLASH_5, TRIO_1, TRIO_2, HATERS, DNA,
	SLASH_9
}


func gen_wave(type: Types) -> Array[Spawn]:
	match type:
		Types.ARROW:
			return WaveManager.squad(
				MovLinear.new(Util.right(16, 0.5), 0, Values.ENEMY_SPEED),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 0], [Vector2.ZERO, Vector2(0, -12), Vector2(0, 12)]
			)
		Types.SLASH_5:
			return WaveManager.squad(
				MovLinear.new(Util.right(16, 0.7), 0, Values.ENEMY_SPEED),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48)]
			)
		Types.SLASH_9:
			return WaveManager.squad(
				MovLinear.new(Util.right(16, 0.85), 0, Values.ENEMY_SPEED),
				[Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1, Enemy.Types.E1],
				[0, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25, 1.25], [Vector2.ZERO, Vector2(0, -12), Vector2(0, -24), Vector2(0, -36), Vector2(0, -48), Vector2(0, -60), Vector2(0, -72), Vector2(0, -84), Vector2(0, -96)]
			)
	Log.err("gen_wave didn't work")
	return []
