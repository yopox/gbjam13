extends Node2D

@onready var card_1: Card = $card
@onready var card_2: Card = $card2
@onready var card_3: Card = $card3
@onready var card_4: Card = $card4
@onready var hand: Sprite2D = $hand

var selected: int = 0


func _ready() -> void:
	update()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		selected = posmod(selected + 1, 4)
	elif Input.is_action_just_pressed("left"):
		selected = posmod(selected - 1, 4)
	update()


func update():
	var cards = [card_1, card_2, card_3, card_4]
	for i in range(4):
		cards[i].position.y = 66 if selected == i else 68
	hand.position.x = 44 + 24 * selected
