extends Spatial

export(float) var map_scale = 1.0

var wall_materials = []
var floor_materials = []
var ceiling_materials = []



# Called when the node enters the scene tree for the first time.
func _ready():
	$tiles.scale = Vector3(map_scale, map_scale, map_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getTileSize():
	return 64*map_scale

	
func loadLevel(var level):
	
	# load resources
	var floormesh = preload("res://meshes/floor.tscn")
	var floorn_mesh = preload("res://meshes/floor_slope_north.tscn")
	var floors_mesh = preload("res://meshes/floor_slope_south.tscn")
	var floore_mesh = preload("res://meshes/floor_slope_east.tscn")
	var floorw_mesh = preload("res://meshes/floor_slope_west.tscn")
	var ceilingmesh = preload("res://meshes/ceiling.tscn")
	var wallmesh = preload("res://meshes/wall.tscn")
	var wallslopemesha = preload("res://meshes/wall_slope_a.tscn")
	var wallslopemeshb = preload("res://meshes/wall_slope_b.tscn")
	var mymaterial = load("res://meshes/material.tres")
	
	var floors = level["textures"]["floors"]
	var walls = level["textures"]["walls"]
		
	
	for y in range(0,64):
		for x in range(0, 64):
			var tile = level["map"][y][x]
			if tile["shape"] != 0:
				
				# create floor tile
				var newtile
				
				if tile["shape"] == 6: newtile = floorn_mesh.instance()
				elif tile["shape"] == 7: newtile = floors_mesh.instance()
				elif tile["shape"] == 8: newtile = floore_mesh.instance()
				elif tile["shape"] == 9: newtile = floorw_mesh.instance()
				else: newtile = floormesh.instance()
				
				var floortilenum = floors[tile["floor"]]
				newtile.get_node("Cube").set_surface_material(0,Persistent.floor32_mats[floortilenum])
				newtile.translation = Vector3(x*2, (float(tile["height"])/4)*2, y*2)
				$tiles.add_child(newtile)
				
				# create ceiling tile
				var newceiltile = ceilingmesh.instance()
				newceiltile.get_node("Cube").set_surface_material(0, Persistent.ceiling_mat)
				newceiltile.translation = Vector3(x*2, (float(16)/4)*2, y*2)
				$tiles.add_child(newceiltile)
				
				#var walltilenum = walls[tile["wall"]]
				# get wall height to the south
				var walls_h = 16
				var walls_l = 4
				var tile_south = null
				if y != 63:
					tile_south = level["map"][y+1][x]
					walls_h = tile_south["height"]
					walls_l = walls_h - tile["height"]
					if walls_l == 1 and tile["shape"] == 7: walls_l = 0
				if walls_l > 0:
					if walls_l < 4: walls_l = 4
					for w in range(0, ceil(float(walls_l)/4) ):
						var walls_mesh = wallmesh.instance()
						var wally = ( ( float(walls_h - (w*4)) / 4) - 1 )*2
						walls_mesh.get_node("Cube").set_surface_material(0,Persistent.wall64_mats[ walls[tile["wall"]] ])
						walls_mesh.rotation_degrees.y = 180
						walls_mesh.translation = Vector3(x*2, wally , y*2)
						$tiles.add_child(walls_mesh)
						
						if tile_south:
							if tile_south["shape"] == 8 || tile_south["shape"] == 9:
								var slopemesh
								if tile_south["shape"] == 9: slopemesh = wallslopemesha.instance()
								else: slopemesh = wallslopemeshb.instance()
								slopemesh.get_node("Cube").set_surface_material(0,Persistent.wall64_mats[ walls[tile["wall"]] ])
								slopemesh.rotation_degrees.y = 180
								slopemesh.translation = Vector3(x*2, wally+(1*2), y*2)
								$tiles.add_child(slopemesh)
					
				
	print("breakpoint")
	# set player position
	#setObjectToTile($player, Vector2(31,61) )
	
func setObjectToTile(var obj, var tile_pos):
	#obj.translation = Vector3( (tile_pos.x*2) + 1, ((16/4)-4)*2, (tile_pos.y*2) + 1 )
	obj.translation = Vector3( (tile_pos.x*2) + 1, ((16/4))*2, (tile_pos.y*2) + 1 )
