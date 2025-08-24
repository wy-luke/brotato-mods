class_name DmgPerPlayerContainer
extends VBoxContainer

var player_row_scene = preload("res://mods-unpacked/Luke-DmgPerPlayer/ui/hud/player_row.tscn")
var player_rows: Array

func _ready() -> void:
	var player_count = RunData.get_player_count()
	for i in range(player_count):
		var player_row = player_row_scene.instance()
		add_child(player_row)
		player_row.set_player_index(i + 1)

		player_rows.append(player_row)

	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = false
	timer.connect("timeout", self, "_update_display")
	add_child(timer)
	timer.start()

func _update_display() -> void:
	var player_count = RunData.get_player_count()

	var all_players_wave_damage = 0
	for i in range(player_count):
		all_players_wave_damage += RunData.player_damage[i]

	var all_players_total_damage = 0
	for i in range(player_count):
		all_players_total_damage += RunData.player_damage_total[i]

	for i in range(player_count):
		var wave_damage = RunData.player_damage[i]
		var total_damage = RunData.player_damage_total[i]

		var wave_percentage = 0
		if all_players_wave_damage > 0:
			wave_percentage = int(float(wave_damage) / all_players_wave_damage * 100)

		var total_percentage = 0
		if all_players_total_damage > 0:
			total_percentage = int(float(total_damage) / all_players_total_damage * 100)

		player_rows[i].update_values(wave_damage, wave_percentage, total_damage, total_percentage)
