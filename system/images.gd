extends Node

func loadImageFile(var filename):

	var images = []
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
		
		var newimg = Image.new()
		
		# goto offset
		f.seek(offsets[bitmap])
		
		# read image at offset
		# -- file type 1 - images, multiple compression schemes
		if file_format == 1:
			var bitmap_format = f.get_8()
			var image_width = f.get_8()
			var image_height = f.get_8()
			var rle_bits = null
			
			if image_width == 0 or image_height == 0:
				print("Error, img size ",Vector2(image_width,image_height)," invalid in ",filename," @ 0x", offsets[bitmap])
				continue
			
			newimg.create(image_width, image_height, false, Image.FORMAT_RGBA8)
			newimg.lock()
			
			# format 4 = raw
			if bitmap_format == 4:
				var data_size = f.get_8() | (f.get_8() << 8)
				if data_size != image_width * image_height:
					print("warning, image data_size does not match w*h in ", filename, " @ 0x", offsets[bitmap] )
				for y in range(0, image_height):
					for x in range(0, image_width):
						newimg.set_pixel(x,y, Persistent.palettes[0][f.get_8()])
					
				
			# format 5 = 5-bit RLE
			elif bitmap_format == 6:
				rle_bits = 5
				
			# format 8 = 4-bit RLE
			elif bitmap_format == 8:
				rle_bits = 4
			else:
				print("ERROR, unknown bitmap format ",bitmap_format," in ", filename )			
				continue
			
			if rle_bits != null:
				pass
			

			
			newimg.unlock()
			images.push_back(newimg)
				
		# -- file type 2 - uniform squares, textures
		elif file_format == 2:
			newimg.create(img_size, img_size, false, Image.FORMAT_RGBA8)
			newimg.lock()
			for y in range(0, img_size):
				for x in range(0, img_size):
					newimg.set_pixel(x, y, Persistent.palettes[0][f.get_8()])

			newimg.unlock()
			images.push_back(newimg)
		else:
			print("ERROR, unknown file format ", file_format, " in ",filename)
	
	return images


static func new_image_texture_from_image(var image):
	var newimgtxt = ImageTexture.new()
	newimgtxt.create_from_image(image)
	newimgtxt.flags = newimgtxt.FLAG_REPEAT
	return newimgtxt

func new_material_from_image(var image):
	var newmat = SpatialMaterial.new()
	var newimgtxt = ImageTexture.new()
	newimgtxt.create_from_image(image)
	newimgtxt.flags = newimgtxt.FLAG_REPEAT
	newmat.albedo_texture = newimgtxt
	return newmat
