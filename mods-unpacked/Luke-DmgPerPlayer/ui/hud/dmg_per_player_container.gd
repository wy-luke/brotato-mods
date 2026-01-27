class_name DmgPerPlayerContainer
extends GridContainer

onready var player_index_label = $PlayerIndex
onready var current_label = $Current
onready var total_label = $Total

var player_rows := []


func _ready() -> void:
	var player_count := RunData.get_player_count()
	for i in range(player_count):
		_create_player_row(i)
	_setup_update_timer()

func _create_player_row(index: int) -> void:
	var player_index: Label
	var current: Label
	var total: Label

	if index == 0:
		player_index = player_index_label
		current = current_label
		total = total_label
	else:
		player_index = player_index_label.duplicate()
		current = current_label.duplicate()
		total = total_label.duplicate()
		add_child(player_index)
		add_child(current)
		add_child(total)
		player_index.text = "P%s :" % (index + 1)

	player_rows.append({
		"current": current,
		"total": total
	})
	_update_row(index, 0, 0, 0, 0)

func _setup_update_timer() -> void:
	var timer := Timer.new()
	timer.wait_time = 0.5
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
