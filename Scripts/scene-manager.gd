extends Node

var scenes = []

func loadScene(scenePath: String):
	
	if get_tree().current_scene:
		scenes.append(get_tree().current_scene)
		get_tree().current_scene.hide()
	
	var newScene = load(scenePath).instantiate()
	get_tree().root.add_child(newScene)
	get_tree().current_scene = newScene

func prevScene():
	if scenes.size() > 0:
		get_tree().current_scene.queue_free()
		var previousScene = scenes.pop_back()
		previousScene.show()
		get_tree().current_scene = previousScene
		
