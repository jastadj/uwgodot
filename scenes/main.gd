extends Node2D

var world

var test_index = 0

func _ready():
	
	var image_loader = load("res://system/images.gd")
	
	# load level 0
	world = $ViewportContainer/Viewport.get_node("world")
	world.loadLevel(Persistent.levels[0])
	
	# set background sprites
	$main_background.texture = image_loader.new_image_texture_from_image(Persistent.bmp_main)
	#$main_background.scale = Vector2(4,4)
	
	
func _input(event):
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

