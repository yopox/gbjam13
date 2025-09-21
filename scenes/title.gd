extends Node2D


func _process(_delta: float) -> void:
	if Util.block_input: return
	if Input.is_action_just_pressed("a"):
		Progress.reset()
		# TODO: switch to hangar instead
		Signals.change_scene.emit(Util.Scenes.CARDS)
