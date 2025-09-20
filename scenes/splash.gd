extends Node2D


func _ready() -> void:
	await Util.wait(Values.SPLASH_DURATION)
	Signals.change_scene.emit(Util.Scenes.TITLE)
