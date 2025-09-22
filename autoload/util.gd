extends Node


enum Scenes {
	SPLASH, TITLE, HANGAR, SPACE, CARDS, GAME_OVER
}

enum GameMode {
	REGULAR, DRAFT_7
}

var current_palette: Array[Color]
var current_mode: GameMode = GameMode.REGULAR

var shots_node: Node2D
var enemy_node: Node

var block_input: bool = false
var hit_stop: bool = false
var enemy_id_count: int = 0

var ship_pos: Vector2 = Vector2.ZERO


func wait(amount: float):
	await get_tree().create_timer(amount).timeout


func check_oob(position: Vector2, margin: float) -> bool:
	return position.x > Values.SCREEN_W + margin \
		or position.x < -margin \
		or position.y < -margin \
		or position.y > Values.UI_Y + margin

	
func right(x: float, y: float) -> Vector2:
	return Vector2(Values.SCREEN_W + x, Values.UI_Y * y)
