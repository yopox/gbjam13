extends Spaceship

@onready var evade_blinker: Blinker = $evade_blinker
@onready var evade_label: Label = $evade_label
@onready var shield: Shield = $shield
@onready var missile_timer: Timer = $missile_timer


func _ready() -> void:
	super()
	Signals.evade_damage.connect(do_evade)
	Signals.enemy_dead.connect(enemy_dead)
	shots_timer.timeout.connect(shot_fired)
	Progress.shield_timer = shield.timer
	Progress.shield_reload = shield.reload
	Progress.missile_reload = missile_timer
	max_hp = Progress.max_hull
	hp = Progress.hull


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("a"):
		if Progress.missile_ready:
			shoot_missile()
	if Input.is_action_just_pressed("b"):
		if Progress.shield_ready:
			if not (Progress.has(Power.ID.HEARTS_2) and Progress.unlucky):
				shield.enable()


func shot_fired() -> void:
	var delay = Values.SHIP_SHOT_DELAY * Progress.shot_delay_ratio
	if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
		delay *= Values.D5_SHOT_DELAY_DOWN_RATIO
	if Progress.has(Power.ID.DIAMS_6):
		@warning_ignore("integer_division")
		var n = Progress.last_killed / Values.D6_SHOT_DELAY_DOWN_EVERY_X_KILLS
		delay *= Values.D6_SHOT_DELAY_DOWN_RATIO ** n
	shots_timer.wait_time = delay
	if Progress.has(Power.ID.CLUBS_1):
		if randf() < Values.C1_DOUBLE_SHOT_CHANCE_PER_UNLUCK * Progress.get_bad_luck():
			await Util.wait(Values.C1_DOUBLE_SHOT_DELAY)
			shoot()


func get_damage() -> int:
	var boost: float = Progress.damage_boost
	if Progress.has(Power.ID.SPADES_1):
		boost += Progress.get_bad_luck() * Values.S1_DAMAGE_PER_UNLUCK
	if Progress.has(Power.ID.SPADES_6):
		boost += (Progress.max_hull - hp) * Values.S6_DAMAGE_PER_HULL
	if Progress.has(Power.ID.SPADES_8) and Progress.missile_ready and Progress.shield_ready:
		boost += Values.S8_CHARGED_DAMAGE_UP
	if Progress.has(Power.ID.CLUBS_7) and Progress.unlucky:
		boost += Values.S5_DAMAGE_UP
	return Values.SHIP_DAMAGE + ceil(boost)


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
	var speed = Values.SHIP_SPEED + boost
	if Progress.has(Power.ID.CLUBS_2) and Progress.unlucky:
		speed *= Values.C2_SPEED_DOWN_RATIO
	position += delta * speed * mvmt
	Util.ship_pos = global_position


func do_evade() -> void:
	hit_invul = true
	evade_label.visible = true
	evade_blinker.hit()


func _on_evade_blinker_blink_over() -> void:
	evade_label.visible = false
	hit_invul = false


func shoot_missile() -> void:
	Progress.missile_ready = false
	do_shoot_missile()
	missile_timer.wait_time = Values.MISSILE_RELOAD
	if Progress.has(Power.ID.DIAMS_1):
		missile_timer.wait_time *= Values.D1_RELOAD_FASTER_PER_UNLUCK_RATIO * Progress.get_bad_luck()
	missile_timer.start()
	await missile_timer.timeout
	Progress.missile_ready = true


func do_shoot_missile() -> void:
	var m: Bullet = BULLET.instantiate()
	m.enemy = false
	m.set_missile()
	m.damage = ceil(get_damage() * Values.MISSILE_DAMAGE_RATIO)
	m.global_position = shots_anchor.global_position
	m.dir = Vector2.from_angle(0)
	Util.shots_node.add_child(m)


func enemy_dead() -> void:
	if Progress.has(Power.ID.HEARTS_6):
		if Progress.last_killed % Values.H6_REGEN_EVERY_X_KILLS == 0:
			Progress.hull = min(Progress.hull + Values.H6_REGEN, Progress.max_hull)
			hp = Progress.hull
			hp_changed.emit(self)
