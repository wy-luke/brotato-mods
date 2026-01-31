class_name DmgPerPlayerContainer
extends GridContainer

const UPDATE_INTERVAL := 0.5
const MVP_COLOR := Color(1.0, 0.85, 0.0) # 金色

var player_rows := []
var _current_mvp_index := -1
var _mvp_tween: Tween

onready var _template_index := $Index
onready var _template_current := $Current
onready var _template_total := $Total


func _ready() -> void:
	_template_current.text = tr("LUKE_DMGPERPLAYER_CURRENT")
	_template_total.text = tr("LUKE_DMGPERPLAYER_TOTAL")
	
	for i in range(RunData.get_player_count()):
		player_rows.append(_create_row(i))
	
	_mvp_tween = Tween.new()
	add_child(_mvp_tween)
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
	var mvp_index := -1
	var max_total := 0

	for i in player_count:
		var dmg: int = RunData.player_damage_total[i]
		all_wave_damage += RunData.player_damage[i]
		all_total_damage += dmg
		if dmg > max_total:
			max_total = dmg
			mvp_index = i

	if player_count <= 1 or max_total <= 0:
		mvp_index = -1

	if mvp_index != _current_mvp_index:
		if _current_mvp_index >= 0 and _current_mvp_index < player_rows.size():
			var old_row = player_rows[_current_mvp_index]
			old_row.index.modulate = Color.white
			old_row.current.modulate = Color.white
			old_row.total.modulate = Color.white
			old_row.index.rect_scale = Vector2.ONE
			old_row.current.rect_scale = Vector2.ONE
			old_row.total.rect_scale = Vector2.ONE
		
		if mvp_index >= 0 and mvp_index < player_rows.size():
			_play_mvp_flash_animation(player_rows[mvp_index])
		
		_current_mvp_index = mvp_index

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

func _format_number(value: int) -> String:
	if value >= 100000000000:
		return "%.1fb" % (value / 1000000000.0)
	elif value >= 100000000:
		return "%.1fm" % (value / 1000000.0)
	elif value >= 100000:
		return "%.1fk" % (value / 1000.0)
	return str(value)

func _play_mvp_flash_animation(row: Dictionary) -> void:
	_mvp_tween.stop_all()
	
	var scale_up := Vector2(1.15, 1.15)
	var labels := [row.index, row.current, row.total]
	
	for label in labels:
		label.modulate = MVP_COLOR
		label.rect_scale = scale_up
		label.rect_pivot_offset = label.rect_size / 2
	
	for label in labels:
		_mvp_tween.interpolate_property(label, "rect_scale", scale_up, Vector2.ONE, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	_mvp_tween.start()
