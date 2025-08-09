# 继承自 "res://ui/hud/ui_wave_timer.gd"
extends "res://ui/hud/ui_wave_timer.gd"


# HUD节点的引用
onready var _hud = get_tree().get_current_scene().get_node("UI/HUD")
# 伤害统计计时器
var dmg_per_player_timer: Timer = null
# 隐藏伤害统计计时器
var hide_dmg_per_player_timer: Timer = null
# 伤害统计容器数组
onready var dmg_per_player_containers: Array = []

# 当节点准备好时调用
func _ready() -> void:
	# 注册伤害统计计时器
	dmg_per_player_register_timers()
	# 初始化伤害统计容器数组
	dmg_per_player_containers = []
	# 获取玩家数量
	var player_count = RunData.get_player_count()
	# 遍历所有玩家
	for i in player_count:
		# 获取玩家索引字符串
		var player_index = str(i + 1)
		# 获取伤害统计容器
		var dmg_per_player_container = _hud.get_node("LifeContainerP%s/DmgPerPlayerContainerP%s" % [player_index, player_index])
		# 将伤害统计容器添加到数组中
		dmg_per_player_containers.append(dmg_per_player_container)
		# 设置伤害统计容器的元素
		dmg_per_player_containers[i].set_elements(RunData.get_player_weapons(i), i, player_count, true)
		# 遍历玩家的物品
		for el in RunData.get_player_items(i):
			# 如果物品不在伤害统计容器中，并且需要追踪伤害或者物品是炮塔
			if not dmg_per_player_containers[i].items.has(el.my_id) && el.tracking_text == "DAMAGE_DEALT" || el.name == "ITEM_BUILDER_TURRET":
				# 向伤害统计容器中添加元素
				dmg_per_player_containers[i].add_element(el, i)
	# 更新伤害统计
	dmg_per_player_update()

# 注册伤害统计计时器
func dmg_per_player_register_timers():
	# 创建新的计时器
	dmg_per_player_timer = Timer.new()
	# 如果计时器没有连接 "timeout" 信号，则连接
	if not dmg_per_player_timer.is_connected("timeout", self, "dmg_per_player_update"):
		var _discarded = dmg_per_player_timer.connect("timeout", self, "dmg_per_player_update")
	# 设置计时器为非一次性
	dmg_per_player_timer.one_shot = false
	# 设置计时器等待时间为0.5秒
	dmg_per_player_timer.wait_time = 0.5
	# 将计时器添加为子节点
	add_child(dmg_per_player_timer)
	# 启动计时器
	dmg_per_player_timer.start()
	
	# 创建新的隐藏计时器
	hide_dmg_per_player_timer = Timer.new()
	# 如果隐藏计时器没有连接 "timeout" 信号，则连接
	if not hide_dmg_per_player_timer.is_connected("timeout", self, "dmg_per_player_hide"):
		var _discarded = hide_dmg_per_player_timer.connect("timeout", self, "dmg_per_player_hide")
	# 设置隐藏计时器为一次性
	hide_dmg_per_player_timer.one_shot = true
	# 设置隐藏计时器等待时间为2秒
	hide_dmg_per_player_timer.wait_time = 2
	# 将隐藏计时器添加为子节点
	add_child(hide_dmg_per_player_timer)

# 更新伤害统计
func dmg_per_player_update():
	# 如果波数计时器存在且有效
	if wave_timer != null and is_instance_valid(wave_timer):
		# 获取剩余时间
		var time = ceil(wave_timer.time_left)
		# 如果剩余时间大于0
		if time > 0:
			# 遍历所有玩家
			for i in RunData.get_player_count():
				# 显示伤害统计容器
				dmg_per_player_containers[i].visible = true
				# 触发元素更新
				dmg_per_player_containers[i].trigger_element_updates()
		# 如果剩余时间小于等于0
		else:
			# 启动隐藏计时器
			hide_dmg_per_player_timer.start()
			# 停止伤害统计计时器
			dmg_per_player_timer.stop()
		# 返回
		return

# 隐藏伤害统计
func dmg_per_player_hide():
	# 遍历所有玩家
	for i in RunData.get_player_count():
		# 隐藏伤害统计容器
		dmg_per_player_containers[i].visible = false
