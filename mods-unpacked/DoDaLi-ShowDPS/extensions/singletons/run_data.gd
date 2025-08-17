extends "res://singletons/run_data.gd"

const BFX_LOG_RUN_DATA = "DoDaLi-ShowDPS"

var player_damage = [0, 0, 0, 0]
var player_damage_total = [0, 0, 0, 0]
var player_damage_wave = 0 # current calculate wave

func on_wave_start() -> void:
	.on_wave_start()
	ModLoaderLog.info("mod wave start :" + str(current_wave) + "," + str(player_damage_wave), BFX_LOG_RUN_DATA)
	if current_wave == player_damage_wave:
		player_damage_total[0] -= player_damage[0]
		player_damage_total[1] -= player_damage[1]
		player_damage_total[2] -= player_damage[2]
		player_damage_total[3] -= player_damage[3]
		
	player_damage_wave = current_wave
	player_damage = [0, 0, 0, 0]
	
	
func reset(restart: bool = false) -> void:
	.reset(restart)
	player_damage_wave = 0
	player_damage_total = [0, 0, 0, 0]
