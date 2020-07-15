extends Node

func loadLevels(var filename):
	
	# for each level, store level data, texture list for floors and walls, and if a savegame level file,
	# read in save game data
	var levels = {"level":[], "texture":[], "save":[]}
	var chunk_offsets = []
	
	var f = File.new()
	f.open(filename, File.READ)
	
	if !f.is_open():
		print("Error opening level file:",filename)
		return null
	
	# get chunk count
	var chunk_count = f.get_8() | (f.get_8() << 8)
	print("Chunk count:",chunk_count)
	
	# get offsets
	for c in range(0, chunk_count):
		var chunk_offset = f.get_8() | f.get_8() << 8 | f.get_8() << 16 | f.get_8() << 24
		if chunk_offset != 0: chunk_offsets.push_back(chunk_offset)

	for c in range(0, chunk_offsets.size()):
		var chunk_size
		
		if c == chunk_offsets.size()-1: chunk_size = f.get_len() - chunk_offsets[c]
		else: chunk_size = chunk_offsets[c+1] - chunk_offsets[c]
		
		# move file pointer to offset
		f.seek(chunk_offsets[c])
		#print ("chunk offset = ", chunk_offsets[c], ", file @ ",f.get_position() )
		
		# if chunk is level data
		if chunk_size == 31752:
			var level_data = {"map":[], "mobs":[], "objs":[]}
			
			# get map tiles 64x64
			for tile_y in range(0, 64):
				level_data["map"].push_back([])
				for tile_x in range(0,64):
					var tile_data = f.get_8() | f.get_8() << 8 | f.get_8() << 16 | f.get_8() << 24
					var tile = {"shape": tile_data & 0xf, "height": (tile_data>>4) & 0xf, "floor": (tile_data>>10) & 0xf, "wall": (tile_data >> 16) & 0x3f, "first_obj": (tile_data>>22) & 0x3ff}
					
					level_data["map"][tile_y].push_back(tile)
			# flip map tiles in the y
			var unflipped = level_data["map"]
			for tile_y in range(0, 64):
				level_data["map"][63 - tile_y] = unflipped[tile_y]
			
			levels["level"].push_back(level_data)
		# if chunk is ???
		elif chunk_size == 384:
			pass
		# if chunk is texture list
		elif chunk_size == 122:
			var texture_data = {"walls":[], "floors":[]}
			
			for wall_index in range(0,48):
				texture_data["walls"].push_back( f.get_8() | f.get_8() << 8)
			
			for floor_index in range(0, 10):
				texture_data["floors"].push_back( f.get_8() | f.get_8() << 8)
			
			levels["texture"].push_back(texture_data)
		# if chunk is map data (save game)
		elif chunk_size == 4096:
			pass
		# unknown chunk type
		else:
			print("Level chunk with size ",chunk_size," is unknown.")
			continue
		
			
	
	f.close()
	return levels