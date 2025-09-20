class_name Boss extends Spaceship


func _ready() -> void:
	max_hp = Values.BOSS_HP
	hp = Values.BOSS_HP
	
	Signals.boss_spawned.emit(self)
	blinker.blink_over.connect(blink_over)
	hitbox.area_entered.connect(do_hit)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Util.right(-48, 0.5), 0.5)
	tween.play()
	await tween.finished


func get_damage() -> int:
	return Values.BOSS_DAMAGE
