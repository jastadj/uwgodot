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
	var mymaterial = load("res://meshes/material.tres")
	
	var floors = level["textures"]["floors"]
	var walls = level["textures"]["walls"]
		
	
	for y in range(0,64):
		for x in range(0, 64):
			var tile = level["map"][y][x]
			if tile["shape"] != 0:
				
				# create floor tile
				var newtile
				var wallsouth = false
				var wallnorth = false
				var walleast = false
				var wallwest = false
				
				if tile["shape"] == 6: newtile = floorn_mesh.instance()
				elif tile["shape"] == 7: newtile = floors_mesh.instance()
				elif tile["shape"] == 8: newtile = floore_mesh.instance()
				elif tile["shape"] == 9: newtile = floorw_mesh.instance()
				else: newtile = floormesh.instance()
				
				var floortilenum = floors[tile["floor"]]
				newtile.get_node("Cube").set_surface_material(0,Persistent.floor32_mats[floortilenum])
				newtile.translation = Vector3(x*2, float(tile["height"])/4*2, y*2)
				$tiles.add_child(newtile)
				
				# create ceiling tile
				var newceiltile = ceilingmesh.instance()
				newceiltile.get_node("Cube").set_surface_material(0, Persistent.ceiling_mat)
				newceiltile.translation = Vector3(x*2, 16/4*2, y*2)
				$tiles.add_child(newceiltile)
				
				var walltilenum = walls[tile["wall"]]
				
				# check tile to the south
				var wallsouth_h = ((16/4)-1)*2
				var wallsouth_l = 4
				if y < 64-2:
					wallsouth_l = level["map"][y+1][x]["height"] - level["map"][y][x]["height"]
					if level["map"][y+1][x]["shape"] == 0:
						wallsouth = true
						wallsouth_l = 16 - level["map"][y][x]["height"]
					elif wallsouth_l > 0:
						if wallsouth_l == 1 and level["map"][y][x]["shape"] == 7:
							pass
						else:
							wallsouth_h = ((level["map"][y][x]["height"] + wallsouth_l - 1)/4)*2
							wallsouth = true
				else:
					wallsouth = true
					wallsouth_l = 15 - level["map"][y][x]["height"]
				if wallsouth:
					for w in range(0, (wallsouth_l/4)+1):
						var wallstile
						wallstile = wallmesh.instance()
						wallstile.get_node("Cube").set_surface_material(0,Persistent.wall64_mats[walltilenum])
						wallstile.translation = Vector3(x*2, wallsouth_h-(w*2), y*2)
						wallstile.rotation_degrees.y = 180
						#newtile.add_child(wallstile)
						$tiles.add_child(wallstile)
						
				# check tile to the north
				var wallnorth_h = ((16/4)-1)*2
				var wallnorth_l = 4
				if y > 0:
					wallnorth_l = level["map"][y-1][x]["height"] - level["map"][y][x]["height"]
					if level["map"][y-1][x]["shape"] == 0:
						wallnorth = true
						wallnorth_l = 16 - level["map"][y][x]["height"]
					elif wallnorth_l > 0:
						if wallnorth_l == 1 and level["map"][y][x]["shape"] == 7:
							pass
						else:
							wallnorth_h = ((level["map"][y][x]["height"] + wallnorth_l - 1)/4)*2
							wallnorth = true
				else:
					wallnorth = true
					wallnorth_l = 15 - level["map"][y][x]["height"]
				if wallnorth:
					for w in range(0, (wallnorth_l/4)+1):
						var wallntile
						wallntile = wallmesh.instance()
						wallntile.get_node("Cube").set_surface_material(0,Persistent.wall64_mats[walltilenum])
						wallntile.translation = Vector3(x*2, wallnorth_h-(w*2), y*2)
						#wallntile.rotation_degrees.y = 180
						#newtile.add_child(wallstile)
						$tiles.add_child(wallntile)
	
	# set player position
	#setObjectToTile($player, Vector2(31,61) )
	
func setObjectToTile(var obj, var tile_pos):
	#obj.translation = Vector3( (tile_pos.x*2) + 1, ((16/4)-4)*2, (tile_pos.y*2) + 1 )
	obj.translation = Vector3( (tile_pos.x*2) + 1, ((16/4))*2, (tile_pos.y*2) + 1 )
