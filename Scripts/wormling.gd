extends CharacterBody2D

class_name Wormling

var rng = RandomNumberGenerator.new()

@export var speed = 2
@export var hungerSpeed = 0.5
@export var eatingSpeed = 2

var isMouseColliding: bool
var isInFeedLot: bool
var grabOffset: Vector2

var state: WormState.s

var fullness

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isMouseColliding = false
	grabOffset = Vector2(0, 0)
	velocity = Vector2(0, 0)
	fullness = 100
	changeDirection()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fullness -= hungerSpeed * delta
	
	match state:
		WormState.s.WALK:
			if move_and_collide(velocity):
				changeDirection()
	
	if fullness <= 0:
		state = WormState.s.DEAD
		$Sprite2D.modulate = Color(0, 0, 0, 1)
		$Timer.stop()
	
	$Label.text = str(fullness)

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
