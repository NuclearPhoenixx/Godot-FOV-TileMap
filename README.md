# Godot-FOV-Tilemaps

Simple Godot 3.0+ script that allows TileMap manipulation depending on a Camera2D's FOV. It loads and unloads all cells depending on Camera2D position and settings.

It works by only setting map cells that are visible to the Camera2D node that you handed over to the functions. It's a side-project of mine and just a nice little experiment.
Note that Godot itself takes care of the TileMap rendering, but with much better performance (see "clipping"; also this script is "only" GDScript, not the faster C++ GDNative).

This allows you to, for example, easily work with a procedural map generator. You can add your generated cells to the map dictionary,
so that you only have to generate around the Camera2D FOV, but with a buffer of an arbitrary number of cells.
**Note:** Currently there is no *garbage collection* so if you add a cell to the map dictionary it will stay there forever
using more and more RAM when moving through your world.
If you plan on using it this way, you should implement a func that manipulates the map dictionary directly to delete old tiles.

You could also use this to have a very crude visual range effect if you set the `CellMargin` to a negative value,
which makes the visible TileMap smaller than the Camera2D FOV. More below at "Media".

Note that this script obviously introduces a clear performance loss, which also depends greatly on the Camera zoom, the Viewport size and the cell quadrant size;
more info about this below at "Comparison".
So if you want to use this in your own game be aware, or just rewrite it in GDNative.

The map dictionary is constructed like this:

```gdscript
Dictionary map = {
    int x0 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x1 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x2 : { int y0 : int TileID, int y1 : int TileID, ... },
    ...
}
```

The only file you will need to get started is this one: [fov_tilemap.gd](fov_tilemap.gd)

---

## Usage

Before you can actually use this, you have to have a TileMap and a Camera2D.
After you set the TileMap and Camera2D to your needs, import the script and run the following command to load the map for it:

```gdscript
load_map(MapNode: TileMap)
```
... where `MapNode` is your TileMap Node.

Then you can call the following whenever you want to update the map (preferably whenever the Camera2D has moved or e.g. in `_process()`).

```gdscript
draw_map(MapNode: TileMap, CameraNode: Camera2D, CellMargin: int=0)
```
...where `MapNode` is your Tilemap Node, `CameraNode` is your moving Camera2D Node and `CellMargin` is the margin of cells around your FOV
(e.g. 1 is one more cell and -1 is one cell less on each side of the Camera FOV; default: 0)

You can rebuild the whole map using the following function:
```gdscript
rebuild_map(MapNode: TileMap)
```
... which might be useful when turning off the plugin and rebuild your normal map.

To update a single tile within the map dict of this plugin you can use this command:

```gdscript
update_cell(MapNode: TileMap, PositionVector: Vector2, TileID: int)
```
... where `MapNode` is the TileMap Node for the tile, `PositionVector` is the tile position and `TileID` is the new tile texture number.

---

## Example

Conveniently, this repository is also a Godot testing project. By downloading this repo and importing it in Godot 3.0+ you can instantly see
and learn how this could be used and how the script works.

---

## Media

This is what it looks like if you set `CellMargin` to `1`:

![1 Margin](screenshots/gif1.gif)

No real difference, right? :)

This is what it looks like if you do not set any `CellMargin` (aka `0`):

![0 Margin](screenshots/gif2.gif)

Note that this screenshot has been taken while moving, when the camera doesn't move you can't really see any difference as well.

And finally, this is what it looks like if you use a negative (e.g. `-3`) `CellMargin`:

![-3 Margin](screenshots/gif3.gif)

That's the "very crude visual range effect" I have been talking about earlier.

---

## Comparison

**Environment: Tilemap 100x100 cells, 13 different tiles (20x20), Camera Scrolling Speed 200px/frame, script in _process(), VSYNC off else standard settings.**

**You can test it yourself, see "Example".**

|Camera Zoom: | 0.5 |	1.0 | 1.5 | 2.0 | Max RAM usage |
| --- | --- | --- | --- | --- | --- |
|FPS normal: | 1240 | 773 | 588 | 488 | 25 MB |
|FPS with this script: | 933 | 523 | 314 | 211 | 27 MB |

**Same Env as above, but this time with a Tilemap size 1000x1000:**

|Camera Zoom: | 0.5 |	1.0 | 1.5 | 2.0 | Max RAM usage |
| --- | --- | --- | --- | --- | --- |
|FPS normal: | 1762 | 1021 | 676 | 489 | 193 MB |
|FPS with this script: | 1720 | 833 | 454 | 277 | 325 MB |
