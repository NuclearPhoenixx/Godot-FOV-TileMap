extends Node2D
#
# FOV Tilemaps by Phoenix1747.
# https://github.com/Phoenix1747/Godot-FOV-Tilemaps
#

var map := {} # This dictionary will hold the complete map after loading.
var start_point := Vector2() # This is the very first point in the map dictionary.
var end_point := Vector2() # This is the very last point in the map dictionary.

var previous_camera_position := Vector2() # This var holds the previous camera position for "draw_map".
var previous_camera_zoom := Vector2() # This var holds the previous camera zoom for "draw_map".

func load_map(MapNode: TileMap): # This function generates the "map" dict for the tilemap "MapNode".
	var used_cells = MapNode.get_used_cells()
	
	for cell in used_cells: # Create all the sub-dictionaries for every used X coordinate.
		map[cell.x] = {}
	
	for cell in used_cells: # Copy all the tile values into the dict.
		map[cell.x][cell.y] = MapNode.get_cellv(cell)
	
	var rect = MapNode.get_used_rect() # Compute start and end point of the tilemap.
	start_point = rect.position
	end_point = rect.end


# This function draws the tilemap in the Camera's Viewport.
func draw_map(MapNode: TileMap, CameraNode: Camera2D, CellMargin: int=0):
	var camera_pos = CameraNode.get_camera_position() # The camera's position.
	
	if previous_camera_position == camera_pos and previous_camera_zoom == CameraNode.zoom:
		return # If the camera hasn't moved or zoomed in/out then return.
	
	var visible_res = CameraNode.get_viewport().size * CameraNode.zoom # Camera FOV aka all visible pixels.
	
	# Convert all global viewport world coordinates to map coordinates.
	var top_left = MapNode.world_to_map(camera_pos - visible_res/2) - Vector2(CellMargin, CellMargin)
	var bottom_right = MapNode.world_to_map(camera_pos + visible_res/2) + Vector2(CellMargin, CellMargin)
	
	var rect = Rect2(top_left, bottom_right - top_left) # Compute the (still) visible rect of tiles
	var vis_rect = MapNode.get_used_rect().clip(rect)
	
	# Get all the cells that have a tile set to them.
	# Clear only these cells and only if they are outside of the Camera FOV Rect.
	# == only clear previously set and no longer visible cells.
	for cell in MapNode.get_used_cells():
		if not (vis_rect.has_point(cell) or  MapNode.get_cellv(cell) == -1):
			MapNode.set_cellv(cell,-1)
	
	var x = top_left.x # top_left X coordinate that is added up 1 until it reaches bottom_right.
	vis_rect = MapNode.get_used_rect()

	# Go through all cells in the camera FOV and do the magic.
	while x <= bottom_right.x:
		if map.has(x): # Check if the X value is in the bounds of the saved map dict.
			var y = top_left.y # top_left Y coordinate that is added up 1 until it reaches bottom_right.
			while y <= bottom_right.y:
				if not vis_rect.has_point(Vector2(x,y)): # Only do points that are visible.
					if map[x].has(y): # Check if the Y value is in the bounds of the saved map dict.
						if MapNode.get_cell(x,y) == -1: # Only set cells that are new to the Camera FOV.
							MapNode.set_cell(x, y, map[x][y])
				y += 1
		x += 1
	
	previous_camera_position = CameraNode.position # Update all the previous Camera vars.
	previous_camera_zoom = CameraNode.zoom


#This function updates a single cell's tile.
func update_cell(MapNode: TileMap, PositionVector: Vector2, TileID: int):
	map[PositionVector.x][PositionVector.y] = TileID
	MapNode.set_cellv(PositionVector, TileID)


# This function re-builds the whole tilemap from the map dict.
func rebuild_map(MapNode: TileMap):
	for x in map.keys():
		for y in map[x]:
			MapNode.set_cell(x, y, map[x][y])
