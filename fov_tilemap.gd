extends Node2D
#
# FOV Tilemaps by Phoenix1747.
# https://github.com/Phoenix1747/Godot-FOV-Tilemaps
#
var map = {} #This dictionary will hold the complete map after loading.

var start_point #This is the very first point in the map dictionary.
var end_point #This is the very last point in the map dictionary.

func load_map(MapNode): #This function generates the "map" dict for the tilemap "MapNode".
	var used_cells = MapNode.get_used_cells()
	
	for cell in used_cells: #Create all the sub-dictionaries for every used X coordinate.
		map[cell.x] = {}
	
	for cell in used_cells: #Copy all the tile values into the dict.
		map[cell.x][cell.y] = MapNode.get_cellv(cell)
	
	start_point = get_start_point()
	end_point = get_end_point()

var previous_camera_position #This var holds the previous camera position for "draw_map".
var previous_camera_zoom #This var holds the previous camera zoom for "draw_map".

#This function draws the tilemap in the Camera's Viewport.
func draw_map(MapNode, CameraNode, CellMargin=0):
	var camera_pos = CameraNode.get_camera_position() #The camera's position.
	
	if previous_camera_position == camera_pos and previous_camera_zoom == CameraNode.zoom:
		return #If the camera hasn't moved or zoomed in/out then return.
	
	var visible_res = CameraNode.get_viewport().size * CameraNode.zoom #Camera FOV aka all visible pixels.
	var top_left = camera_pos - (visible_res / 2) #Camera Viewport top left point.
	var bottom_right = top_left + visible_res #Camera Viewport bottom right point.
	
	#Convert all global world coordinates to map coordinates.
	top_left = MapNode.world_to_map(top_left) - Vector2(CellMargin, CellMargin)
	bottom_right = MapNode.world_to_map(bottom_right) + Vector2(CellMargin, CellMargin)
	
	#Get all the cells that have a tile set to them.
	#Clear only these cells if they are outside of the Camera FOV instead of everything.
	# == only clear previously set and no longer visible cells.
	for cell in MapNode.get_used_cells():
		if cell.x < top_left.x or cell.x > bottom_right.x or cell.y < top_left.y or cell.y > bottom_right.y:
			MapNode.set_cellv(cell,-1)
	
	var x = top_left.x #top_left X coordinate that is added up 1 until it reaches bottom_right.x.
	
	#Go through all cells in the camera FOV and do the magic.
	while x <= bottom_right.x:
		if x >= start_point.x and x <= end_point.x: #Check if the X value is in the bounds of the saved map dict.
			var y = top_left.y #top_left Y coordinate that is added up 1 until it reaches bottom_right.y.
			while y <= bottom_right.y:
				if MapNode.get_cell(x,y) == -1: #Only set cells that are new to the Camera FOV.
					if y >= start_point.y and y <= end_point.y: #Check if the Y value is in the bounds of the map.
						MapNode.set_cell(x, y, map[x][y])
				y += 1
		x += 1
	
	previous_camera_position = CameraNode.position #Update all the previous Camera vars.
	previous_camera_zoom = CameraNode.zoom

#This function adds a single cell to the tilemap.
func add_cell(MapNode, PositionVector, TileID):
	#WORK IN PROGRESS
	#DO SOMETHING AND DONT FORGET TO UPDATE START AND END POINT!
	pass

#This function removes a single cell from the tilemap.
func delete_cell(MapNode, PositionVector):
	#WORK IN PROGRESS
	#DO SOMETHING AND DONT FORGET TO UPDATE START AND END POINT!
	pass

#This function updates a single cell's tile.
func update_cell(MapNode, PositionVector, TileID):
	#WORK IN PROGRESS
	#DO SOMETHING AND DONT FORGET TO UPDATE START AND END POINT!
	pass

#This function removes any cells after a specific margin from the map.
func garbage_collect(MapNode, CellMargin=100):
	#WORK IN PROGRESS
	#DO SOMETHING AND DONT FORGET TO UPDATE START AND END POINT!
	pass

#This function retrieves the starting point of the map.
func get_start_point():
	var min_x
	var min_y
	
	for x in map.keys():
		for y in map[x].keys():
			min_y = y
			break #Save the very first Y value and break.
		min_x = x
		break #Save the very first X value and break.
	
	return Vector2(min_x, min_y)

#This function retrieves the ending point of the map.
func get_end_point():
	var max_x
	var max_y
	
	for x in map.keys():
		max_x = x #Save the very last X value.
	
	for y in map[max_x].keys():
		max_y = y #Save the very last Y value for the max_x value.
	
	return Vector2(max_x, max_y)

#This function re-builds the whole tilemap from the map dict.
func rebuild_map(MapNode):
	pass
