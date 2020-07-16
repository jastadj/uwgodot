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

	
func loadLevel(var level):
	
	var floormesh = preload("res://meshes/floor.tscn")
	var mymaterial = load("res://meshes/material.tres")
	var floors = level["textures"]["floors"]
		
	
	for y in range(0,64):
		for x in range(0, 64):
			var tile = level["map"][y][x]
			if tile["shape"] != 0:
				var newtile = floormesh.instance()
				var floortilenum = level["textures"]["floors"][tile["floor"]]
				newtile.get_node("Cube").set_surface_material(0,Persistent.floor32_mats[floortilenum])
				newtile.translation = Vector3(x*2, float(tile["height"])/4*2, y*2)
				
				if false:
					var mdt = MeshDataTool.new() 
					var nd = newtile.get_node("Cube")
					var m = nd.get_mesh()
					#get surface 0 into mesh data tool
					mdt.create_from_surface(m, 0)
					for vtx in range(mdt.get_vertex_count()):
						var vert=mdt.get_vertex(vtx)
						if vtx == 0:
							vert.y = -20
							mdt.set_vertex(vtx, vert)
					#print("global vertex: "+str(nd.global_transform.xform(vert)))
				
				
				$tiles.add_child(newtile)
