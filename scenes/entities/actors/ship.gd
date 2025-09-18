extends Spaceship


func _ready() -> void:
	super()
	shots_timer.timeout.connect(shot_fired)


func shot_fired() -> void:
	var delay = Values.SHIP_SHOT_DELAY * Progress.shot_delay_ratio
	if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
		delay *= Values.D5_SHOT_DELAY_DOWN_RATIO
	if Progress.has(Power.ID.DIAMS_6):
		@warning_ignore("integer_division")
		var n = Progress.last_killed / Values.D6_SHOT_DELAY_DOWN_EVERY_X_KILLS
		delay *= Values.D6_SHOT_DELAY_DOWN_RATIO ** n
	shots_timer.wait_time = delay


func get_damage() -> int:
	var boost = Progress.damage_boost
	if Progress.has(Power.ID.SPADES_1):
		boost += Progress.get_bad_luck() * Values.S1_DAMAGE_PER_UNLUCK
	if Progress.has(Power.ID.SPADES_6):
		boost += (Progress.max_hull - hp) * Values.S6_DAMAGE_PER_HULL
	if Progress.has(Power.ID.SPADES_8):
		# TODO: SP8 damage up if fully charged
		pass
	if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
		boost += Values.S5_DAMAGE_UP
	return Values.SHIP_DAMAGE + floor(boost)


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
	var boost = Progress.speed_boost
	if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
		boost += Values.C5_SPEED_UP
	position += delta * (Values.SHIP_SPEED + boost) * mvmt
