extends Node2D

@onready var progress: HBoxContainer = $progress
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
	for i in range(progress.get_children().size()):
		if i <= 2 * Progress.stage:
			progress.get_child(i).modulate = Palettes.GRAY[3]
		else:
			progress.get_child(i).modulate = Palettes.GRAY[1]


func draft() -> void:
	var cards = [card_1, card_2, card_3, card_4]

	if Util.current_mode == Util.GameMode.REGULAR:
		regular_draft()
	else:
		infinite_draft()

	if Util.current_mode == Util.GameMode.REGULAR and Progress.stage > 0 and not Progress.has(Power.ID.CLUBS_9):
		cards[0].outline = Progress.last_killed.size() * 4 < Progress.last_total.size()
		cards[3].outline = Progress.last_killed.size() * 1.5 < Progress.last_total.size()
	else:
		cards[0].outline = false
		cards[3].outline = false

	for i in range(4):
		cards[i].update()


func regular_draft() -> void:
	if Progress.stage == 0:
		card_1.power = Power.pick_random_unlucky_only([])
		card_2.power = Power.pick_random_unlucky_only([card_1.power])
		card_3.power = Power.pick_random_unlucky_only([card_1.power, card_2.power])
		card_4.power = Power.pick_random_unlucky_only([card_1.power, card_2.power, card_3.power])
	else:
		card_1.power = Power.pick_random_stat([])
		card_2.power = Power.pick_random([card_1.power])
		card_3.power = Power.pick_random([card_1.power, card_2.power])
		card_4.power = Power.pick_random_unlucky([card_1.power, card_2.power, card_3.power])


func infinite_draft() -> void:
	if Progress.stage == 0:
		var ban: Array[Power.ID] = Power.INFINITE_BAN.duplicate()
		card_1.power = Power.pick_random_unlucky_only(ban)
		ban.append(card_1.power)
		card_2.power = Power.pick_random_unlucky_only(ban)
		ban.append(card_2.power)
		card_3.power = Power.pick_random_unlucky_only(ban)
		ban.append(card_3.power)
		card_4.power = Power.pick_random_unlucky_only(ban)
	else:
		var ban: Array[Power.ID] = Power.INFINITE_BAN.duplicate()
		card_1.power = Power.pick_random_stat(ban)
		ban.append(card_1.power)
		card_2.power = Power.pick_random(ban)
		ban.append(card_2.power)
		card_3.power = Power.pick_random(ban)
		ban.append(card_3.power)
		card_4.power = Power.pick_random_unlucky(ban)


func _process(_delta: float) -> void:
	if Util.block_input:
		update()
		return

	if Input.is_action_just_pressed("right"):
		selected = posmod(selected + 1, 4)
		Signals.play_sfx.emit(Sfx.SFX.MOVE)
	elif Input.is_action_just_pressed("left"):
		selected = posmod(selected - 1, 4)
		Signals.play_sfx.emit(Sfx.SFX.MOVE)
	update()

	if Input.is_action_just_pressed("a"):
		var cards: Array[Card] = [card_1, card_2, card_3, card_4]
		if cards[selected].outline: return
		Signals.play_sfx.emit(Sfx.SFX.SELECT)
		Progress.add_powerup(cards[selected].power)
		Progress.stage += 1

		# Heal player
		Progress.hull = min(Progress.hull + Progress.max_hull * Values.HEAL_AFTER_STAGE_RATIO, Progress.max_hull)

		if Util.current_mode == Util.GameMode.DRAFT_7 and Progress.powerups.size() < 7:
			Signals.change_scene.emit(Util.Scenes.CARDS)
		else:
			Signals.change_scene.emit(Util.Scenes.SPACE)
	elif Input.is_action_just_pressed("b"):
		Signals.change_scene.emit(Util.Scenes.TITLE)


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
		@warning_ignore("integer_division")
		var p: int = Progress.last_killed.size() * 100 / max(1, Progress.last_total.size())
		if selected == 0:
			description.text = "Defeat 25% of all enemies\nto unlock. (" + str(p) + "%)"
		else:
			description.text = "Defeat 66% of all enemies\nto unlock. (" + str(p) + "%)"
