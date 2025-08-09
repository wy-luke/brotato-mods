# 类名 DmgPerPlayerContainer
class_name DmgPerPlayerContainer
# 继承自 VBoxContainer
extends VBoxContainer

# 导出的 PackedScene 变量，用于实例化元素
export(PackedScene) var element_scene = null
# 存储物品的数组
var items = []
# 最大显示的物品数量
var max_items = 0

# 设置元素
func set_elements(elements: Array, player_index: int, player_count: int, replace: bool = true) -> void:
	# 如果玩家数量小于3，则不限制最大显示数量，否则最多显示6个
	max_items = 0 if player_count < 3 else 6
	# 如果需要替换，则清空元素
	if replace:
		clear_elements()

	# 遍历所有元素并添加
	for element in elements:
		add_element(element, player_index)


# 清空元素
func clear_elements() -> void:
	# 清空物品数组
	items = []
	# 遍历所有子节点并移除
	for n in get_children():
		remove_child(n)
		n.queue_free()


# 添加元素
func add_element(element: ItemParentData, player_index: int) -> void:
	# 如果是扳手或螺丝刀，则处理生成器
	if ["WEAPON_WRENCH", "WEAPON_SCREWDRIVER"].has(element.name):
		handle_spawner(element, player_index)
	# 将物品ID添加到数组中
	items.append(element.my_id)
	# 实例化元素场景
	var instance = element_scene.instance()
	# 将实例添加为子节点
	add_child(instance)
	# 设置实例的元素
	instance.set_element(element, player_index)


# 处理生成器
func handle_spawner(element: ItemParentData, player_index: int) -> void:
	# 根据物品名称进行匹配
	match element.name:
		"WEAPON_SCREWDRIVER":
			# 如果没有地雷，则添加地雷
			if not items.has("item_landmines"):
				add_element(ItemService.get_item_from_id("item_landmines"), player_index)
		"WEAPON_WRENCH":
			# 根据物品等级进行匹配
			match element.tier:
				Tier.COMMON:
					# 如果没有炮塔，则添加炮塔
					if not items.has("item_turret"):
						add_element(ItemService.get_item_from_id("item_turret"), player_index)
				Tier.UNCOMMON:
					# 如果没有火焰炮塔，则添加火焰炮塔
					if not items.has("item_turret_flame"):
						add_element(ItemService.get_item_from_id("item_turret_flame"), player_index)
				Tier.RARE:
					# 如果没有激光炮塔，则添加激光炮塔
					if not items.has("item_turret_laser"):
						add_element(ItemService.get_item_from_id("item_turret_laser"), player_index)
				Tier.LEGENDARY:
					# 如果没有火箭炮塔，则添加火箭炮塔
					if not items.has("item_turret_rocket"):
						add_element(ItemService.get_item_from_id("item_turret_rocket"), player_index)


# 触发元素更新
func trigger_element_updates() -> void:
	# 遍历所有子节点并触发更新
	for child in get_children():
		child.trigger_update()
	# 对元素进行排序
	sort_elements()
	# 隐藏底部的元素
	hide_bottom_elements()

# 对元素进行排序
func sort_elements() -> void:
	# 标记是否已排序
	var sorted = false
	# 当未排序时循环
	while not sorted:
		# 标记是否交换过
		var swapped = false
		# 获取所有子节点
		var children = get_children()
		# 遍历子节点进行比较和交换
		for i in children.size() - 1:
			# 如果当前元素的伤害小于下一个元素的伤害，则交换位置
			if children[i].get_dmg_dealt() < children[i + 1].get_dmg_dealt():
				move_child(children[i], i + 1)
				children = get_children()
				swapped = true
		# 如果没有发生交换，则表示已排序
		sorted = !swapped


# 隐藏底部的元素
func hide_bottom_elements() -> void:
	# 获取所有子节点
	var children = get_children()
	# 遍历所有子节点
	for i in children.size():
		# 如果未设置最大显示数量或当前索引小于最大显示数量，则显示，否则隐藏
		children[i].visible = max_items == 0 || i < max_items
