extends "res://singletons/run_data.gd"

# 保留波次开始时的状态，用于重试功能
var luke_retry_start_wave_state: Dictionary = {}

func on_wave_start(timer: WaveTimer) -> void:
	.on_wave_start(timer)
	luke_retry_start_wave_state = get_state()

func reset_to_start_wave_state() -> void:
	start_wave_state = luke_retry_start_wave_state.duplicate(true)
	.reset_to_start_wave_state()

func reset(restart: bool = false):
	luke_retry_start_wave_state.clear()
	.reset(restart)
