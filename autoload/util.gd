extends Node


enum Scenes {
	SPLASH, TITLE, HANGAR, SPACE, CARDS
}

var shots_node: Node2D
var enemy_node: Node

var block_input: bool = false


func wait(amount: float):
	await get_tree().create_timer(amount).timeout


func check_oob(position: Vector2, margin: float) -> bool:
	return position.x > Values.SCREEN_W + margin \
		or position.x < -margin \
		or position.y < -margin \
		or position.y > Values.UI_Y + margin

	
func right(x: float, y: float) -> Vector2:
	return Vector2(Values.SCREEN_W + x, Values.UI_Y * y)
