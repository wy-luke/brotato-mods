extends "res://singletons/run_data.gd"

var player_damage: Array = [0, 0, 0, 0]
var player_damage_total: Array = [0, 0, 0, 0]

func reset(restart: bool = false):
	.reset(restart)
	player_damage = [0, 0, 0, 0]
	player_damage_total = [0, 0, 0, 0]

func on_wave_start():
	.on_wave_start()
	player_damage = [0, 0, 0, 0]
