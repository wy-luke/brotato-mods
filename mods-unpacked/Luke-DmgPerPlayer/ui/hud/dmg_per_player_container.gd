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

	wave_value_label.text = str(RunData.player_damage[player_index])
	total_value_label.text = str(RunData.player_damage_total[player_index])
