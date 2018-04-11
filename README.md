# Godot-FOV-Tilemaps

**This is work in progress!**

Simple script for Godot 3.0+ that shows any tilemap like normal but clears all cells outside of the Camera2D's FOV.

It works by only setting cells of the map that are visible to the Camera2D node that you handed over to the functions.

This allows you to load huge, expensive tilemaps without much performance impact, depending on the Camera FOV/Viewport of course.
You could also use it together with your procedural map generator.

If you want to generate infinite maps for example, you can work with the map dictionary that this script generates.
This allows you to change the tile id for any loaded map cell or even garbage collecting old parts of the map.

The dictionary is conscructed like so:

```python
Dictionary map = {
    int x0 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x1 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x2 : { int y0 : int TileID, int y1 : int TileID, ... },
    ...
}
```

The only file you will need is this one: [fov_tilemap.gd](fov_tilemap.gd)

---

## Usage

Before you can actually use this, you have to have a tilemap and a Camera2D. After you set the tilemap and camera to your needs, import the script and run the following command to load the map for it:

```python
load_map(MapNode)
```
... where `MapNode` is your Tilemap Node.

Then you can call the following whenever you want to update the map (preferably whenever the Camera2D has moved).

```python
draw_map(MapNode, CameraNode, CellMargin=0)
```
...where `MapNode` is you Tilemap Node, `CameraNode` is you Camera2D Node and `CellMargin` is the margin of cells around your FOV (e.g. 1 is one more cell and -1 is one cell less on each side of the Camera FOV; default: 0)

**More functions to come!**

---

## Example

This repository is conveniently a Godot testing project. By downloading this repo and importing it in Godot 3.0+, you can instantly see and learn how this would be used and how the script works.

---

## Comparison

This are my first simple performance test results with the same environment each.

**Environment: Tilemap 1000x100 cells, 13 different tiles (20x20), Quadrant Size 128, Camera Scrolling Speed 200px/frame, standard window size.**

**System: Medium-low spec laptop with dedicated graphics and Linux.**

|Camera Zoom: | 1.5 |	1.0 | 0.5 | Max RAM usage |
| --- | --- | --- | --- | --- |
|FPS normal: | 60 | 66 | 69 | 45.8 MB |
|FPS with this script: | 65	| 210 | 293	| 55.96 MB |

_Note that because of how this script works at the moment, it might actually look like the game stutters more than usually. This however depends greatly on your Viewport size and system specs._
