extends Node2D

class_name Settings

func _on_ready() -> void:
	for res in Global.resOptions:
		$Resolution/OptionButton.add_item(str(int(res.x)) + "x" + str(int(res.y)))
		
	$Resolution/OptionButton.selected = Global.resSelection
	$Volume/HSlider.value =  Global.volumeSelection
	$Fullscreen/CheckBox.button_pressed =  Global.fullscreenSelection

func _on_option_button_item_selected(index: int) -> void:
	Global.resSelection = index

func _on_h_slider_value_changed(value: float) -> void:
	Global.volumeSelection = value

func _on_check_box_toggled(toggled_on: bool) -> void:
	Global.fullscreenSelection = toggled_on

func _on_apply_button_button_up() -> void:
	DisplayServer.window_set_size(Global.resOptions[Global.resSelection])
	if Global.fullscreenSelection:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), Global.volumeSelection)

func _on_exit_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
