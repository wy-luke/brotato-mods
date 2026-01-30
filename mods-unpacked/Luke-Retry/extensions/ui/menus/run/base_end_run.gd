extends "res://ui/menus/run/base_end_run.gd"

var _retry_wave_button: Button

func _ready() -> void:
	._ready()
	_add_retry_wave_button()

func _add_retry_wave_button() -> void:
	if RunData.current_wave <= 1:
		return

	_retry_wave_button = _restart_button.duplicate()
	_retry_wave_button.text = "LUKE_RETRY_RETRY_WAVE"
	_retry_wave_button.name = "RetryWaveButton"

	var buttons_container = _restart_button.get_parent()
	buttons_container.add_child(_retry_wave_button)
	buttons_container.move_child(_retry_wave_button, _restart_button.get_index())

	_retry_wave_button.connect("pressed", self, "_on_RetryWaveButton_pressed")

func _on_RetryWaveButton_pressed() -> void:
	if _button_pressed:
		return
	_button_pressed = true

	RunData.reset_to_start_wave_state()
	RunData.retries += 1
	get_tree().change_scene(MenuData.game_scene)
