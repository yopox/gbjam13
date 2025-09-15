extends Spaceship


func get_damage() -> int:
	return Values.SHIP_DAMAGE


func _physics_process(delta: float) -> void:
	var mvmt = Vector2.ZERO
	if Input.is_action_pressed("left"): mvmt.x = -1
	elif Input.is_action_pressed("right"): mvmt.x = 1
	if Input.is_action_pressed("up"): mvmt.y = -1
	elif Input.is_action_pressed("down"): mvmt.y = 1
	
	if floor(position.x) == 0: mvmt.x = max(0, mvmt.x)
	if floor(position.x) == Values.SHIP_XMAX: mvmt.x = min(0, mvmt.x)
	if floor(position.y) == 0: mvmt.y = max(0, mvmt.y)
	if floor(position.y) == Values.UI_Y: mvmt.y = min(0, mvmt.y)
	
	mvmt = mvmt.normalized()
	position += delta * Values.SHIP_SPEED * mvmt
 
