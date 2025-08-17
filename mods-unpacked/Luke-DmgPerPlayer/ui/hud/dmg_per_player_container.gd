class_name DmgPerPlayerContainer
extends VBoxContainer

onready var wave_value_label: Label = $Wave/Value
onready var total_value_label: Label = $Total/Value

var player_index: int = -1

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = false
	timer.connect("timeout", self, "_update_display")
	add_child(timer)
	timer.start()

func init(p_index: int) -> void:
	player_index = p_index

	var left = p_index == 0 or p_index == 2
	self.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END

func _update_display() -> void:
	if player_index == -1 or player_index >= RunData.get_player_count():
		return

	if RunData.get_player_count() > 1:
		var total_wave_damage = 0
		for i in RunData.get_player_count():
			total_wave_damage += RunData.player_damage[i]

		var wave_percentage = 0
		if total_wave_damage > 0:
			wave_percentage = int(float(RunData.player_damage[player_index]) / total_wave_damage * 100)
		
		wave_value_label.text = "%s (%s%%)" % [RunData.player_damage[player_index], wave_percentage]

		var total_damage_all_players = 0
		for i in RunData.get_player_count():
			total_damage_all_players += RunData.player_damage_total[i]
		
		var total_percentage = 0
		if total_damage_all_players > 0:
			total_percentage = int(float(RunData.player_damage_total[player_index]) / total_damage_all_players * 100)

		total_value_label.text = "%s (%s%%)" % [RunData.player_damage_total[player_index], total_percentage]
	else:
		wave_value_label.text = str(RunData.player_damage[player_index])
		total_value_label.text = str(RunData.player_damage_total[player_index])
