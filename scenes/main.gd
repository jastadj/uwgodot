extends Node2D

var world

var test_index = 0
var player = null

func _ready():
	
	var image_loader = load("res://system/images.gd")
	
	$ColorRect.rect_size = get_viewport_rect().size
	
	# load level 0
	world = $ViewportContainer/Viewport.get_node("world")
	world.loadLevel(Persistent.levels[0])
	
	# set background sprites
	$main_background.texture = image_loader.new_image_texture_from_image(Persistent.bmp_main)
	#$main_background.scale = Vector2(4,4)
	
	#player = 	$ViewportContainer/Viewport.get_node("world/player")

func _process(delta):
	var tile_size = $ViewportContainer/Viewport.get_node("world").getTileSize()
	#$dbg_pos.text = str("pos:",floor(player.translation.x/tile_size), ",", floor(player.translation.y/tile_size), ",", floor(player.translation.z/tile_size) )
	#$dbg_pos.text = str("pos:",floor(player.translation.x/2), ",", floor(player.translation.y/2), ",", floor(player.translation.z/2) )
	#$dbg_pos.text = str("pos:",floor(player.translation.x), ",", floor(player.translation.y), ",", floor(player.translation.z) )

func _input(event):
		
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

