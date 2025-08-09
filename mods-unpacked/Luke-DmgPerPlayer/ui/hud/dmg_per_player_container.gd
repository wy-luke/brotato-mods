class_name DmgPerPlayerContainer
extends VBoxContainer

onready var wave_value_label: Label = $Wave/Value
onready var total_value_label: Label = $Total/Value

var items = []
var player_index: int
var item_wave_start_value: Dictionary = {}

func set_elements(elements: Array, p_index: int, replace: bool = true) -> void:
	if replace:
		clear_elements()
	
	player_index = p_index
	set_hud_position(player_index)

	for element in elements:
		add_element(element)

func clear_elements() -> void:
	items.clear()
	for n in get_children():
		if not n is HBoxContainer:
			remove_child(n)
			n.queue_free()

func add_element(element: ItemParentData) -> void:
	if ["WEAPON_WRENCH", "WEAPON_SCREWDRIVER"].has(element.name):
		handle_spawner(element)
	items.append(element)
	track_item(element)

func handle_spawner(element: ItemParentData) -> void:
	match element.name:
		"WEAPON_SCREWDRIVER":
			if not items.has("item_landmines"):
				add_element(ItemService.get_item_from_id("item_landmines"))
		"WEAPON_WRENCH":
			match element.tier:
				Tier.COMMON:
					if not items.has("item_turret"):
						add_element(ItemService.get_item_from_id("item_turret"))
				Tier.UNCOMMON:
					if not items.has("item_turret_flame"):
						add_element(ItemService.get_item_from_id("item_turret_flame"))
				Tier.RARE:
					if not items.has("item_turret_laser"):
						add_element(ItemService.get_item_from_id("item_turret_laser"))
				Tier.LEGENDARY:
					if not items.has("item_turret_rocket"):
						add_element(ItemService.get_item_from_id("item_turret_rocket"))

func trigger_element_updates() -> void:
	update_total_damage()

func update_total_damage() -> void:
	var total_damage = 0
	for item in items:
		total_damage += get_item_dmg_dealt(item)
	set_total_damage(total_damage)

func track_item(item: ItemParentData) -> void:
	if [Category.ITEM, Category.CHARACTER].has(item.get_category()) && not item.name == "ITEM_BUILDER_TURRET":
		item_wave_start_value[item.my_id] = RunData.tracked_item_effects[player_index][item.my_id]

func get_item_dmg_dealt(item: ItemParentData) -> int:
	if item.get_category() == Category.WEAPON:
		return item.dmg_dealt_last_wave
	else:
		var start_value = 0
		if item_wave_start_value.has(item.my_id):
			start_value = item_wave_start_value[item.my_id]
		return RunData.tracked_item_effects[player_index][item.my_id] - start_value

func set_total_damage(damage: int) -> void:
	wave_value_label.text = Text.get_formatted_number(damage)

func set_hud_position(position_index: int) -> void:
	var left = position_index == 0 or position_index == 2
	self.alignment = BoxContainer.ALIGN_BEGIN if left else BoxContainer.ALIGN_END
