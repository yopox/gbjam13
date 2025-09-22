class_name Main extends Node2D

const SPLASH: Resource = preload("uid://hytftmprg71q")
const TITLE: Resource = preload("uid://cwhuna3qm1jd")
const SPACE: Resource = preload("uid://02yhbniiagkv")
const CARDS: Resource = preload("uid://c3eemnq8ueupf")
const GAME_OVER: Resource = preload("uid://dxvmo4dcm8i0r")

@onready var color_rect: ColorRect = $canvas/rect
@onready var scene_node: Node = $scene

var scene: Util.Scenes = Util.Scenes.SPLASH
var shader: ShaderMaterial
var initial: bool = true


func _ready() -> void:
	shader = color_rect.material as ShaderMaterial
	Signals.palette_changed.connect(palette_changed)
	Signals.change_scene.connect(change_scene)
	palette_changed(Palettes.WASHED, true)
	change_scene(scene)


func get_scene(s: Util.Scenes) -> Resource:
	match s:
		Util.Scenes.SPLASH: return SPLASH
		Util.Scenes.SPACE: return SPACE
		Util.Scenes.CARDS: return CARDS
		Util.Scenes.GAME_OVER: return GAME_OVER
		_: return TITLE


func change_scene(new_scene: Util.Scenes) -> void:
	var s = get_scene(new_scene)
	Log.info("Changing scene to", new_scene)
	var s_node = s.instantiate()
	if initial:
		scene_node.add_child(s_node)
		initial = false
	else:
		Util.block_input = true
		var p = Util.current_palette
		palette_changed([p[0], p[1], p[2], p[2]], false)
		Signals.transition.emit(false, 0)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.5)
		palette_changed([p[0], p[1], p[1], p[1]], false)
		Signals.transition.emit(false, 1)
		await Util.wait(Values.TRANSITION_COLOR_DELAY)
		palette_changed([p[0], p[0], p[0], p[0]], false)
		Signals.transition.emit(false, 2)
		for node in scene_node.get_children():
			node.queue_free()
		Engine.time_scale = 1
		if new_scene == Util.Scenes.TITLE:
			p = Palettes.WASHED
		elif new_scene == Util.Scenes.CARDS:
			if Util.current_mode == Util.GameMode.DRAFT_7:
				p = Palettes.NEXUS
		elif new_scene == Util.Scenes.SPACE:
			if Util.current_mode == Util.GameMode.REGULAR:
				if Progress.stage <= 2:
					p = Palettes.WASHED
				elif Progress.stage <= 4:
					p = Palettes.LOVED
				elif Progress.stage <= 6:
					p = Palettes.FLINTS
				else:
					p = Palettes.GRASA
		scene_node.add_child(s_node)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.5)
		Signals.transition.emit(true, 0)
		palette_changed([p[0], p[1], p[1], p[1]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.25)
		Signals.transition.emit(true, 1)
		palette_changed([p[0], p[1], p[2], p[2]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY)
		Signals.transition.emit(true, 2)
		palette_changed([p[0], p[1], p[2], p[3]], true)
		Util.block_input = false


func palette_changed(c: Array[Color], save: bool) -> void:
	if save: Util.current_palette = c
	shader.set_shader_parameter("c1", c[0])
	shader.set_shader_parameter("c2", c[1])
	shader.set_shader_parameter("c3", c[2])
	shader.set_shader_parameter("c4", c[3])
