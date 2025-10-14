extends Node2D
var WormlingScene = preload("res://Scenes/wormling.tscn")

var wormlings = []
var isGrabbing: bool

func _ready() -> void:
	isGrabbing = false
	for i in range(3):
		var wormling = WormlingScene.instantiate()
		add_child(wormling)
		wormling.position = get_viewport().get_visible_rect().size / 2
		wormlings.append(wormling)
		

func _process(delta: float) -> void:
	for w in wormlings:
		if w.state == WormState.s.GRABBED:
			w.position = get_viewport().get_mouse_position() - w.grabOffset

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Click"):
			for w in wormlings:
				if w.isMouseColliding and not isGrabbing:
					isGrabbing = true
					w.grab(get_viewport().get_mouse_position())
					
		elif Input.is_action_just_released("Click"):
			isGrabbing = false
			for w in wormlings:
				w.release()

func _on_button_button_up() -> void:
	var wormling = WormlingScene.instantiate()
	add_child(wormling)
	wormling.position = get_viewport().get_visible_rect().size / 2
	wormlings.append(wormling)
