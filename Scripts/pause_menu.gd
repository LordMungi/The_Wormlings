extends Node2D

func _on_resume_button_button_up() -> void:
	Global.isPaused = false

func _on_quit_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
