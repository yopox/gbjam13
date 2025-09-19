extends Node

enum Stat { HULL, DAMAGE, SPEED, SHOT_SPEED, SHOT_DELAY, UNLUCK }

var powerups: Array[Power.ID] = []
var powerups_h: Dictionary = {}
var stage: int = 0

var bad_luck: int = 0
var max_hull: int = Values.SHIP_HULL
var damage_boost: float = 0
var shot_delay_ratio: float = 1
var shot_speed_boost: float = 0
var speed_boost: float = 0

var last_total: int = 0
var last_killed: int = 0
var total_killed: int = 0

var unlucky_wave: int = -1
var unlucky: bool = false
var unlucky_timestamp: float = 0

var shield_ready: bool = true
var missile_ready: bool = true


func _ready() -> void:
	Signals.unlucky_wave.connect(func(): unlucky_timestamp = Time.get_ticks_msec())


func reset() -> void:
	powerups = []
	stage = 0
	bad_luck = 0
	max_hull = Values.SHIP_HULL
	damage_boost = 0
	shot_speed_boost = 0
	speed_boost = 0
	unlucky = false


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
			increase_stat(stats[2], 1)
			increase_stat(stats[3], -1)
		Power.ID.DIAMS_4: increase_stat(Stat.SHOT_SPEED, 1)
		Power.ID.DIAMS_5: increase_stat(Stat.SHOT_DELAY, 1)


func increase_stat(stat: Stat, n: int) -> void:
	if n == 0: return
	Signals.stat_changed.emit(stat, n)
	match stat:
		Stat.HULL:
			max_hull += Values.H5_HULL_UP * n
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
