##
## FOV Tilemap by NuclearPhoenix.
## https://github.com/NuclearPhoenixx/Godot-FOV-Tilemaps
##
extends TileMap

class_name FovTileMap


## This is the Node Path to the relevant Camera2D Node.
export(NodePath) onready var CameraNode = get_node(CameraNode)
## This is the number of cells drawn on the border of the FOV.
## If negative, this number of cells will be removed from all sides inside the FOV.
## If positive, this number of cells will be additionally drawn just outside the FOV. 
export(int) var cell_margin := 0
## Enable FOV-drawing.
export(bool) var enabled := true setget _status_change
## Rebuild the whole map after FOV-drawing is disabled.
export(bool) var auto_rebuild := true

## This dictionary will hold the complete map after loading once.
var map := {} setget _map_update

var _start_point := Vector2() # This is the very first point in the map dictionary.
var _end_point := Vector2() # This is the very last point in the map dictionary.
var _previous_camera_position := Vector2() # This var holds the previous camera position for "draw_map".
var _previous_camera_zoom := Vector2() # This var holds the previous camera zoom for "draw_map".


## Load the entire TileMap when ready.
func _ready(): 
	load_map()


## Render the FOV-TileMap if enabled.
func _process(_delta):
	if enabled:
		_draw_map()


## Change TileMap behavior depending on enabled bool.
func _status_change(selected : bool):
	if enabled != selected:
		if selected:
			load_map()
		elif auto_rebuild:
			rebuild_map()
		
		enabled = selected


## If the map dictionary has been updated manually, reflect new changes.
func _map_update(new_map : Dictionary):
	map = new_map
	rebuild_map()
	load_map()


## This function loads an existing TileMap and generates the "map" dictionary used for FOV-drawing.
func load_map(): 
	_reset_vars() # Reset all possibly old map data.
	
	var used_cells = get_used_cells()
	
	for cell in used_cells: # Create all the sub-dictionaries for every used X coordinate.
		map[cell.x] = {}
	
	for cell in used_cells: # Copy all the tile values into the dict.
		map[cell.x][cell.y] = get_cellv(cell)
	
	var rect = get_used_rect() # Compute start and end point of the tilemap.
	_start_point = rect.position
	_end_point = rect.end


## This function draws the tilemap in the Camera's Viewport.
func _draw_map():
	var camera_pos = CameraNode.get_camera_position() # The camera's position.
	
	if _previous_camera_position == camera_pos and _previous_camera_zoom == CameraNode.zoom:
		return # If the camera hasn't moved or zoomed in/out then return.
	
	var visible_res = CameraNode.get_viewport().size * CameraNode.zoom # Camera FOV aka all visible pixels.
	
	# Convert all global viewport world coordinates to map coordinates.
	var top_left = world_to_map(camera_pos - visible_res/2) - Vector2(cell_margin, cell_margin)
	var bottom_right = world_to_map(camera_pos + visible_res/2) + Vector2(cell_margin, cell_margin)
	
	var rect = Rect2(top_left, bottom_right - top_left) # Compute the (still) visible rect of tiles
	var vis_rect = get_used_rect().clip(rect)
	
	# Get all the cells that have a tile set to them.
	# Clear only these cells and only if they are outside of the Camera FOV Rect.
	# == only clear previously set and no longer visible cells.
	for cell in get_used_cells():
		if not (vis_rect.has_point(cell) or  get_cellv(cell) == -1):
			set_cellv(cell,-1)
	
	var x = top_left.x # top_left X coordinate that is added up 1 until it reaches bottom_right.
	vis_rect = get_used_rect()

	# Go through all cells in the camera FOV and do the magic.
	while x <= bottom_right.x:
		if map.has(x): # Check if the X value is in the bounds of the saved map dict.
			var y = top_left.y # top_left Y coordinate that is added up 1 until it reaches bottom_right.
			while y <= bottom_right.y:
				if not vis_rect.has_point(Vector2(x,y)): # Only do points that are visible.
					if map[x].has(y): # Check if the Y value is in the bounds of the saved map dict.
						if get_cell(x,y) == -1: # Only set cells that are new to the Camera FOV.
							set_cell(x, y, map[x][y])
				y += 1
		x += 1
	
	_previous_camera_position = CameraNode.position # Update all the previous Camera vars.
	_previous_camera_zoom = CameraNode.zoom


#This function updates a single cell's tile. Not working quite as expected.
#func update_cell(PositionVector: Vector2, TileID: int):
#	map[PositionVector.x][PositionVector.y] = TileID
#	set_cellv(PositionVector, TileID)


## This function re-builds the whole tilemap from the map dict.
func rebuild_map():
	for x in map.keys():
		for y in map[x]:
			set_cell(x, y, map[x][y])


## Reset all the map-specific variables.
func _reset_vars():
	map.clear()
	_start_point = Vector2()
	_end_point = Vector2()

	_previous_camera_position = Vector2()
	_previous_camera_zoom = Vector2()
