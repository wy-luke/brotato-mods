class_name DmgPerPlayerContainer
extends VBoxContainer

onready var wave_container: HBoxContainer = $Wave
onready var total_container: HBoxContainer = $Total

onready var wave_damage_label: Label = $Wave/Value
onready var total_damage_label: Label = $Total/Value

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
	wave_container.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END
	total_container.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END

func _update_display() -> void:
	var player_count = RunData.get_player_count()
	if player_index == -1 or player_index >= player_count:
		return

	var wave_damage = RunData.player_damage[player_index]
	var total_damage = RunData.player_damage_total[player_index]

	if player_count <= 1:
		wave_damage_label.text = str(wave_damage)
		total_damage_label.text = str(total_damage)
		return

	var wave_damage_all_players = 0
	var total_damage_all_players = 0
	for i in range(player_count):
		wave_damage_all_players += RunData.player_damage[i]
		total_damage_all_players += RunData.player_damage_total[i]
	
	_set_label_text(wave_damage_label, wave_damage, wave_damage_all_players)
	_set_label_text(total_damage_label, total_damage, total_damage_all_players)


func _set_label_text(label: Label, damage: int, total_damage: int) -> void:
	var percentage = 0
	if total_damage > 0:
		percentage = int(float(damage) / total_damage * 100)
	
	label.text = "%s (%s%%)" % [damage, percentage]
