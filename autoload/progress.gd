extends Node

enum Stat { HULL, DAMAGE, SPEED, SHOT_SPEED, SHOT_DELAY, UNLUCK }

var powerups: Array[Power.ID] = []
var powerups_h: Dictionary = {}
var stage: int = 0
var boss_defeated: bool = false
var shield_usages: int = 0
var missile_usages: int = 0

var bad_luck: int = 0
var max_hull: int = Values.SHIP_HULL
var hull: int = max_hull
var ankh: bool = false

var damage_boost: float = 0
var shot_delay_ratio: float = 1
var shot_speed_boost: float = 0
var speed_boost: float = 0

var last_total: Dictionary = {}
var last_killed: Dictionary = {}
var total_killed: int = 0

var unlucky_wave: int = -1
var unlucky: bool = false
var unlucky_timestamp: float = 0

var shield_ready: bool = true
var shield_timer: Timer
var shield_reload: Timer

var missile_ready: bool = true
var missile_reload: Timer


func _ready() -> void:
	Signals.unlucky_wave.connect(func(): unlucky_timestamp = Time.get_ticks_msec())


func reset() -> void:
	powerups = []
	powerups_h = {}
	stage = 0
	boss_defeated = false
	shield_usages = 0
	missile_usages = 0

	bad_luck = 0
	max_hull = Values.SHIP_HULL
	hull = max_hull
	ankh = false

	damage_boost = 0
	shot_delay_ratio = 1
	shot_speed_boost = 0
	speed_boost = 0

	last_total.clear()
	last_killed.clear()
	total_killed = 0

	unlucky_wave = -1
	unlucky = false
	shield_ready = true
	missile_ready = true
	Util.enemy_id_count = 0


func add_powerup(power: Power.ID) -> void:
	powerups.append(power)
	powerups_h[power] = true
	increase_stats(power)


func has(power: Power.ID) -> bool:
	return powerups_h.has(power)


func get_bad_luck() -> int:
	var b = 0
	if has(Power.ID.CLUBS_7) and unlucky: b += 1
	return bad_luck + b


func increase_stats(power: Power.ID) -> void:
	# Bad Luck
	if Power.power_number(power) == 2: increase_stat(Stat.UNLUCK, 2)
	elif Power.power_number(power) == 3: increase_stat(Stat.UNLUCK, 1)

	# HULL
	match power:
		Power.ID.SPADES_5:
			damage_boost += Values.S5_DAMAGE_UP
			increase_stat(Stat.DAMAGE, 0)
		Power.ID.CLUBS_5: increase_stat(Stat.SPEED, 1)
		Power.ID.CLUBS_6: increase_stat(Stat.UNLUCK, Values.C6_UNLUCK_UP)
		Power.ID.CLUBS_8:
			var stats = Stat.values()
			stats.shuffle()
			increase_stat(stats[0], 1)
			increase_stat(stats[1], 1)
		Power.ID.HEARTS_8: ankh = true
		Power.ID.DIAMS_4: increase_stat(Stat.SHOT_SPEED, 1)
		Power.ID.DIAMS_5: increase_stat(Stat.SHOT_DELAY, 1)
		Power.ID.DIAMS_8: increase_stat(Stat.DAMAGE, -1)


func increase_stat(stat: Stat, n: int) -> void:
	if n == 0: return
	Signals.stat_changed.emit(stat, n)
	match stat:
		Stat.HULL:
			max_hull += Values.H5_HULL_UP * n
			hull += Values.H5_HULL_UP * n
		Stat.DAMAGE:
			damage_boost += Values.S5_DAMAGE_UP * n
		Stat.SHOT_DELAY:
			if n > 0:
				shot_delay_ratio *= Values.D5_SHOT_DELAY_DOWN_RATIO ** n
			else:
				shot_delay_ratio /= Values.D5_SHOT_DELAY_DOWN_RATIO ** n
		Stat.SHOT_SPEED:
			shot_speed_boost += Values.D4_SHOT_SPEED_UP * n
		Stat.SPEED:
			speed_boost += Values.C5_SPEED_UP * n
		Stat.UNLUCK:
			bad_luck += n
