extends "res://ui/menus/run/coop_end_run_player_container.gd"

onready var vbox: InventoryContainer = $"%VBoxContainer"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BFX_LOG_MOD_MAIN = "DoDaLi-ShowDPS"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	items_container.set_player_index(player_index)
#	var index = player_index + 1;
#	var dmgTscn = preload("res://mods-unpacked/DoDaLi-ShowDPS/ui/hud/damage_1player.tscn").instance()
#	var player_container: PanelContainer = get_tree().get_current_scene().get_node("%PlayerContainer1")
#	if player_container:
#		player_container.call_deferred("add_child", dmgTscn)
##	var vbox: VBoxContainer = get_tree().get_current_scene().get_node("%PlayerContainer1/MarginContainer/Carousel")
#
#	ModLoaderLog.info("mod coop_end_run_player_container:" + str(carousel.player_index), BFX_LOG_MOD_MAIN);
#
#	var txt_lb = items_container.get_node("%Label")
#	if txt_lb:
#		txt_lb.text = "test"
#	items_container.set_label("testttttt")
#
#	if carousel:
#		carousel.call_deferred("add_child", dmgTscn)
#
#	var txt_damage_player = dmgTscn.get_node("%Damage")
	
#	txt_damage_player.text = "test zack"
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
