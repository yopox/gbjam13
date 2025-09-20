@tool
class_name Card extends Node2D

enum Family { Spade, Diamond, Club, Heart }

@onready var bg_spr: Sprite2D = $bg
@onready var value_spr: Sprite2D = $value
@onready var family_spr: Sprite2D = $family

@export var power: Power.ID = Power.ID.SPADES_1
@export var outline: bool = false


func _ready():
	update()


func update() -> void:
	(bg_spr.texture as AtlasTexture).region.position.x = 16 if outline else 0
	value_spr.visible = not outline
	family_spr.visible = not outline
	
	if not outline:
		var value = Power.power_number(power)
		var family = Power.power_family(power)
		(value_spr.texture as AtlasTexture).region.position.x = 8 * value
		(family_spr.texture as AtlasTexture).region.position.x = 8 * (family + 1)
