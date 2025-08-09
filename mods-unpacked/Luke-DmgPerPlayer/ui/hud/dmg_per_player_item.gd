# 类名 DmgPerPlayerItem
class_name DmgPerPlayerItem
# 继承自 HBoxContainer
extends HBoxContainer

# 物品数据
var item: ItemParentData
# 玩家索引
var player_index: int
# 伤害标签
onready var dmg_label: Label = $Label
# 图标面板
onready var icon_panel: Panel = $IconPanel
# 图标
onready var icon: TextureRect = $IconPanel/Icon
# 回合开始时的数值
var wave_start_value: int = 0


# 设置元素
func set_element(item_data: ItemParentData, index: int) -> void:
	# 设置物品数据
	item = item_data
	# 设置玩家索引
	player_index = index
	# 设置图标纹理
	icon.texture = item_data.icon
	# 设置HUD位置
	set_hud_position(player_index)
	# 更新背景颜色
	update_background_color()
	# 如果是物品或角色，并且不是炮塔，则记录回合开始时的数值
	if [Category.ITEM, Category.CHARACTER].has(item.get_category()) && not item.name == "ITEM_BUILDER_TURRET":
		wave_start_value = RunData.tracked_item_effects[player_index][item.my_id]


# 设置HUD位置
func set_hud_position(position_index: int) -> void:
	# 判断是否在左边
	var left = position_index == 0 or position_index == 2
	# 根据位置设置对齐方式
	self.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END
	# 根据位置移动伤害标签
	self.move_child(dmg_label, icon_panel.get_index() + 1 if left else 0)


# 更新背景颜色
func update_background_color() -> void:
	# 移除样式覆盖
	remove_stylebox_override("panel")
	# 如果物品为空，则返回
	if item == null:
		return
	# 复制样式盒
	var stylebox = icon_panel.get_stylebox("panel").duplicate()
	# 根据物品等级改变样式盒
	ItemService.change_inventory_element_stylebox_from_tier(stylebox, item.tier, 0.3)
	# 添加样式盒覆盖
	icon_panel.add_stylebox_override("panel", stylebox)
	# 更新样式盒
	icon_panel._update_stylebox(item.is_cursed)

# 获取造成的伤害
func get_dmg_dealt() -> int:
	# 如果是武器，则返回上一波造成的伤害
	if item.get_category() == Category.WEAPON:
		return item.dmg_dealt_last_wave
	# 否则返回当前追踪的物品效果减去回合开始时的数值
	else:
		return RunData.tracked_item_effects[player_index][item.my_id] - wave_start_value

# 触发更新
func trigger_update() -> void:
	# 更新伤害标签的文本
	dmg_label.text = Text.get_formatted_number(get_dmg_dealt())
