class_name DmgPerPlayerContainer
extends GridContainer

const FONT = preload("res://resources/fonts/actual/base/font_26_outline_thick.tres")
const UPDATE_INTERVAL := 0.5

var player_rows := []


func _ready() -> void:
	for i in range(RunData.get_player_count()):
		player_rows.append(_create_row(i))
	_setup_update_timer()

func _create_row(index: int) -> Dictionary:
	var _player_index := _create_label("P%s :" % (index + 1), HALIGN_LEFT)
	var current := _create_label("0", HALIGN_RIGHT)
	var total := _create_label("0", HALIGN_RIGHT)
	return {"current": current, "total": total}

func _create_label(text: String, align: int) -> Label:
	var label := Label.new()
	label.text = text
	label.align = align
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.add_font_override("font", FONT)
	add_child(label)
	return label

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

	for i in player_count:
		all_wave_damage += RunData.player_damage[i]
		all_total_damage += RunData.player_damage_total[i]

	for i in player_count:
		if i >= player_rows.size():
			break
			
		var wave_damage: int = RunData.player_damage[i]
		var total_damage: int = RunData.player_damage_total[i]
		var wave_perc := _calc_percentage(wave_damage, all_wave_damage)
		var total_perc := _calc_percentage(total_damage, all_total_damage)
		
		_update_row(i, wave_damage, wave_perc, total_damage, total_perc)

func _update_row(index: int, wave_damage: int, wave_perc: int, total_damage: int, total_perc: int) -> void:
	var row = player_rows[index]
	var wave_str := _format_number(wave_damage)
	var total_str := _format_number(total_damage)
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
