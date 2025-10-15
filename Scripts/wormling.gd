extends CharacterBody2D

class_name Wormling

var rng = RandomNumberGenerator.new()

#Rates
@export var speed = 2
@export var hungerSpeed = 0.5
@export var exhaustionSpeed = 0.5
@export var eatingSpeed = 2
@export var restingSpeed = 3
@export var fadeSpeed = 0.2

#Grab data
var isMouseColliding: bool
var grabOffset: Vector2

#Status
var shouldDespawn: bool
var state: WormState.Movement
var action: WormState.Action
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
	
	state = WormState.Movement.MOVING
	action = WormState.Action.IDLE
	changeDirection()
	
	accesories.resize(AccsTypes.t.Last)
	for i in range(accesories.size()):
		accesories[i] = false

func _physics_process(delta):
	fullness = max(fullness - hungerSpeed * delta, 0)
	energy = max(energy - exhaustionSpeed * delta, 0)
	
	print(str(state) + " " + str($DeathTimer.time_left))
	
	match state:
		WormState.Movement.MOVING:
			if $MoveTimer.time_left == 0:
				changeDirection()
			
			#Move, if it collides, change direction
			if move_and_collide(velocity):
				changeDirection()
	
	if not state == WormState.Movement.GRABBED:
		match action:
			WormState.Action.EATING:
				fullness = min(fullness + eatingSpeed * delta, 100)
				state = WormState.Movement.MOVING
				
			WormState.Action.SLEEPING:
				energy = min(energy + restingSpeed * delta, 100)
				if energy > 95:
					state = WormState.Movement.MOVING
				else:
					state = WormState.Movement.STATIONARY
				
			WormState.Action.WORKING:
				energy -= exhaustionSpeed * delta
				state = WormState.Movement.MOVING
				
	
	if fullness <= 0 or energy <= 0:
		if $DeathTimer.time_left == 0:
			$DeathTimer.start()
		state = WormState.Movement.DEAD
		$Body.modulate = Color(0, 0, 0, 1)
		$MoveTimer.stop()
	
	$Body/Sunglasses.visible = accesories[AccsTypes.t.Sunglasses]
	$Body/Hat.visible = accesories[AccsTypes.t.Hat]
	$Body/Moustache.visible = accesories[AccsTypes.t.Moustache]
	$Body/Bowtie.visible = accesories[AccsTypes.t.Bowtie]
	
	$Label.text = "Hunger " + str(int(fullness))
	$Label2.text = "Energy " + str(int(energy))

func _on_mouse_entered() -> void:
	isMouseColliding = true

func _on_mouse_exited() -> void:
	isMouseColliding = false
	
func grab(mousePosition):
	grabOffset = mousePosition - position
	state = WormState.Movement.GRABBED

func release():
	state = WormState.Movement.MOVING
	changeDirection()

func changeDirection():
	$MoveTimer.start(rng.randf_range(1, 5))
	
	if rng.randi_range(0, 2) == 0:
		velocity = Vector2(0, 0)
	else:
		velocity = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized() * speed


func _on_death_timer_timeout() -> void:
	shouldDespawn = true
