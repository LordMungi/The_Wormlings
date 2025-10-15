extends Area2D

class_name GrabbableObject

var isMouseColliding: bool
var isGrabbed: bool
var grabOffset: Vector2
var defaultPos: Vector2

func _ready() -> void:
	isMouseColliding = false
	isGrabbed = false
	grabOffset = Vector2(0, 0)

func _on_mouse_entered() -> void:
	isMouseColliding = true

func _on_mouse_exited() -> void:
	isMouseColliding = false

func grab(mousePosition):
	grabOffset = mousePosition - position
	isGrabbed = true

func release():
	position = defaultPos
	isGrabbed = false
