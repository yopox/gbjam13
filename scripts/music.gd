class_name Bgm extends Node

enum BGM { TITLE, CARDS, STAGE_1, STAGE_2, STAGE_3, BOSS }

const TITLE = preload("uid://cq1qnmtqnj08h")
const BOSS_THEME = preload("uid://bl04hen1vsfkm")
const LUCKY = preload("uid://bcgp1ckqdy4h5")
const STAGE_1 = preload("uid://cptco2fqf62ue")
const STAGE_2 = preload("uid://dclpc46p71041")
const STAGE_3 = preload("uid://cypc11wwtbd00")

const FADE_IN_3: Array[float] = [0, 0, 0, 0.35, 0.65, 1.0]
const IN_3: Array[float] = [0, 0, 0, 1.0, 1.0, 1.0]
const FADE_OUT_3: Array[float] = [0.65, 0.35, 0.0, 0, 0, 0]
const FADE_IN_6: Array[float] = [0.1, 0.35, 0.5, 0.65, 0.9, 1.0]
const FADE_OUT_6: Array[float] = [0.9, 0.65, 0.5, 0.35, 0.1, 0]
const FADE_OUT_IN: Array[float] = [0.65, 0.35, 0, 1, 1, 1]

@onready var player_1: AudioStreamPlayer = $bgm
@onready var player_2: AudioStreamPlayer = $bgm2
var current_bgm: BGM = BGM.BOSS
var next_bgm: BGM


func _ready() -> void:
	Signals.change_scene.connect(prepare_next_bgm)
	Signals.transition.connect(transition)
	player_2.stream = LUCKY


func prepare_next_bgm(scene: Util.Scenes) -> void:
	match scene:
		Util.Scenes.CARDS, Util.Scenes.GAME_OVER:
			next_bgm = BGM.CARDS
		Util.Scenes.SPACE:
			if Progress.stage < 3:
				next_bgm = BGM.STAGE_1
			elif Progress.stage < 5:
				next_bgm = BGM.STAGE_2
			elif Progress.stage < 7:
				next_bgm = BGM.STAGE_3
			else:
				next_bgm = BGM.BOSS
		Util.Scenes.TITLE, _:
			next_bgm = BGM.TITLE


func transition(appear: bool, step: int) -> void:
	if current_bgm == next_bgm: return
	var i: int = index(appear, step)
	var p1_vol: Array[float]
	var p2_vol: Array[float]
	
	if next_bgm == BGM.TITLE:
		p1_vol = FADE_OUT_IN
		p2_vol = FADE_OUT_3
	elif current_bgm == BGM.TITLE and (next_bgm == BGM.CARDS):
		p1_vol = FADE_OUT_3
		p2_vol = IN_3
	elif next_bgm == BGM.CARDS:
		p1_vol = FADE_OUT_6
		p2_vol = FADE_IN_6
	else:
		p1_vol = FADE_IN_6
		p2_vol = FADE_OUT_6

	player_1.volume_linear = p1_vol[i]
	player_2.volume_linear = p2_vol[i]
	
	if i == 0:
		if current_bgm != BGM.TITLE and next_bgm == BGM.CARDS:
			player_2.play(player_1.get_playback_position())
		if current_bgm == BGM.CARDS:
			match next_bgm:
				BGM.STAGE_1: player_1.stream = STAGE_1
				BGM.STAGE_2: player_1.stream = STAGE_2
				BGM.STAGE_3: player_1.stream = STAGE_3
				BGM.BOSS: player_1.stream = BOSS_THEME
				BGM.TITLE, _: player_1.stream = TITLE
			if not next_bgm == BGM.TITLE:
				player_1.play(player_2.get_playback_position())
		
	if i == 3:
		if next_bgm == BGM.TITLE:
			player_1.stop()
			player_2.stop()
			player_1.stream = TITLE
			player_1.play()
		if current_bgm == BGM.TITLE and next_bgm == BGM.CARDS:
			player_2.play()
			player_1.stop()
	
	if i == 5:
		if current_bgm == BGM.CARDS:
			player_2.stop()
		if next_bgm == BGM.CARDS:
			player_1.stop()
		current_bgm = next_bgm
	
		
		
func index(appear: bool, step: int) -> int:
	return (3 if appear else 0) + step
	
