@abstract class_name Spaceship extends Node2D

signal hp_changed(spaceship: Spaceship)

const BULLET: Resource = preload("uid://whpdohlupewc")

@export var enemy: bool = true
@export var hitbox: Area2D
@export var blinker: Blinker
@export var shots_anchor: Node2D
@export var max_hp: int = 10

var hp: int
var shots_timer: Timer
var hit_invul: bool = false


func _ready() -> void:
	create_timer()
	blinker.blink_over.connect(blink_over)
	hp = max_hp
	hitbox.area_entered.connect(do_hit)


@abstract func get_damage() -> int


func shoot() -> void:
	if Util.block_input: return
	if hp == 0: return
	if Util.check_oob(global_position, 0): return
	if not enemy and Progress.has(Power.ID.SPADES_2):
		if Progress.unlucky and Time.get_ticks_msec() - Progress.unlucky_timestamp < Values.S2_CANT_SHOOT_MS:
			return
	shoot_bullet(0.0 if not enemy else PI)
	if enemy: return
	# Multi shots
	if Progress.has(Power.ID.DIAMS_8):
		shoot_bullet(Values.D8_DIAGONAL_SHOT_ANGLE)
		shoot_bullet(-Values.D8_DIAGONAL_SHOT_ANGLE)
	if Progress.has(Power.ID.SPADES_7) and Progress.unlucky:
		shoot_bullet(Values.S7_TRIPLE_SHOT_ANGLE)
		shoot_bullet(-Values.S7_TRIPLE_SHOT_ANGLE)


func shoot_bullet(angle: float) -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.enemy = enemy
	bullet.damage = get_damage()
	bullet.global_position = shots_anchor.global_position
	bullet.dir = Vector2.from_angle(angle)
	Util.shots_node.add_child(bullet)


func do_hit(area: Area2D) -> void:
	if Util.check_oob(area.global_position, 0): return
	if hit_invul: return

	# Damage
	var parent = area.get_parent()
	if parent is Bullet:
		damage(parent.damage)
		if parent.missile and not parent.boom:
			parent.boom = true
			var e = Util.enemy_node.get_children()
			var a = Values.MISSILE_DAMAGE_AREA
			if Progress.has(Power.ID.SPADES_4):
				a *= Values.S4_MISSILE_RADIUS_RATIO
			var hit_e = e.filter(func(n: Node): return n is Spaceship and n != self and global_position.distance_to(n.global_position) <= a)
			for hit_enemy: Spaceship in hit_e:
				hit_enemy.do_hit(area)
			
		parent.queue_free()
	elif parent is Spaceship:
		damage(parent.get_damage())
		parent.damage(get_damage())


func evade() -> bool:
	return Progress.has(Power.ID.HEARTS_1) and \
		randf() < Values.H1_DODGE_CHANCE_PER_UNLUCK * Progress.get_bad_luck()


func damage(value: int) -> void:
	if hit_invul: return
	if not enemy:
		if evade():
			Signals.evade_damage.emit()
			return
		hit_invul = true
	hp = max(0, hp - value)
	if not enemy: Progress.hull = hp
	
	if enemy and hp == 0:
		(self as Enemy).particles.emitting = true
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
	
	if enemy and hp == 0:
		# HACK: particles have time to die before queue_free
		blinker.blink_step *= 4
		
	blinker.hit()
	hp_changed.emit(self)


func blink_over() -> void:
	hit_invul = false
	if hp == 0:
		if enemy:
			Signals.enemy_dead.emit(self)
			if self is Boss:
				Signals.boss_defeated.emit()
			queue_free()
			# TODO: enemy death animation
		else:
			if Progress.ankh:
				Progress.ankh = false
				Progress.hull = ceil(Progress.max_hull * Values.H8_REVIVE_REPAIR_RATIO)
				hp = Progress.hull
				Signals.consume_ankh.emit()
				hp_changed.emit(self)
			else:
				visible = false
				# TODO: player death animation
				await Util.wait(2.0)
				Signals.change_scene.emit(Util.Scenes.GAME_OVER)


func create_timer() -> void:
	shots_timer = Timer.new()
	shots_timer.autostart = true
	shots_timer.one_shot = false
	shots_timer.wait_time = Values.SHIP_SHOT_DELAY
	shots_timer.timeout.connect(shoot)
	add_child(shots_timer)
