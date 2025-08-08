extends "res://ui/menus/shop/inventory_container.gd"

var player_index = -1;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func set_label(label: String)->void :
	.set_label(label)
	_label.text = label


func set_data(label: String, category: int, elements: Array, reverse: bool = false, prioritize_gameplay_elements: bool = false)->void :
	.set_data(label, category, elements, reverse, prioritize_gameplay_elements);
	_label.text = _label.text + get_damage_str()

func get_damage_str()->String :
	if player_index < 0:
		return ""
	var strRes = ""
	var damage_all = 0
	for i in RunData.get_player_count():
		damage_all += RunData.player_damage_total[i]
	
	if RunData.player_damage_total[player_index] > 0:
		var percent = RunData.player_damage_total[player_index] * 100 / damage_all
		strRes = "(Damage:" + str(RunData.player_damage_total[player_index]) + " - " + str(percent) + "%)";
	
#	ModLoaderLog.info("InventoryContainer mod get_damage_str " + strRes, "test");
	return strRes

func set_player_index(i: int) :
#	ModLoaderLog.info("InventoryContainer mod set_player_index " + str(i), "test");
	player_index = i;
