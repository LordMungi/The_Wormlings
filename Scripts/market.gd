extends Area2D

class_name Market

var orderCount
var wantsAccesories = []
var pay

var orders = {
	1: { 
		"pay": 30,
		"accesories": {
			AccsTypes.t.Sunglasses: true,
			AccsTypes.t.Hat: false,
			AccsTypes.t.Moustache: false,
			AccsTypes.t.Bowtie: false,
		}
	},
	2: { 
		"pay": 60,
		"accesories": {
			AccsTypes.t.Sunglasses: false,
			AccsTypes.t.Hat: true,
			AccsTypes.t.Moustache: false,
			AccsTypes.t.Bowtie: false,
		}
	},
	3: { 
		"pay": 100,
		"accesories": {
			AccsTypes.t.Sunglasses: true,
			AccsTypes.t.Hat: false,
			AccsTypes.t.Moustache: true,
			AccsTypes.t.Bowtie: false,
		}
	},
	4: { 
		"pay": 150,
		"accesories": {
			AccsTypes.t.Sunglasses: false,
			AccsTypes.t.Hat: true,
			AccsTypes.t.Moustache: false,
			AccsTypes.t.Bowtie: true,
		}
	},
	5: { 
		"pay": 200,
		"accesories": {
			AccsTypes.t.Sunglasses: false,
			AccsTypes.t.Hat: true,
			AccsTypes.t.Moustache: true,
			AccsTypes.t.Bowtie: true,
		}
	},
}

func _ready() -> void:
	wantsAccesories.resize(AccsTypes.t.Last)
	orderCount = 1
	newOrder()

func _process(delta: float) -> void:
	$Worm/Sunglasses.visible = wantsAccesories[AccsTypes.t.Sunglasses]
	$Worm/Hat.visible = wantsAccesories[AccsTypes.t.Hat]
	$Worm/Moustache.visible = wantsAccesories[AccsTypes.t.Moustache]
	$Worm/Bowtie.visible = wantsAccesories[AccsTypes.t.Bowtie]

func matchWorm(worm: Wormling) -> bool:
	var isCorrect = true
	for i in range(wantsAccesories.size()):
		if worm.accesories[i] != wantsAccesories[i]:
			isCorrect = false
			break
	
	return isCorrect

func newOrder():
	if orderCount > 5: 
		orderCount = 5
	
	pay = orders[orderCount]["pay"]
	for i in range(orders[orderCount]["accesories"].size()):
		wantsAccesories[i] = orders[orderCount]["accesories"][i]
	orderCount += 1
