extends "res://ui/hud/ui_wave_timer.gd"

onready var _hud = get_tree().get_current_scene().get_node("UI/HUD")

var dmg_per_player_timer: Timer = null
var hide_dmg_per_player_timer: Timer = null
var dmg_per_player_containers: Array = []

func _ready() -> void:
	dmg_per_player_register_timers()
	
	dmg_per_player_containers = []
	var player_count = RunData.get_player_count()
	for i in player_count:
		var player_index = str(i + 1)

		var dmg_per_player_container = _hud.get_node("LifeContainerP%s/DmgPerPlayerContainerP%s" % [player_index, player_index])
		dmg_per_player_containers.append(dmg_per_player_container)

		dmg_per_player_containers[i].set_elements(RunData.get_player_weapons(i), i, true)

		for el in RunData.get_player_items(i):
			if not dmg_per_player_containers[i].items.has(el) && el.tracking_text == "DAMAGE_DEALT" || el.name == "ITEM_BUILDER_TURRET":
				dmg_per_player_containers[i].add_element(el)

	dmg_per_player_update()

func dmg_per_player_register_timers():
	dmg_per_player_timer = Timer.new()
	if not dmg_per_player_timer.is_connected("timeout", self, "dmg_per_player_update"):
		var _discarded = dmg_per_player_timer.connect("timeout", self, "dmg_per_player_update")

	dmg_per_player_timer.one_shot = false
	dmg_per_player_timer.wait_time = 0.5
	add_child(dmg_per_player_timer)
	dmg_per_player_timer.start()
	
	hide_dmg_per_player_timer = Timer.new()
	if not hide_dmg_per_player_timer.is_connected("timeout", self, "dmg_per_player_hide"):
		var _discarded = hide_dmg_per_player_timer.connect("timeout", self, "dmg_per_player_hide")

	hide_dmg_per_player_timer.one_shot = true
	hide_dmg_per_player_timer.wait_time = 2
	add_child(hide_dmg_per_player_timer)

func dmg_per_player_update():
	if wave_timer != null and is_instance_valid(wave_timer):
		var time = ceil(wave_timer.time_left)
		if time > 0:
			for i in RunData.get_player_count():
				dmg_per_player_containers[i].visible = true
				dmg_per_player_containers[i].trigger_element_updates()
		else:
			hide_dmg_per_player_timer.start()
			dmg_per_player_timer.stop()
		return

func dmg_per_player_hide():
	for i in RunData.get_player_count():
		dmg_per_player_containers[i].visible = false
