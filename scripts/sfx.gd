class_name Sfx extends Node

const MOVE = preload("uid://xtfdbxlu75nc")
const SELECT = preload("uid://bpaknqqhotvm")
const SHOOT = preload("uid://0qa0yn67vf5y")
const SHIELD = preload("uid://durf2nqhp6qx5")
const MISSILE = preload("uid://xvnsj56jvee5")
const SWOOSH = preload("uid://lbk35t32wa3o")
const ENEMY_DEATH = preload("uid://c1bd0qcaasy8n")
const FLASH = preload("uid://dhtttamtou6vc")
const SHIP_DEATH = preload("uid://3kml45vv45mg")
const BOSS_DEATH = preload("uid://cge1vnhnxoejd")

enum SFX {
	MOVE, SELECT, SHOOT, SHIELD, MISSILE, SWOOSH, ENEMY_DEATH, FLASH, SHIP_DEATH, BOSS_DEATH
}


func _ready() -> void:
	Signals.play_sfx.connect(play_sfx)


func play_sfx(sfx: SFX) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = stream_for(sfx)
	player.autoplay = true
	player.volume_linear = 0.35
	add_child(player)
	await player.finished
	player.queue_free()


func stream_for(sfx: SFX) -> AudioStreamWAV:
	match sfx:
		SFX.SELECT: return SELECT
		SFX.SHOOT: return SHOOT
		SFX.MISSILE: return MISSILE
		SFX.SHIELD: return SHIELD
		SFX.SWOOSH: return SWOOSH
		SFX.ENEMY_DEATH: return ENEMY_DEATH
		SFX.FLASH: return FLASH
		SFX.SHIP_DEATH: return SHIP_DEATH
		SFX.BOSS_DEATH: return BOSS_DEATH
		SFX.MOVE, _: return MOVE
