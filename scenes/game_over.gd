extends Node2D

const CARD = preload("uid://nbf4axea4lmp")

@onready var cards: Node2D = $cards
@onready var progress: HBoxContainer = $progress
@onready var status: Label = $status
@onready var stats: Label = $stats

var cards_drawn: bool = false


func _ready() -> void:
	# Progress
	for i in range(progress.get_children().size()):
		if i <= 2 * Progress.stage:
			progress.get_child(i).modulate = Palettes.GRAY[3]
		else:
			progress.get_child(i).modulate = Palettes.GRAY[1]
	
	status.text = "BOSS DEFEATED!" if Progress.boss_defeated else "YOU DIED :("
	stats.text = "Enemies killed: %s\nShield usages: %s\nMissile usages: %s" % [Progress.total_killed, Progress.shield_usages, Progress.missile_usages]
	
	# Cards
	await Util.wait(Values.TRANSITION_COLOR_DELAY * 3)
	for i in range(7):
		await Util.wait(Values.GAME_OVER_CARD_DELAY)
		var card: Card = CARD.instantiate()
		if Progress.powerups.size() > i:
			card.power = Progress.powerups[i]
			card.outline = false
		else:
			card.outline = true
		card.position = Vector2(18 * i, 24)
		cards.add_child(card)
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector2(18 * i, 0), 0.05)
		tween.set_ease(Tween.EASE_IN)
		tween.play()
	cards_drawn = true


func _process(_delta: float) -> void:
	if not cards_drawn: return
	if Util.block_input: return
	
	if Input.is_action_just_pressed("a"):
		Signals.change_scene.emit(Util.Scenes.TITLE)
