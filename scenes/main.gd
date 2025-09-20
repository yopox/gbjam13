class_name Main extends Node2D

const SPLASH: Resource = preload("uid://hytftmprg71q")
const TITLE: Resource = preload("uid://cwhuna3qm1jd")
const SPACE: Resource = preload("uid://02yhbniiagkv")
const CARDS: Resource = preload("uid://c3eemnq8ueupf")

@onready var color_rect: ColorRect = $canvas/rect
@onready var scene_node: Node = $scene

var palette: Array[Color]
var scene: Util.Scenes = Util.Scenes.SPLASH
var shader: ShaderMaterial
var initial: bool = true


func _ready() -> void:
	shader = color_rect.material as ShaderMaterial
	Signals.palette_changed.connect(palette_changed)
	Signals.change_scene.connect(change_scene)
	palette_changed(Palettes.DMG, true)
	change_scene(scene)


func get_scene(s: Util.Scenes) -> Resource:
	match s:
		Util.Scenes.SPLASH: return SPLASH
		Util.Scenes.SPACE: return SPACE
		Util.Scenes.CARDS: return CARDS
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
		var p = palette
		palette_changed([p[0], p[1], p[2], p[2]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.5)
		palette_changed([p[0], p[1], p[1], p[1]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY)
		palette_changed([p[0], p[0], p[0], p[0]], false)
		for node in scene_node.get_children():
			node.queue_free()
		scene_node.add_child(s_node)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.5)
		palette_changed([p[0], p[1], p[1], p[1]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY * 1.25)
		palette_changed([p[0], p[1], p[2], p[2]], false)
		await Util.wait(Values.TRANSITION_COLOR_DELAY)
		palette_changed([p[0], p[1], p[2], p[3]], false)
		Util.block_input = false


func palette_changed(c: Array[Color], save: bool) -> void:
	if save: palette = c
	shader.set_shader_parameter("c1", c[0])
	shader.set_shader_parameter("c2", c[1])
	shader.set_shader_parameter("c3", c[2])
	shader.set_shader_parameter("c4", c[3])
