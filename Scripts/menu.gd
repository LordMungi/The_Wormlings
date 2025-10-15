extends Node2D

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_settings_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_button_button_up() -> void:
	get_tree().quit()

func _on_ready() -> void:
	DisplayServer.window_set_size(Global.resOptions[Global.resSelection])
	if Global.fullscreenSelection:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), Global.volumeSelection)
