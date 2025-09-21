class_name Boss extends Spaceship


enum State {
	IDLE, IDLE_SPAWN, TARGET_SHIP, MOVING, UNLUCKY
}

const IDLE_STATES: Array[State] = [State.IDLE, State.IDLE_SPAWN]

@onready var shots_1: Node2D = $shots1
@onready var shots_2: Node2D = $shots2
@onready var shots_3: Node2D = $shots3
@onready var shots_4: Node2D = $shots4

var state: State = State.IDLE
var chrono: float = 0
var unlucky_timestamp: float = 0
var unlucky_offset: float = 0

func _ready() -> void:
	create_timer()
	max_hp = Values.BOSS_HP
	hp = Values.BOSS_HP

	Signals.boss_spawned.emit(self)
	blinker.blink_over.connect(blink_over)
	hitbox.area_entered.connect(do_hit)

	start_patterns()


func start_patterns() -> void:
	await move_to(Util.right(Values.BOSS_DX, 0.5))
	pattern()


func get_damage() -> int:
	return Values.BOSS_DAMAGE


func get_shot_delay() -> float:
	match state:
		State.MOVING: return Values.BOSS_MOVING_SHOT_DELAY
		State.UNLUCKY: return Values.BOSS_UNLUCKY_SHOT_DELAY
		_: return Values.BOSS_SHOT_DELAY


func move_to(pos: Vector2) -> void:
	var tween = get_tree().create_tween()
	var time = global_position.distance_to(pos) / Values.BOSS_SPEED
	tween.tween_property(self, "global_position", pos, time)
	tween.set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished


func _physics_process(delta: float) -> void:
	chrono += delta
	match state:
		State.UNLUCKY:
			var t = chrono - unlucky_timestamp
			global_position.y = Values.UI_Y / 2.0 + sin(t * Values.BOSS_SIN_FREQ + unlucky_offset) * Values.BOSS_SIN_AMP
		_: return


func shoot_bullet(_angle: float) -> void:
	match state:
		State.IDLE:
			pass
		State.MOVING:
			var b1 = create_bullet(shots_1.global_position, shots_1.global_position - Vector2(1, 0))
			var b2 = create_bullet(shots_2.global_position, shots_2.global_position - Vector2(1, 0))
			Util.shots_node.add_child(b1)
			Util.shots_node.add_child(b2)
		State.TARGET_SHIP:
			var b1 = create_bullet(shots_1.global_position, Util.ship_pos)
			var b2 = create_bullet(shots_2.global_position, Util.ship_pos)
			Util.shots_node.add_child(b1)
			Util.shots_node.add_child(b2)
		State.UNLUCKY:
			var b1 = create_bullet(shots_1.global_position, shots_1.global_position - Vector2(1, 0))
			var b2 = create_bullet(shots_2.global_position, shots_2.global_position - Vector2(1, 0))
			var b3 = create_bullet(shots_3.global_position, shots_3.global_position + Vector2(-2, -1))
			var b4 = create_bullet(shots_4.global_position, shots_4.global_position + Vector2(-2, 1))
			Util.shots_node.add_child(b1)
			Util.shots_node.add_child(b2)
			Util.shots_node.add_child(b3)
			Util.shots_node.add_child(b4)


func create_bullet(from: Vector2, to: Vector2) -> Bullet:
	var bullet: Bullet = BULLET.instantiate()
	bullet.enemy = enemy
	bullet.damage = get_damage()
	bullet.global_position = from
	bullet.dir = from.direction_to(to)
	return bullet


func pattern() -> void:
	shots_timer.wait_time = get_shot_delay()
	match state:
		State.IDLE:
			await Util.wait(Values.BOSS_IDLE_WAIT)
		State.IDLE_SPAWN:
			Signals.boss_reinforcement.emit(global_position)
			await Util.wait(Values.BOSS_IDLE_SPAWN_WAIT)
		State.TARGET_SHIP:
			for i in range(Values.BOSS_TARGET_SHIP_MOVES):
				await move_to(Vector2(global_position.x, Util.ship_pos.y))
				await Util.wait(Values.BOSS_TARGET_SHIP_MOVE_INTERVAL)
		State.UNLUCKY:
			unlucky_timestamp = chrono
			unlucky_offset = (global_position.y - Values.UI_Y / 2.0) / Values.BOSS_SIN_AMP
			Signals.unlucky_wave.emit()
			await Signals.unlucky_over
		State.MOVING:
			var previous = -1
			for i in range(Values.BOSS_MOVING_MOVES):
				var n = randi_range(1, 4)
				while n == previous:
					n = randi_range(1, 4)
				previous = n
				await move_to(Util.right(Values.BOSS_DX, 0.2 * n))
				await Util.wait(Values.BOSS_MOVING_MOVE_INTERVAL)

	# Pick new state at random
	var old_state = state
	while old_state == state or old_state in IDLE_STATES and state in IDLE_STATES:
		state = State.values().pick_random()
	pattern()
