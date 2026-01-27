extends "res://singletons/run_data.gd"

# 保留波次开始时的状态，用于重试功能
var luke_retry_start_wave_state: Dictionary = {}

func on_wave_start(timer: WaveTimer) -> void:
	.on_wave_start(timer)
	# 复制状态以防止被原生代码清空
	luke_retry_start_wave_state = get_state()

func reset_to_start_wave_state() -> void:
	# 如果原生的 start_wave_state 为空，使用我们保存的副本
	if start_wave_state.empty() and not luke_retry_start_wave_state.empty():
		resume_from_state(luke_retry_start_wave_state)
		
		var run_state = ProgressData.last_saved_run_state if ProgressData.last_saved_run_state else ProgressData._get_empty_run_state()
		ProgressData.reset_and_save_run_state(run_state)
	else:
		.reset_to_start_wave_state()

func reset(restart: bool = false):
	luke_retry_start_wave_state.clear()
	.reset(restart)
