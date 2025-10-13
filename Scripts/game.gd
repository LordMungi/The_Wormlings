extends Node2D
var WormlingScene = preload("res://Scenes/wormling.tscn")

var wormlings = []
var isGrabbing: bool

func _ready() -> void:
	isGrabbing = false
	
	for i in range(3):
		var wormling = WormlingScene.instantiate()
		add_child(wormling)
		wormlings.append(wormling)
		

func _process(delta: float) -> void:
	for w in wormlings:
		if w.isBeingGrabbed:
			w.position = get_viewport().get_mouse_position() - w.grabOffset

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Click"):
			for w in wormlings:
				if w.isMouseColliding and not isGrabbing:
					isGrabbing = true
					w.grab(get_viewport().get_mouse_position())
					
		elif Input.is_action_just_released("Click"):
			for w in wormlings:
				if w.isMouseColliding:
					isGrabbing = false
					w.release()
