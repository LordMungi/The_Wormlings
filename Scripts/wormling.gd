extends CharacterBody2D

class_name Wormling

var rng = RandomNumberGenerator.new()

#Rates
@export var speed = 2
@export var hungerSpeed = 0.5
@export var exhaustionSpeed = 0.5
@export var eatingSpeed = 2
@export var restingSpeed = 3

#Grab data
var isMouseColliding: bool
var grabOffset: Vector2

#Status
var state: WormState.s
var fullness
var energy

#Accesories
var accesories = []

func _ready() -> void:
	isMouseColliding = false
	grabOffset = Vector2(0, 0)
	
	velocity = Vector2(0, 0)
	
	fullness = 100
	energy = 100
	
	changeDirection()
	
	accesories.resize(AccsTypes.t.Last)
	for i in range(accesories.size()):
		accesories[i] = false

func _physics_process(delta):
	fullness -= hungerSpeed * delta
	energy -= exhaustionSpeed * delta
	
	match state:
		WormState.s.WALK:
			if move_and_collide(velocity):
				changeDirection()
		
		WormState.s.EATING:
			fullness = min(fullness + eatingSpeed * delta, 100)
			
		WormState.s.SLEEPING:
			energy = min(energy + restingSpeed * delta, 100)
			fullness -= hungerSpeed * delta
			
		
		WormState.s.WORKING:
			energy -= exhaustionSpeed * delta
	
	if fullness <= 0 or energy <= 0:
		state = WormState.s.DEAD
		$Sprite2D.modulate = Color(0, 0, 0, 1)
		$Timer.stop()
	
	$Accesories/Sunglasses.visible = accesories[AccsTypes.t.Sunglasses]
	$Accesories/Hat.visible = accesories[AccsTypes.t.Hat]
	$Accesories/Moustache.visible = accesories[AccsTypes.t.Moustache]
	$Accesories/Bowtie.visible = accesories[AccsTypes.t.Bowtie]
	print(accesories[0])
	
	$Label.text = "Hunger " + str(int(fullness))
	$Label2.text = "Energy " + str(int(energy))

func _on_mouse_entered() -> void:
	isMouseColliding = true

func _on_mouse_exited() -> void:
	isMouseColliding = false
	
func grab(mousePosition):
	$Timer.stop()
	grabOffset = mousePosition - position
	state = WormState.s.GRABBED

func release():
	state = WormState.s.IDLE
	changeDirection()

func changeDirection():
	$Timer.start(rng.randf_range(1, 5))
	if rng.randi_range(0, 2) == 0:
		state = WormState.s.IDLE
	else:
		state = WormState.s.WALK
		velocity = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized() * speed

func _on_timer_timeout() -> void:
	changeDirection()
