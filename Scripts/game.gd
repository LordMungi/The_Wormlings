extends Node2D

class_name Game

#Rates
@export var salary = 1.0
@export var wormPrice = 40

#Player
var money
var isGrabbing: bool

#Wormlings
var WormlingScene = preload("res://Scenes/wormling.tscn")
var wormlings = []

#Objects
var accesories = []
var food: Food

#Market
var market: Market


func _ready() -> void:
	money = 0
	isGrabbing = false
	
	market = $Market
	
	$Buildings/Hotel/Label.text = $Buildings/Hotel.name
	$Buildings/Office/Label.text = $Buildings/Office.name
	
	accesories.resize(AccsTypes.t.Last)
	accesories[0] = $Accesories/Sunglasses
	accesories[1] = $Accesories/Hat
	accesories[2] = $Accesories/Moustache
	accesories[3] = $Accesories/Bowtie
	
	food = $Food
	food.defaultPos = food.position
	
	for a in accesories:
		a.defaultPos = a.position
	
	for i in range(3):
		var wormling = WormlingScene.instantiate()
		add_child(wormling)
		wormling.position = get_viewport().get_visible_rect().size / 2
		wormlings.append(wormling)

func _process(delta: float) -> void:
	$PauseMenu.visible = Global.isPaused
	
	if not Global.isPaused:
		for a in accesories:
			if a.isGrabbed:
				a.position = get_viewport().get_mouse_position() - a.grabOffset
		
		if food.isGrabbed:
			food.position = get_viewport().get_mouse_position() - food.grabOffset
		
		for w in wormlings:
			if w.shouldDespawn:
				deleteWorm(w)
				
			if w.state == WormState.Movement.GRABBED:
				w.position = get_viewport().get_mouse_position() - w.grabOffset
			else:
				if isCharacterInsideArea(w, $Buildings/Hotel):
					w.action = WormState.Action.SLEEPING
				
				elif isCharacterInsideArea(w, $Buildings/Office):
					w.action = WormState.Action.WORKING
				
				else:
					w.action = WormState.Action.IDLE
			
			if w.action == WormState.Action.WORKING:
				money = min(money + salary * delta, 9999)
		
	$Label.text = "Money: " + str(int(money))

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		Global.isPaused = not Global.isPaused
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Click"):
			for a in accesories:
				if a.isMouseColliding and not isGrabbing:
					if money >= a.price:
						isGrabbing = true
						a.grab(get_viewport().get_mouse_position())
			
			if food.isMouseColliding and not isGrabbing:
				if money >= food.price:
					isGrabbing = true
					food.grab(get_viewport().get_mouse_position())
			
			for w in wormlings:
				if w.isMouseColliding and not isGrabbing:
					isGrabbing = true
					w.grab(get_viewport().get_mouse_position())
						
		elif Input.is_action_just_released("Click"):
			isGrabbing = false
			
			for w in wormlings:
				for i in range(accesories.size()):
					if accesories[i].isGrabbed and w.isMouseColliding and w.accesories[i] == false:
						w.accesories[i] = true
						accesories[i].release()
						money -= accesories[i].price
					
					if food.isGrabbed and w.isMouseColliding:
						w.fullness = min(w.fullness + food.nutrition, 100)
						money -= food.price
						food.release()
						
					
				if w.state == WormState.Movement.GRABBED:
					if isCharacterInsideArea(w, $GameArea):
						w.release()
					if isCharacterInsideArea(w, $Market):
						if market.matchWorm(w):
							money += market.pay
							deleteWorm(w)
							market.newOrder()
			
			if food.isGrabbed:
				food.release()
			
			for a in accesories:
				if a.isGrabbed:
					a.release()

func _on_button_button_up() -> void:
	if money > wormPrice:
		money -= wormPrice
		var wormling = WormlingScene.instantiate()
		add_child(wormling)
		wormling.position = get_viewport().get_visible_rect().size / 2
		wormlings.append(wormling)
	
func isCharacterInsideArea(character: CharacterBody2D, area: Area2D) -> bool:
	var areaShape = area.get_node("CollisionShape2D").shape
	var rect = Rect2(area.global_position - areaShape.extents, areaShape.size)
	return rect.has_point(character.global_position)
	
func deleteWorm(worm):
	worm.queue_free()
	wormlings.erase(worm)
