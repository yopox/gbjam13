@warning_ignore_start("unused_signal")
extends Node

# ———— STATES ————
signal change_scene(new_scene: Util.Scenes)

# —————— UI ——————
signal palette_changed(c: Array[Color])

# ———— SPACE —————
signal unlucky_wave()
signal waves_ended(stage: int)
signal force_cards()
signal enemy_spawned()
signal enemy_dead()
signal enemy_escaped()
signal evade_damage()
signal consume_ankh()
signal boss_spawned(boss: Boss)
signal boss_defeated()

# ———— CARDS —————
signal stat_changed(stat: Progress.Stat, n: int)

@warning_ignore_restore("unused_signal")
