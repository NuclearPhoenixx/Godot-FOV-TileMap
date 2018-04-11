extends Node2D
#
# FOV Tilemaps by Phoenix1747.
# https://github.com/Phoenix1747/Godot-FOV-Tilemaps
#
var map = {} #This dictionary will hold the complete map after loading.

func load_map(MapNode): #This function generates the "map" dict for the tilemap "MapNode".
	var used_cells = MapNode.get_used_cells()
	
	for cell in used_cells: #Create all the sub-dictionaries for every used X coordinate.
		map[cell.x] = {}
	
	for cell in used_cells: #Copy all the tile values into the dict.
		map[cell.x][cell.y] = MapNode.get_cellv(cell)

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
	
	MapNode.clear() #Clear all cells of the Tilemap.
	
	var x = top_left.x #top_left X coordinate that is added up 1 until it reaches bottom_right.x.
	
	while x <= bottom_right.x: #Go through all cells in the camera FOV and check if they are saved in the map dict.
		if map.has(x):
			var y = top_left.y #top_left Y coordinate that is added up 1 until it reaches bottom_right.y.
			
			while y <= bottom_right.y:
				if map[x].has(y):
					MapNode.set_cell(x,y,map[x][y])
				y += 1
		x += 1
	
	previous_camera_position = CameraNode.position #Update all the previous Camera vars.
	previous_camera_zoom = CameraNode.zoom

#This function adds a single cell to the tilemap.
func add_cell(MapNode, PositionVector, TileID):
	pass

#This function removes a single cell from the tilemap.
func delete_cell(MapNode, PositionVector):
	pass

#This function updates a single cell's tile.
func update_cell(MapNode, PositionVector, TileID):
	pass
