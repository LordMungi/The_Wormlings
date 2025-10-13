extends Area2D

class_name Wormling

var isMouseColliding: bool
var isBeingGrabbed: bool
var grabOffset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isMouseColliding = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_mouse_entered() -> void:
	isMouseColliding = true

func _on_mouse_exited() -> void:
	isMouseColliding = false
	
func grab(mousePosition):
	grabOffset = mousePosition - position
	isBeingGrabbed = true
	
func release():
	isBeingGrabbed = false
