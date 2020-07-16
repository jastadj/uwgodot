extends Node2D

var world

func _ready():
	
	world = $ViewportContainer/Viewport.get_node("world")
	world.loadLevel(Persistent.levels[0])

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
