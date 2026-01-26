class_name DmgPerPlayerContainer
extends GridContainer

onready var player_index_label = $PlayerIndex
onready var current_label = $Current
onready var total_label = $Total

var player_rows := []


func _ready() -> void:
	player_rows.append({
		"current": current_label,
		"total": total_label
	})

	var player_count := RunData.get_player_count()
	for i in range(1, player_count):
		var new_player_index = player_index_label.duplicate()
		var new_current = current_label.duplicate()
		var new_total = total_label.duplicate()

		add_child(new_player_index)
		add_child(new_current)
		add_child(new_total)
		
		player_rows.append({
			"current": new_current,
			"total": new_total
		})

		new_player_index.text = "Player %s :" % (i + 1)
		_update_row(i, 0, 0, 0, 0)

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

func _calc_percentage(value: int, total: int) -> int:
	return int(float(value) / total * 100) if total > 0 else 0

func _update_row(index: int, wave_damage: int, wave_perc: int, total_damage: int, total_perc: int) -> void:
	var row = player_rows[index]
	if RunData.get_player_count() <= 1:
		row.current.text = str(wave_damage)
		row.total.text = str(total_damage)
	else:
		row.current.text = "%s (%s%%)" % [wave_damage, wave_perc]
		row.total.text = "%s (%s%%)" % [total_damage, total_perc]
