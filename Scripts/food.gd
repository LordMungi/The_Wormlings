extends GrabbableObject

class_name Food

@export var price: int
@export var nutrition: int

func _ready() -> void:
	$Price.text = str(price)
