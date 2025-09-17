extends Node2D

@onready var card_1: Card = $card
@onready var card_2: Card = $card2
@onready var card_3: Card = $card3
@onready var card_4: Card = $card4
@onready var hand: Sprite2D = $hand
@onready var power_name: Label = $power_name
@onready var description: Label = $description

var selected: int = 0


func _ready() -> void:
	draft()
	update()


func draft() -> void:
	var cards = [card_1, card_2, card_3, card_4]
	cards[0].power = Power.STATS_UP.pick_random()
	cards[1].power = Power.ID.values().pick_random()
	cards[2].power = Power.ID.values().pick_random()
	cards[3].power = Power.UNLUCKY.pick_random()
	
	for i in range(4):
		cards[i].update()


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
	if not cards[selected].outline:
		var info = Power.power_info(cards[selected].power)
		power_name.text = info[0]
		description.text = info[1]
	else:
		power_name.text = "LOCKED"
		description.text = "Defeat more enemies\nto unlock"
