@warning_ignore_start("unused_signal")
extends Node

# ———— STATES ————
signal change_scene(new_scene: Util.Scenes)

# —————— UI ——————
signal palette_changed(c: Array[Color])

# ———— SPACE —————
signal wave_ended()
signal enemy_spawned()
signal enemy_dead()
signal enemy_escaped()
signal evade_damage()

# ———— CARDS —————
signal stat_changed(stat: Progress.Stat, n: int)

@warning_ignore_restore("unused_signal")
