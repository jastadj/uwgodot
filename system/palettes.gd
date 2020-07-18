extends Node


# 256 color palettes are stored sequentially, r, g, b
# 1 byte = intensity, index, range
func load256PaletteFile(var filename):
	
	var pals = []
	
	var f = File.new()
	f.open(filename, File.READ)
	
	if !f.is_open():
		print("Error loading 256 palette file:", filename)
		return null
	
	
	
	while(!f.eof_reached()):
		
		var pal256 = []
		
		var color_count = 0
		
		while(color_count < 256):
			#var r = f.get_8()
			#var g = f.get_8()
			#var b = f.get_8()
			
			#if color_count == 0: pal256.push_back(Color.transparent)
			#else: pal256.push_back( Color( float(f.get_8())/64, float(f.get_8())/64, float(f.get_8())/64) )
			pal256.push_back( Color( float(f.get_8())/64, float(f.get_8())/64, float(f.get_8())/64) )
			
			
			color_count += 1
		
		pals.push_back(pal256)
		
	return pals
	
func load16PaletteFile(var filename):
	var pals = []
	
	var f = File.new()
	f.open(filename, File.READ)
	
	if !f.is_open():
		print("Error loading 16 auxillary palette file:", filename)
		return null
	
	
	
	while(!f.eof_reached()):
		
		var pal16 = []
		
		var color_count = 0
		
		while(color_count < 16):
			pal16.push_back(f.get_8())
			color_count += 1
		
		pals.push_back(pal16)
		
	return pals
