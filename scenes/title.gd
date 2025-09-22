extends Node2D

@onready var logo: Label = $name
@onready var mode: Label = $mode
@onready var start: Label = $start

var timer: float = 0

func _ready() -> void:
	Signals.starfield_speed.emit(1.0)
	
	match Util.current_mode:
		Util.GameMode.REGULAR: mode.text = "[REGULAR]"
		Util.GameMode.DRAFT_7: mode.text = "[DRAFT 7]"


func _process(delta: float) -> void:
	timer += delta
	logo.position.y = 28 + sin(PI + timer)
	start.visible = fmod(timer, 1.4) > 0.7
	if Util.block_input: return
	if Input.is_action_just_pressed("select"):
		Signals.play_sfx.emit(Sfx.SFX.MOVE)
		match Util.current_mode:
			Util.GameMode.REGULAR:
				Util.current_mode = Util.GameMode.DRAFT_7
				mode.text = "[DRAFT 7]"
			Util.GameMode.DRAFT_7:
				Util.current_mode = Util.GameMode.REGULAR
				mode.text = "[REGULAR]"
				
	if Input.is_action_just_pressed("a"):
		Signals.play_sfx.emit(Sfx.SFX.SELECT)
		Progress.reset()
		Signals.change_scene.emit(Util.Scenes.CARDS)
