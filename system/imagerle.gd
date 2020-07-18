extends Node

var codebits = 0
var buffer = 0
var buffer_bits = 0
var state = false
var nibs_read = 0
var file = null
var aux_pal = 0
var pixels = []

func readCode():
	buffer_bits -= codebits
	if buffer_bits < 0:
		buffer = (buffer << 8) | file.get_8()
		buffer_bits += 8
	return (buffer >> buffer_bits) & ((1 << codebits) -1)
	
func readCode2():
	var code1 = readCode()
	var code2 = readCode()
	return (code1 << 4) | code2

func readCode3():
	var code1 = readCode()
	var code2 = readCode()
	var code3 = readCode()
	return (code1 << 8) | (code2 << 4) | code3

func readCount():
	var value = readCode()
	
	if value != 0:
		return value
	value = readCode2()
	if value != 0:
		return value
	return readCode3()

func readAux():
	return Persistent.auxpals[aux_pal][readCode()]

func outputLine(var value, var count):
	for v in range(0, count):
		outputValue(value)

func outputValue(var value):
	pixels.push_back(value)

func getAuxPixels(var tfile, var tot_nibs,var pixelcount, var bitlen, var taux_pal):
	
	
	file = tfile
	aux_pal = taux_pal
	codebits = bitlen
	
	while(pixels.size() < pixelcount):
		
		var count = readCount()
		
		state = !state
		
		if state:
			if count == 2:
				var repeats = readCount()
				for r in range(0, repeats):
					count = readCount()
					var value = readAux()
					outputLine(value, count)
			elif count > 0:
				var value = readAux()
				outputLine(value, count)
		else:
			for r in range(0, count):
				outputValue(readAux())
	
	return pixels
	
