extends Node

func loadFontFile(var filename):
	
	var font_map = []
	var f = File.new()
	f.open(filename, File.READ)
	
	if !f.is_open():
		print("Error loading font file, can't open ",filename)
		return null
	
	# width is 2 bytes, always = 1
	var width = f.get_16()
	
	# size in bytes of a character
	var char_size = f.get_8() | (f.get_8() << 8)
	
	# space pixel width of a character
	var space_pixels = f.get_8() | (f.get_8() << 8)
	
	# height in pixels
	var height_pixels = f.get_8() | (f.get_8() << 8)
	
	# row bytes - number of bytes in a row
	var row_bytes = f.get_8() | (f.get_8() << 8)
	
	# maximum width of a character in pixels
	var max_width_pixels = f.get_8() | (f.get_8() << 8)
	
	#print("Loading font from file:", filename)
	#print("character size (bytes):",char_size)
	#print("space char width (pixels):",space_pixels)
	#print("height (pixels):", height_pixels)
	#print("bytes in row:",row_bytes)
	#print("max width (pixels):", max_width_pixels)
	#print("total characters:", (f.get_len()-12) / (char_size+1) )
	
	for font_entry in range(0, (f.get_len()-12) / (char_size+1)):
		var new_char = []
		var row_data = []
		for row in range(0, char_size):
			row_data.push_back(f.get_8())
		var cur_width = f.get_8()
		#print(font_entry," font char width:", cur_width)
		#for y in range(0, row_data.size()):
		#for y in range(0, height_pixels):
		#	new_char.push_back([])
		#	for x in range(0, cur_width):
		#		new_char[y].push_back( (row_data[y] >> (7-x)) & 0x1)
		
		for y in range(0, height_pixels):
			new_char.push_back([])
			for byte_in_row in range(0, row_bytes):
				var byte_width
				if byte_in_row < row_bytes-1: byte_width = 8
				else: byte_width = cur_width - (byte_in_row*8)

				for bit in range(0, byte_width):
					new_char[y].push_back( (row_data[(y*row_bytes) + byte_in_row] >> (7-bit)) & 0x1)
		
		font_map.push_back(new_char)
	
	f.close()
	return font_map

func new_font_from_map(var font_map):
	
	var fonts = []
	
	
	for fontindex in range(0, font_map.size()):
		var w = font_map[fontindex][0].size()
		var h = font_map[fontindex].size()
		var newimage = Image.new()	
		if w == 0:
			newimage.create( 1, 1, false, Image.FORMAT_RGBA8)
			fonts.push_back(newimage)
		else:
			newimage.create( w, h, false, Image.FORMAT_RGBA8)
			newimage.lock()
			for iy in range(0, h):
				for ix in range(0, w):
					if font_map[fontindex][iy][ix] != 0:
						newimage.set_pixel(ix, iy, Color(1,1,1))
			newimage.unlock()
			fonts.push_back(newimage)
		
	return fonts
