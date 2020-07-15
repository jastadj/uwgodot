extends Node

func loadImageFile(var filename):

	var imagemaps = []
	var offsets = []
	var img_size = null
	
	var f = File.new()
	f.open(filename, File.READ)
	
	if !f.is_open():
		print("Error loading image file:", filename)
		return null
	
	# determine file format and image count
	var file_format = f.get_8()
	if file_format == 2:
		img_size = f.get_8()
	var bitmap_count = f.get_8() | (f.get_8() << 8)
	
	# get all the image file offsets
	for bitmap_num in range(0, bitmap_count):
		var offs = f.get_8() | (f.get_8() << 8) | (f.get_8() << 16 ) | (f.get_8() << 24)
		offsets.push_back(offs)
	
	for bitmap in range(0, bitmap_count):
		# read image at offset
		# -- file type 1 - images, multiple compression schemes
		if file_format == 1:
			var bitmap_format = f.get_8()
			var image_width = f.get_8()
			var image_height = f.get_8()
			
			# format 4 = raw
			if bitmap_format == 4:
				pass
			# format 5 = 5-bit RLE
			elif bitmap_format == 6:
				pass
				
			# format 8 = 4-bit RLE
			elif bitmap_format == 8:
				pass
				
		# -- file type 2 - uniform squares, textures
		elif file_format == 2:
			
			var newimg = []
			for y in range(0, img_size):
				newimg.push_back([])
				for x in range(0, img_size):
					newimg[y].push_back(0)
							
			for y in range(0, img_size):
				for x in range(0, img_size):
					newimg[y][x] = f.get_8()
			
			imagemaps.push_back(newimg)
	
	return imagemaps

func new_image_from_map(var image_map, var pal ):
	var newimage = Image.new()
	var w = image_map.size()
	var h = image_map[0].size()
	
	newimage.create( w, h, false, Image.FORMAT_RGBA8)
	newimage.lock()
	for iy in range(0, h):
		for ix in range(0, w):
			var data = image_map[iy][ix]
			newimage.set_pixel(ix, iy, pal[data])
	newimage.unlock()
	
	return newimage
