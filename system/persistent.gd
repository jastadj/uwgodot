extends Node

# palettes
var palettes = []
var auxpals = []

# font maps
var font4x5pmap = []
var font5x6imap = []
var font5x6pmap = []
var fontbigmap = []

# fonts
var font4x5p = []
var font5x6i = []
var font5x6p = []
var fontbig = []

# image maps
var floor16_map = []
var floor32_map = []

# images
var floor16 = []
var floor32 = []

# materials
var floor32_mats = []

# levels
var levels = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_palettes()
	load_graphics()
	load_fonts()
	load_levels()
	
	
func load_palettes():
	
	var pal_loader = load("res://system/palettes.gd").new()
	
	# 256 pals.dat file
	# 8 main palettes
	# 0: main game
	# 1: map
	# 2: title screen
	# 3: char creation
	# 4: ?
	# 5: splash screen
	# 6: ?
	# 7: game ending
	palettes = pal_loader.load256PaletteFile("res://uw_data/UWDATA/PALS.DAT")
	print(palettes.size()," palettes loaded.")
	
	# 16 allpals.dat auxillary pal map file
	auxpals = pal_loader.load16PaletteFile("res://uw_data/UWDATA/ALLPALS.DAT")
	print(auxpals.size()," auxillary palettes loaded.")
	
func load_graphics():
	
	var img_loader = load("res://system/images.gd").new()
	
	# load floor16
	floor16_map = img_loader.loadImageFile("res://uw_data/UWDATA/F16.TR")
	print(floor16_map.size()," floor16 image maps loaded.")
	for i in range(0, floor16_map.size()):
		floor16.push_back( img_loader.new_image_from_map(floor16_map[i],palettes[0]))
	print(floor16.size(), "floor16 images created.")
	
	# load floor32
	floor32_map = img_loader.loadImageFile("res://uw_data/UWDATA/F32.TR")
	print(floor32_map.size()," floor32 image maps loaded.")
	for i in range(0, floor32_map.size()):
		floor32.push_back( img_loader.new_image_from_map(floor32_map[i],palettes[0]))
	print(floor32.size(), "floor32 images created.")
	
	# create floor32 materials
	for i in range(0, floor32.size()):
		floor32_mats.push_back(img_loader.new_material_from_image(floor32[i]))

func load_fonts():
	
	var font_loader = load("res://system/fonts.gd").new()
	
	# load font 4x5p
	font4x5pmap = font_loader.loadFontFile("res://uw_data/UWDATA/FONT4X5P.SYS")
	print(font4x5pmap.size()," font4x5p font maps loaded.")
	font4x5p = font_loader.new_font_from_map(font4x5pmap)
	print(font4x5p.size(), " font4x5p fonts loaded.")
	
	# load font 5x6i
	font5x6imap = font_loader.loadFontFile("res://uw_data/UWDATA/FONT5X6I.SYS")
	print(font5x6imap.size()," font5x6i font maps loaded.")
	font5x6i = font_loader.new_font_from_map(font5x6imap)
	print(font5x6i.size(), " font5x6i fonts loaded.")

	# load font 5x6p
	font5x6pmap = font_loader.loadFontFile("res://uw_data/UWDATA/FONT5X6P.SYS")
	print(font5x6pmap.size()," font5x6p font maps loaded.")
	font5x6p = font_loader.new_font_from_map(font5x6pmap)
	print(font5x6p.size(), " font5x6p fonts loaded.")

	# load font big
	fontbigmap = font_loader.loadFontFile("res://uw_data/UWDATA/FONTBIG.SYS")
	print(fontbigmap.size()," fontbig font maps loaded.")
	fontbig = font_loader.new_font_from_map(fontbigmap)
	print(fontbig.size(), " fontbig fonts loaded.")

func load_levels():
	
	var level_loader = load("res://system/levels.gd").new()
	
	# load main level file
	levels = level_loader.loadLevels("res://uw_data/UWDATA/LEV.ARK")
	print("Loaded ", levels.size(), " levels.")
