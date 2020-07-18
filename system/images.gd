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
			
			# format 10 = 
			elif bitmap_format == 0xa:
				pass
			else:
				print("ERROR, unknown bitmap format ",bitmap_format," in ", filename )			
				continue
			
			if rle_bits != null:
				
				# get aux pal to use
				var aux_pal = f.get_8()
				# get nibble count
				var nib_count = f.get_8() | (f.get_8() << 8)
				# get file position where bitmap data actually starts
				var bitmap_offset = f.get_position()
				
				var nibs = []
				var pixels = 0
				# get all nibbles in data
				for n in range(0, (nib_count/2)):
					var byte = f.get_8()
					var n1 = (byte >> 4) & 0xf
					nibs.push_back(n1)
					var n2 = byte & 0xf
					nibs.push_back(n2)
					if n == (nib_count/2)-1:
						if ((n*2)+1) < (nib_count-1):
							var next_byte = f.get_8()
							nibs.push_back( (next_byte >> 4) & 0xf)
				if bitmap == 6:
					pass
				# repeat and run records, starting with repeat record
				var repeat = 1
				
				var cur_nib = 0
				while(cur_nib < nib_count):
					
					# get record count
					# get nib, if non-zero it is count, else, get two more nibs and check, and finally get 3 more nibs
					var count = nibs[cur_nib]
					cur_nib += 1
					if count == 0:
						count = nibs[cur_nib] << 4 | nibs[cur_nib+1]
						cur_nib += 2
						if count == 0:
							count = (nibs[cur_nib+1] << 4 | nibs[cur_nib+2]) << 4 | nibs[cur_nib+3]
							cur_nib += 3
					else:
						if count == 1:
							repeat = 0
							continue
						elif count == 2:
							var repeats = nibs[cur_nib]
							cur_nib += 1
							
							var count2 = nibs[cur_nib]
							cur_nib += 1
							
							for r in range(0, count2):
								if count2 == 0:
									count2 = nibs[cur_nib] << 4 | nibs[cur_nib+1]
									cur_nib += 2
									if count2 == 0:
										count2 = (nibs[cur_nib+1] << 4 | nibs[cur_nib+2]) << 4 | nibs[cur_nib+3]
										cur_nib += 3
										
							for r in range(0, repeats):
								var repeat_nib = nibs[cur_nib]
								cur_nib += 1
								for rn in range(0, count2):
									var py = (rn+pixels) / image_width
									var px = (rn+pixels) - (py*image_width)
									newimg.set_pixel(px, py, Persistent.palettes[0][Persistent.auxpals[aux_pal][nibs[cur_nib]] ] )
									pixels += 1
								repeat = 0
					
					if repeat == 1:
						var repeat_nib = nibs[cur_nib]
						cur_nib += 1
						for rn in range(0, count):
							var py = (rn+pixels) / image_width
							var px = (rn+pixels) - (py*image_width)
							newimg.set_pixel(px, py, Persistent.palettes[0][Persistent.auxpals[aux_pal][nibs[cur_nib]] ] )
							pixels += 1
						repeat = 0
							
					else:
						for rn in range(0, count):
							var py = (rn+pixels) / image_width
							var px = (rn+pixels) - (py*image_width)
							newimg.set_pixel(px, py, Persistent.palettes[0][ Persistent.auxpals[aux_pal][nibs[cur_nib]] ] )
							cur_nib += 1
							if cur_nib >= nib_count: break
							pixels += 1
						repeat = 0
						
					
			
			
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
