class_name TotalDmgDisplay
extends VBoxContainer

onready var wave_value_label: Label = $Wave/Value
onready var total_value_label: Label = $Total/Value


var player_index: int
var wave_start_value: Dictionary = {}

# 物品（除炮塔）或角色记录的是总伤害，所以需要回合开始时的数值计算本回合的伤害
func track_item(item: ItemParentData, index: int) -> void:
	player_index = index
	if [Category.ITEM, Category.CHARACTER].has(item.get_category()) && not item.name == "ITEM_BUILDER_TURRET":
		wave_start_value[item.my_id] = RunData.tracked_item_effects[player_index][item.my_id]


func get_item_dmg_dealt(item: ItemParentData) -> int:
	if item.get_category() == Category.WEAPON:
		return item.dmg_dealt_last_wave
	else:
		var start_value = 0
		if wave_start_value.has(item.my_id):
			start_value = wave_start_value[item.my_id]
		return RunData.tracked_item_effects[player_index][item.my_id] - start_value

func set_total_damage(damage: int) -> void:
	wave_value_label.text = Text.get_formatted_number(damage)
	total_value_label.text = Text.get_formatted_number(damage)

func set_hud_position(position_index: int) -> void:
	var left = position_index == 0 or position_index == 2
	self.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END
