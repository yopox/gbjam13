@warning_ignore_start("unused_signal")
extends Node

# ———— STATES ————
signal change_scene(new_scene: Util.Scenes)
signal transition(appear: bool, step: int)

# —————— UI ——————
signal palette_changed(c: Array[Color])
signal send_notification(text: String)

# ———— AUDIO —————
signal play_sfx(sfx: Sfx.SFX)

# ———— SPACE —————
signal starfield_speed(ratio: float)
signal unlucky_wave()
signal unlucky_over()
signal waves_ended(stage: int)
signal force_cards()
signal enemy_spawned(enemy: Enemy)
signal enemy_dead(enemy: Enemy)
signal enemy_escaped()
signal evade_damage()
signal consume_ankh()
signal boss_spawned(boss: Boss)
signal boss_reinforcement(boss_pos: Vector2)
signal boss_defeated()

# ———— CARDS —————
signal stat_changed(stat: Progress.Stat, n: int)

@warning_ignore_restore("unused_signal")
