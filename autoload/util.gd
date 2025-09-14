extends Node


enum Scenes {
	TITLE, HANGAR, SPACE, CARDS
}

var shots_node: Node2D


func wait(amount: float):
	await get_tree().create_timer(amount).timeout


func check_oob(position: Vector2, margin: float) -> bool:
	return position.x > Values.SCREEN_W + margin \
		or position.x < -1 * margin \
		or position.y < margin \
		or position.y > Values.UI_Y + margin
