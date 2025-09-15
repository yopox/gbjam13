class_name Main extends Node2D


const TITLE: Resource = preload("uid://cwhuna3qm1jd")
const SPACE: Resource = preload("uid://02yhbniiagkv")

@onready var color_rect: ColorRect = $canvas/rect
@onready var scene_node: Node = $scene

var scene: Util.Scenes = Util.Scenes.TITLE
var shader: ShaderMaterial


func _ready() -> void:
	shader = color_rect.material as ShaderMaterial
	Signals.palette_changed.connect(palette_changed)
	Signals.change_scene.connect(change_scene)
	change_scene(scene)
	palette_changed(Palettes.PASTEL)


func get_scene(s: Util.Scenes) -> Resource:
	match s:
		Util.Scenes.SPACE: return SPACE
		_: return TITLE


func change_scene(new_scene: Util.Scenes) -> void:
	var s = get_scene(new_scene)
	Log.info("Changing scene to", new_scene)
	var s_node = s.instantiate()
	for node in scene_node.get_children():
		node.queue_free()
	scene_node.add_child(s_node)


func palette_changed(c: Array[Color]) -> void:
	shader.set_shader_parameter("c1", c[0])
	shader.set_shader_parameter("c2", c[1])
	shader.set_shader_parameter("c3", c[2])
	shader.set_shader_parameter("c4", c[3])
