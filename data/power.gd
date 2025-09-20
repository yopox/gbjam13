@tool
extends Node

enum ID {
	SPADES_1, SPADES_2, SPADES_3, SPADES_4, SPADES_5, SPADES_6, SPADES_7, SPADES_8, SPADES_9,
	HEARTS_1, HEARTS_2, HEARTS_3, HEARTS_4, HEARTS_5, HEARTS_6, HEARTS_7, HEARTS_8, HEARTS_9,
	DIAMS_1, DIAMS_2, DIAMS_3, DIAMS_4, DIAMS_5, DIAMS_6, DIAMS_7, DIAMS_8, DIAMS_9,
	CLUBS_1, CLUBS_2, CLUBS_3, CLUBS_4, CLUBS_5, CLUBS_6, CLUBS_7, CLUBS_8, CLUBS_9
}

var STATS_UP: Array[ID] = [ID.SPADES_5, ID.HEARTS_5, ID.DIAMS_5, ID.CLUBS_5]
var UNLUCKY: Array[ID] = [
	ID.SPADES_1, ID.SPADES_7, ID.SPADES_2, ID.SPADES_3,
	ID.HEARTS_1, ID.HEARTS_7, ID.HEARTS_2, ID.HEARTS_3,
	ID.DIAMS_1, ID.DIAMS_7, ID.DIAMS_2, ID.DIAMS_3,
	ID.CLUBS_1, ID.CLUBS_7, ID.CLUBS_2, ID.CLUBS_3,
]

var UNLUCKY_ONLY: Array[ID] = [
	ID.SPADES_2, ID.SPADES_3, ID.HEARTS_2, ID.HEARTS_3,
	ID.DIAMS_2, ID.DIAMS_3, ID.CLUBS_2, ID.CLUBS_3,
]


func pick_random(exclude: Array[ID]) -> ID:
	var power = ID.values().pick_random()
	while power in exclude or power in Progress.powerups:
		power = ID.values().pick_random()
	return power


func pick_random_stat(exclude: Array[ID]) -> ID:
	var power = STATS_UP.pick_random()
	while power in exclude: # ok to repeat stat up powerups
		power = STATS_UP.pick_random()
	return power


func pick_random_unlucky(exclude: Array[ID]) -> ID:
	var power = UNLUCKY.pick_random()
	while power in exclude or power in Progress.powerups:
		power = UNLUCKY.pick_random()
	return power


func pick_random_unlucky_only(exclude: Array[ID]) -> ID:
	var power = UNLUCKY_ONLY.pick_random()
	while power in exclude or power in Progress.powerups:
		power = UNLUCKY_ONLY.pick_random()
	return power


func power_info(id: ID) -> Array[String]:
	match id:
		ID.SPADES_1: return ["Ace of Spades", "Bad Luck = damage up"]
		ID.SPADES_2: return ["Two of Spades", "Bad Luck +2\n[UNLUCKY]: Can't shoot for 5s"]
		ID.SPADES_3: return ["Three of Spades", "Bad Luck +1\n[UNLUCKY]: Enemy damage up"]
		ID.SPADES_4: return ["Four of Spades", "Increase missile area"]
		ID.SPADES_5: return ["Five of Spades", "Damage up"]
		ID.SPADES_6: return ["Six of Spades", "Damage up for each\nmissing hull point"]
		ID.SPADES_7: return ["Seven of Spades", "[UNLUCKY]: Triple shot"]
		ID.SPADES_8: return ["Eight of Spades", "Damage up if shield and missile\nare charged"]
		ID.SPADES_9: return ["Nine of Spades", "Missiles have auto aim"]

		ID.CLUBS_1: return ["Ace of Clubs", "Bad Luck = double shot chance"]
		ID.CLUBS_2: return ["Two of Clubs", "Bad Luck +2\n[UNLUCKY]: Speed down"]
		ID.CLUBS_3: return ["Three of Clubs", "Bad Luck +1\n[UNLUCKY]: Enemy shot speed up"]
		ID.CLUBS_4: return ["Four of Clubs", "Shorter unlucky intervals"]
		ID.CLUBS_5: return ["Five of Clubs", "Speed up"]
		ID.CLUBS_6: return ["Six of Clubs", "Bad Luck +2"]
		ID.CLUBS_7: return ["Seven of Clubs", "[UNLUCKY]: All stats up"]
		ID.CLUBS_8: return ["Eight of Clubs", "Three random stats up,\none random stat down"]
		ID.CLUBS_9: return ["Nine of Clubs", "Always unlock all card options"]

		ID.HEARTS_1: return ["Ace of Hearts", "Bad Luck = chance to dodge damage"]
		ID.HEARTS_2: return ["Two of Hearts", "Bad Luck +2\n[UNLUCKY]: Can't shield"]
		ID.HEARTS_3: return ["Three of Hearts", "Bad Luck +1\n[UNLUCKY]: Heal enemies"]
		ID.HEARTS_4: return ["Four of Hearts", "Longer shields"]
		ID.HEARTS_5: return ["Five of Hearts", "Hull up"]
		ID.HEARTS_6: return ["Six of Hearts", "Regen 1 hull HP every 10 kills"]
		ID.HEARTS_7: return ["Seven of Hearts", "[UNLUCKY]: Recharge shields"]
		ID.HEARTS_8: return ["Eight of Hearts", "Repair 50% hull on death"]
		ID.HEARTS_9: return ["Nine of Hearts", "Shields deflect enemy shots"]

		ID.DIAMS_1: return ["Ace of Diamonds", "Bad Luck = faster reloads"]
		ID.DIAMS_2: return ["Two of Diamonds", "Bad Luck +2\n[UNLUCKY]: Imprecise shots"]
		ID.DIAMS_3: return ["Three of Diamonds", "Bad Luck +1\n[UNLUCKY]: Slower shots"]
		ID.DIAMS_4: return ["Four of Diamonds", "Shot speed up"]
		ID.DIAMS_5: return ["Five of Diamonds", "Shot frequency up"]
		ID.DIAMS_6: return ["Six of Diamonds", "Shot frequency increases every\n6 kills per wave"]
		ID.DIAMS_7: return ["Seven of Diamonds", "[UNLUCKY]: Slow enemy bullets"]
		ID.DIAMS_8: return ["Eight of Diamonds", "2 additional diagonal shots"]
		ID.DIAMS_9: return ["Nine of Diamonds", "Shots wrap around screen edges"]
	Log.err("Unknown card ID")
	return ["", ""]


func power_family(id: ID) -> Card.Family:
	match id:
		ID.SPADES_1, ID.SPADES_2, ID.SPADES_3, ID.SPADES_4, ID.SPADES_5, ID.SPADES_6, ID.SPADES_7, ID.SPADES_8, ID.SPADES_9: return Card.Family.Spade
		ID.CLUBS_1, ID.CLUBS_2, ID.CLUBS_3, ID.CLUBS_4, ID.CLUBS_5, ID.CLUBS_6, ID.CLUBS_7, ID.CLUBS_8, ID.CLUBS_9: return Card.Family.Club
		ID.DIAMS_1, ID.DIAMS_2, ID.DIAMS_3, ID.DIAMS_4, ID.DIAMS_5, ID.DIAMS_6, ID.DIAMS_7, ID.DIAMS_8, ID.DIAMS_9: return Card.Family.Diamond
		_: return Card.Family.Heart


func power_number(id: ID) -> int:
	return (id % 9) + 1
