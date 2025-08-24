extends HBoxContainer

onready var index_label: Label = $IndexLabel
onready var wave_label: Label = $WaveLabel
onready var total_label: Label = $TotalLabel


func set_player_index(index: int) -> void:
	index_label.text = "玩家 %s" % index


func update_values(wave_damage: int, wave_percentage: int, total_damage: int, total_percentage: int) -> void:
	wave_label.text = str(wave_damage) + " (%s%%)" % wave_percentage
	total_label.text = str(total_damage) + " (%s%%)" % total_percentage
