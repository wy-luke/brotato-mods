extends "res://ui/hud/ui_wave_timer.gd"

onready var how_dps_hud: MarginContainer = get_tree().get_current_scene().get_node("UI/HUD")
const MOD_DIR = "DoDaLi-ShowDPS/"
const BFX_LOG_MOD_MAIN = "DoDaLi-ShowDPS"

var show_dps_container
var _show_dps_timer = null

var txt_damage_player1: RichTextLabel
var txt_damage_player2: RichTextLabel
var txt_damage_player3: RichTextLabel
var txt_damage_player4: RichTextLabel

var txt_damage_total_player1: RichTextLabel
var txt_damage_total_player2: RichTextLabel
var txt_damage_total_player3: RichTextLabel
var txt_damage_total_player4: RichTextLabel

var txt_cur_wave_ = []
var txt_total_ = []
		
func _ready() -> void:
	show_dps_container = preload("res://mods-unpacked/DoDaLi-ShowDPS/ui/hud/show_dps.tscn").instance()
	how_dps_hud.margin_bottom = 0
	how_dps_hud.anchor_bottom = 1
	how_dps_hud.call_deferred("add_child", show_dps_container)
	how_dps_hud.mouse_filter = MOUSE_FILTER_IGNORE
	
	txt_damage_player1 = show_dps_container.get_node("%Damage_Player01")
	txt_damage_player2 = show_dps_container.get_node("%Damage_Player02")
	txt_damage_player3 = show_dps_container.get_node("%Damage_Player03")
	txt_damage_player4 = show_dps_container.get_node("%Damage_Player04")
	txt_cur_wave_.clear()
	txt_cur_wave_.push_back(txt_damage_player1)
	txt_cur_wave_.push_back(txt_damage_player2)
	txt_cur_wave_.push_back(txt_damage_player3)
	txt_cur_wave_.push_back(txt_damage_player4)
	
	txt_damage_total_player1 = show_dps_container.get_node("%Damage_Total_Player01")
	txt_damage_total_player2 = show_dps_container.get_node("%Damage_Total_Player02")
	txt_damage_total_player3 = show_dps_container.get_node("%Damage_Total_Player03")
	txt_damage_total_player4 = show_dps_container.get_node("%Damage_Total_Player04")
	txt_total_.clear()
	txt_total_.push_back(txt_damage_total_player1)
	txt_total_.push_back(txt_damage_total_player2)
	txt_total_.push_back(txt_damage_total_player3)
	txt_total_.push_back(txt_damage_total_player4)
	
	var lang = ProgressData.settings.language;
	ModLoaderLog.info("mod get lang:" + lang, BFX_LOG_MOD_MAIN)
	
	var txt_wave = show_dps_container.get_node("%Damage_Wave");
	var txt_total = show_dps_container.get_node("%Damage_Total");
	var txt_space = show_dps_container.get_node("%Damage_Space");
	if lang == "zh":
		txt_wave.bbcode_text = "本关伤害:"
		txt_total.bbcode_text = "总伤害:"
	else:
		txt_wave.bbcode_text = "Damage This Wave:"
		txt_total.bbcode_text = "Damage Total:"
	txt_space.bbcode_text = " "
	txt_damage_player1.bbcode_text = " "
	txt_damage_player2.bbcode_text = " "
	txt_damage_player3.bbcode_text = " "
	txt_damage_player4.bbcode_text = " "
	txt_damage_total_player1.bbcode_text = " "
	txt_damage_total_player2.bbcode_text = " "
	txt_damage_total_player3.bbcode_text = " "
	txt_damage_total_player4.bbcode_text = " "
		
	_show_dps_timer = Timer.new()
	add_child(_show_dps_timer)
	_show_dps_timer.connect("timeout", self, "_update_stats_ui")
	_show_dps_timer.set_one_shot(false) # Make sure it loops
	_show_dps_timer.set_wait_time(0.5)
	_show_dps_timer.start()
	
	_update_stats_ui()
	
	
func _update_stats_ui():
	if wave_timer != null and is_instance_valid(wave_timer):
		var time = ceil(wave_timer.time_left)
		if time > 0:
			show_dps_container.visible = true
		else:
			show_dps_container.visible = false
			return
	
	
	for i in RunData.get_player_count():
		if RunData.player_damage_total[i] > 0:
			txt_cur_wave_[i].bbcode_text = "P" + str(i + 1) + ": " + str(RunData.player_damage[i]);
		else:
			txt_cur_wave_[i].bbcode_text = "P" + str(i + 1) + ": 0"

	
	var damage_all = 0
	for i in RunData.get_player_count():
		damage_all += RunData.player_damage_total[i]
	
	var percent = [0, 0, 0, 0]
	
	for i in RunData.get_player_count():
		if RunData.player_damage_total[i] > 0:
			if damage_all > 0:
				percent[i] = RunData.player_damage_total[i] * 100 / damage_all
			else:
				percent[i] = 0
			txt_total_[i].bbcode_text = "P" + str(i + 1) + ": " + str(RunData.player_damage_total[i]) + "  (" + str(percent[i]) + "%)";
		else:
			txt_total_[i].bbcode_text = ""
