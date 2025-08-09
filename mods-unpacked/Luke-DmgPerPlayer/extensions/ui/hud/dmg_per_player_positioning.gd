# 继承自 "res://ui/hud/player_ui_elements.gd"
extends "res://ui/hud/player_ui_elements.gd"

# 设置HUD的位置
func set_hud_position(position_index: int) -> void:
	# 调用原始函数
	.set_hud_position(position_index)
	# 扩展
	# 判断是否在底部
	var bottom = position_index > 1
	# 获取伤害统计容器
	var dmg_per_player_container = hud_container.get_node("DmgPerPlayerContainerP%s" % str(player_index + 1))
	# 如果在底部，则将伤害统计容器移动到最前面
	if bottom:
		hud_container.move_child(dmg_per_player_container, 0)