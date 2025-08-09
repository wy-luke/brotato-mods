# total_dmg_display.gd
class_name TotalDmgDisplay
extends HBoxContainer

onready var value_label: Label = $Value

func set_total_damage(damage: int) -> void:
	value_label.text = Text.get_formatted_number(damage)

func set_hud_position(position_index: int) -> void:
	var left = position_index == 0 or position_index == 2
	self.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END