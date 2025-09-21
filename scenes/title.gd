extends Node2D


func _ready() -> void:
	Signals.starfield_speed.emit(1.0)


func _process(_delta: float) -> void:
	if Util.block_input: return
	if Input.is_action_just_pressed("a"):
		Signals.play_sfx.emit(Sfx.SFX.SELECT)
		Progress.reset()
		Signals.change_scene.emit(Util.Scenes.CARDS)
