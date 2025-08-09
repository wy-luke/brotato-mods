class_name DmgPerPlayerContainer
extends VBoxContainer


export(PackedScene) var total_dmg_scene = null
var items = []
var total_dmg_instance = null

func set_elements(elements: Array, player_index: int, replace: bool = true) -> void:
	if replace:
		clear_elements()

	if total_dmg_scene and not total_dmg_instance:
		total_dmg_instance = total_dmg_scene.instance()
		add_child(total_dmg_instance)
		total_dmg_instance.set_hud_position(player_index)

	for element in elements:
		add_element(element, player_index)

func clear_elements() -> void:
	items.clear()
	total_dmg_instance = null
	for n in get_children():
		remove_child(n)
		n.queue_free()


func add_element(element: ItemParentData, player_index: int) -> void:
	if ["WEAPON_WRENCH", "WEAPON_SCREWDRIVER"].has(element.name):
		handle_spawner(element, player_index)
	items.append(element)

	if total_dmg_instance:
		total_dmg_instance.track_item(element, player_index)

func handle_spawner(element: ItemParentData, player_index: int) -> void:
	match element.name:
		"WEAPON_SCREWDRIVER":
			if not items.has("item_landmines"):
				add_element(ItemService.get_item_from_id("item_landmines"), player_index)
		"WEAPON_WRENCH":
			match element.tier:
				Tier.COMMON:
					if not items.has("item_turret"):
						add_element(ItemService.get_item_from_id("item_turret"), player_index)
				Tier.UNCOMMON:
					if not items.has("item_turret_flame"):
						add_element(ItemService.get_item_from_id("item_turret_flame"), player_index)
				Tier.RARE:
					if not items.has("item_turret_laser"):
						add_element(ItemService.get_item_from_id("item_turret_laser"), player_index)
				Tier.LEGENDARY:
					if not items.has("item_turret_rocket"):
						add_element(ItemService.get_item_from_id("item_turret_rocket"), player_index)

func trigger_element_updates() -> void:
	update_total_damage()

func update_total_damage() -> void:
	if total_dmg_instance:
		var total_damage = 0
		for item in items:
			total_damage += total_dmg_instance.get_item_dmg_dealt(item)
		total_dmg_instance.set_total_damage(total_damage)
