# 类名 DmgPerPlayerItem
class_name DmgPerPlayerItem
# 继承自 HBoxContainer
extends HBoxContainer

# 物品数据
var item: ItemParentData
# 玩家索引
var player_index: int
# 回合开始时的数值
var wave_start_value: int = 0


# 设置元素
func set_element(item_data: ItemParentData, index: int) -> void:
	# 设置物品数据
	item = item_data
	# 设置玩家索引
	player_index = index
	# 如果是物品或角色，并且不是炮塔，则记录回合开始时的数值
	if [Category.ITEM, Category.CHARACTER].has(item.get_category()) && not item.name == "ITEM_BUILDER_TURRET":
		wave_start_value = RunData.tracked_item_effects[player_index][item.my_id]

# 获取造成的伤害
func get_dmg_dealt() -> int:
	# 如果是武器，则返回上一波造成的伤害
	if item.get_category() == Category.WEAPON:
		return item.dmg_dealt_last_wave
	# 否则返回当前追踪的物品效果减去回合开始时的数值
	else:
		return RunData.tracked_item_effects[player_index][item.my_id] - wave_start_value
