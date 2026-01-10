extends "res://singletons/run_data.gd"

var player_damage: Array = [0, 0, 0, 0]
var player_damage_total: Array = [0, 0, 0, 0]

func reset(restart: bool = false):
	player_damage = [0, 0, 0, 0]
	player_damage_total = [0, 0, 0, 0]
	.reset(restart)

func on_wave_start(timer: WaveTimer) -> void:
	player_damage = [0, 0, 0, 0]
	.on_wave_start(timer)