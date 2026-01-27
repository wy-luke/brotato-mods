extends "res://singletons/run_data.gd"

const MAX_PLAYERS := 4

var player_damage: Array = []
var player_damage_total: Array = []

func _init() -> void:
	_init_damage_arrays()

func _init_damage_arrays() -> void:
	player_damage = _create_player_array()
	player_damage_total = _create_player_array()

func _create_player_array() -> Array:
	var arr := []
	arr.resize(MAX_PLAYERS)
	for i in MAX_PLAYERS:
		arr[i] = 0
	return arr

func reset(restart: bool = false):
	_init_damage_arrays()
	.reset(restart)

func on_wave_start(timer: WaveTimer) -> void:
	player_damage = _create_player_array()
	.on_wave_start(timer)

func get_state() -> Dictionary:
	var state =.get_state()
	state["luke_player_damage"] = player_damage.duplicate()
	state["luke_player_damage_total"] = player_damage_total.duplicate()
	return state

func resume_from_state(state: Dictionary) -> void:
	.resume_from_state(state)
	
	if state.has("luke_player_damage"):
		player_damage = state.luke_player_damage.duplicate()
	else:
		player_damage = _create_player_array()
	
	if state.has("luke_player_damage_total"):
		player_damage_total = state.luke_player_damage_total.duplicate()
	else:
		player_damage_total = _create_player_array()