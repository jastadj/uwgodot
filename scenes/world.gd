extends Spatial

var wall_materials = []
var floor_materials = []
var ceiling_materials = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
func loadLevel(var level):
	
	var floormesh = preload("res://meshes/floor.tscn")
	var mymaterial = load("res://meshes/material.tres")
	
	for y in range(0,64):
		for x in range(0, 64):
			var tile = level["map"][y][x]
			if tile["shape"] != 0:
				var newtile = floormesh.instance()
				newtile.set_surface_material(0,mymaterial)
				newtile.translation = Vector3(x, tile["height"], y)
				$tiles.add_child(newtile)
