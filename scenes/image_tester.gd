extends Node2D

var image_list
var image_index = 0
var image_scale = Vector2(4,4)
var images = load("res://system/images.gd")

func _ready():
	
	### SET THE IMAGE TO TEST HERE ###
	#image_list = Persistent.img_dragons
	image_list = Persistent.img_test
	
	refresh_image()

func _input(event):
	
	if event is InputEventKey:
		if event.pressed:
			if event.is_action_pressed("ui_right"):
				print("pressed right")
				image_index += 1
				if image_index >= image_list.size(): image_index = 0
				refresh_image()
			elif event.is_action_pressed("ui_left"):
				image_index -= 1
				if image_index < 0: image_index = image_list.size()-1
				refresh_image()
			elif event.is_action_pressed("ui_cancel"):
				get_tree().quit()
			else:
				if event.unicode == 43: image_scale = image_scale + Vector2(1,1)
				elif event.unicode == 45:
					image_scale = image_scale + Vector2(-1,-1)
					if image_scale.x < 1 or image_scale.y < 1: image_scale = Vector2(1,1)


func _process(delta):
	$image.scale = image_scale

func refresh_image():
	print("refreshing image")
	$image.texture = images.new_image_texture_from_image( image_list[image_index] )
	print("test image index = ", image_index)
