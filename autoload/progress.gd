extends Node

var powerups: Array[Power.ID] = []
var stage: int = 0

var last_total: int = 0
var last_killed: int = 0


func reset() -> void:
	powerups = []
	stage = 0
