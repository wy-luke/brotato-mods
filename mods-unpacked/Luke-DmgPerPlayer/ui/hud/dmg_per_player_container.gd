class_name DmgPerPlayerContainer
extends GridContainer

const UPDATE_INTERVAL := 0.5
const MVP_COLOR := Color(1.0, 0.84, 0.0) # Gold
const NORMAL_COLOR := Color.white

var player_rows := []

onready var _template_index := $Index
onready var _template_current := $Current
onready var _template_total := $Total


func _ready() -> void:
	_template_current.text = tr("LUKE_DMGPERPLAYER_CURRENT")
	_template_total.text = tr("LUKE_DMGPERPLAYER_TOTAL")
	
	for i in range(RunData.get_player_count()):
		player_rows.append(_create_row(i))
	
	_setup_update_timer()


func _create_row(index: int) -> Dictionary:
	var idx := _template_index.duplicate()
	var current := _template_current.duplicate()
	var total := _template_total.duplicate()
	
	idx.text = "P%s:" % (index + 1)
	current.text = "0"
	total.text = "0"
	
	add_child(idx)
	add_child(current)
	add_child(total)
	
	return {"index": idx, "current": current, "total": total}

func _setup_update_timer() -> void:
	var timer := Timer.new()
	timer.wait_time = UPDATE_INTERVAL
	timer.one_shot = false
	timer.connect("timeout", self, "_update_display")
	add_child(timer)
	timer.start()

func _update_display() -> void:
	var player_count := RunData.get_player_count()
	var all_wave_damage := 0
	var all_total_damage := 0
	var mvp_index := 0
	var max_total := 0

	for i in player_count:
		var dmg: int = RunData.player_damage_total[i]
		all_wave_damage += RunData.player_damage[i]
		all_total_damage += dmg
		if dmg > max_total:
			max_total = dmg
			mvp_index = i

	for i in player_count:
		if i >= player_rows.size():
			break
		var wave_damage: int = RunData.player_damage[i]
		var total_damage: int = RunData.player_damage_total[i]
		var wave_perc := _calc_percentage(wave_damage, all_wave_damage)
		var total_perc := _calc_percentage(total_damage, all_total_damage)
		var is_mvp: bool = (i == mvp_index and player_count > 1 and max_total > 0)
		
		_update_row(i, wave_damage, wave_perc, total_damage, total_perc, is_mvp)

func _update_row(index: int, wave_damage: int, wave_perc: int, total_damage: int, total_perc: int, is_mvp: bool = false) -> void:
	var row = player_rows[index]
	var wave_str := _format_number(wave_damage)
	var total_str := _format_number(total_damage)
	var color := MVP_COLOR if is_mvp else NORMAL_COLOR
	
	row.index.add_color_override("font_color", color)
	row.current.add_color_override("font_color", color)
	row.total.add_color_override("font_color", color)
	
	if RunData.get_player_count() <= 1:
		row.current.text = wave_str
		row.total.text = total_str
	else:
		row.current.text = "%s (%s%%)" % [wave_str, wave_perc]
		row.total.text = "%s (%s%%)" % [total_str, total_perc]

func _calc_percentage(value: int, total: int) -> int:
	return int(float(value) / total * 100) if total > 0 else 0


# Format large numbers with k/m/b suffixes (starting at 100k, 100m, 100b)
func _format_number(value: int) -> String:
	if value >= 100000000000:
		return "%.1fb" % (value / 1000000000.0)
	elif value >= 100000000:
		return "%.1fm" % (value / 1000000.0)
	elif value >= 100000:
		return "%.1fk" % (value / 1000.0)
	return str(value)
