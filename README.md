# Godot-FOV-TileMap
![latest version](https://img.shields.io/github/release/NuclearPhoenixx/Godot-FOV-TileMap.svg?style=for-the-badge) ![issues](https://img.shields.io/github/issues/NuclearPhoenixx/Godot-FOV-TileMap.svg?style=for-the-badge) ![open pr](https://img.shields.io/github/issues-pr-raw/NuclearPhoenixx/Godot-FOV-TileMap.svg?style=for-the-badge)

Simple Godot 3.0+ class that allows TileMap manipulation depending on a Camera2D's FOV. It loads and unloads all cells depending on Camera2D position and settings.

It works by only setting map cells that are visible to the Camera2D node, which you can select in the TileMap's settings tab. Note that Godot itself takes care of the TileMap rendering, but with much better performance (see [comparison](#comparison), and also this script is "only" GDScript, not the faster C++ GDNative).

This allows you to, for example, easily work with a **procedural map generator**. You can add your generated cells to the map dictionary, so that you only have to generate around the Camera2D's FOV, but with a buffer of an arbitrary number of cells so that players won't notice. If you combine this with Godot's `RandomNumberGenerator` class, you can generate tiles using a location-dependent seed and add them to the map when needed. This way you can delete them after some time to free up memory and when needed re-generate the tiles using the same location-dependent seed.

**Note:** Currently there is no *garbage collection* so if you add a cell to the map dictionary it will stay there forever. And if you add cells without deleting them they will be using more and more RAM when moving through your world, generating more and more of them. If you plan on using it this way, you should implement a function that manipulates the map dictionary directly to delete old tiles.

You could also use this to have a very crude visual range effect if you set the `CellMargin` to a negative value, which makes the visible TileMap smaller than the Camera2D FOV. More below at [media](#media).

Note that this script obviously introduces a clear performance loss, which also depends greatly on the Camera2D's zoom, the Viewport size and the cell quadrant size;
more info about this below at [comparison](#comparison).
So if you want to use this in your own game please be aware of that, or just rewrite it in GDNative.

**The only file you will need to get started is this one: [fov_tilemap.gd](fov_tilemap.gd)
It includes the latest `FovTileMap` class for use.**

You can also still use the old script which needs to be loaded and called manually to work: [fov_tilemap_script.gd](https://github.com/NuclearPhoenixx/Godot-FOV-TileMap/blob/v1.0.0/fov_tilemap.gd)
(Not Recommended)

## Usage

You only need to add the `fov_tilemap.gd` file to your project folder. As with all classes in Godot you can then add the new node called `FovTileMap` to your scene, although it will then already have its own script attached. This is OK if you don't need any special code for your TileMap or you don't mind working with the exisiting code.

The better way to use it, is just to add a standard `TileMap` node to the scene, attach a script and tell it to extend from the `FovTileMap` class like this:

```gdscript
extends FovTileMap
```

This will give you a clean, new script to begin with and all the FOV-TileMap functionality.

### Editor Settings

These are all the export variables that will be visible in the TileMap's settings tab:

```gdscript
export(NodePath) onready var CameraNode = get_node(CameraNode)
```

This is the Node Path to the relevant Camera2D Node. You can select any Camera2D node in your scene.

```gdscript
export(int) var cell_margin := 0
```

This is the number of cells drawn on the border of the FOV.
If negative, this number of cells will be removed from all sides inside the FOV.
If positive, this number of cells will be additionally drawn just outside the FOV.
Default: 0

```gdscript
export(bool) var enabled := true
```

Enable or disable FOV-drawing. Default: True

```gdscript
export(bool) var auto_rebuild := true
```

Rebuild the whole map after FOV-drawing is disabled. Default: True

### Functions

```gdscript
func load_map()
```

This function loads the existing TileMap that is drawn on the TileMap Node and generates the "map" dictionary used for FOV-drawing.
This deletes any old map and is automatically called from inside the TileMap's `_ready()` function. No manual calling needed.

Useful when generating a TileMap on the fly, after the TileMap's `_ready()` function already concluded.

```gdscript
func rebuild_map()
```

This function re-builds the whole TileMap from the map dictionary.

Can be used to force a re-draw of the whole map after disabling FOV-drawing. Will be automatically called after disabling FOV-drawing (setting `enabled` to `false`) if `auto_rebuild` is set to `true`.

### Map Dictionary

The map dictionary is structured like this:

```gdscript
Dictionary map = {
    int x0 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x1 : { int y0 : int TileID, int y1 : int TileID, ... },
    int x2 : { int y0 : int TileID, int y1 : int TileID, ... },
    ...
}
```

You can add and remove cells from this dictionary and the FOV-TileMap will automatically update accordingly - nothing else to do.
Note, however, that updating the map too often will likely result in a hefty performance loss as the entire map will be drawn once and then reloaded for every single map change call. So to circumvent this, you can try to cluster your adjustments and then change the map dictionary all at once.

## Example

Conveniently, this repository is also a Godot testing project. By downloading this repo and importing it in Godot 3.0+ you can instantly see
and learn how this could be used and how the script works. Default FOV `CellMargin` is set to 0.

A live web (HTML5) demo can be found [here](https://NuclearPhoenixx.github.io/Godot-FOV-TileMap/).

**Please note, however, that the performance of the web version is much worse than any native export.**

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

## Comparison

**Environment: Tilemap 100x100 cells, 13 different tiles (20x20), Camera Scrolling Speed 200px/frame, VSYNC off, else default settings.**

**You can test it yourself, see [example](#example).**

|Camera Zoom: | 0.5 |	1.0 | 1.5 | 2.0 | Max RAM usage |
| --- | --- | --- | --- | --- | --- |
|FPS normal: | 3016 | 2858 | 2688 | 2566 | 32.9 MiB |
|FPS with this script: | 2668 | 1985 | 1475 | 1089 | 32.1 MiB |

**Same Env as above, but this time with a Tilemap size 1000x1000:**

|Camera Zoom: | 0.5 |	1.0 | 1.5 | 2.0 | Max RAM usage |
| --- | --- | --- | --- | --- | --- |
|FPS normal: | 2637 | 2369 | 1934 | 1751 | 299.4 MiB |
|FPS with this script: | 2525 | 1309 | 837 | 546 | 330.4 MiB |
