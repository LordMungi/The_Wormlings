extends Node2D
var WormlingScene = preload("res://Scenes/wormling.tscn")

var wormlings = []
var isGrabbing: bool

var money

@export var salary = 1

func _ready() -> void:
	money = 0
	
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
			
		elif isCharacterInsideArea(w, $Feedlot) and w.fullness < 95:
			w.state = WormState.s.EATING
			
		elif isCharacterInsideArea(w, $Hotel) and w.energy < 95:
			w.state = WormState.s.SLEEPING
		
		elif isCharacterInsideArea(w, $Work) and w.energy > 30:
			w.state = WormState.s.WORKING
		
		if w.state == WormState.s.WORKING:
			money = min(money + salary * delta, 999)
			
	$Label.text = "Money: " + str(int(money))

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
	
func isCharacterInsideArea(character: CharacterBody2D, area: Area2D) -> bool:
	var areaShape = area.get_node("CollisionShape2D").shape
	var rect = Rect2(area.global_position - areaShape.extents, areaShape.size)
	return rect.has_point(character.global_position)
