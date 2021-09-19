GDPC                                                                               @   res://.import/tiles.png-20e12ed313f9b52ca4483ea23302e684.stex   �      �      ���t���(�ٓ�<�S   res://fov_tilemap.gd.remap  �9      &       ��=� ��{�>���F   res://fov_tilemap.gdc   P      ?
      S��4XO�؇T�6!�   res://main.tscn �            �¤;&?gd��A8L;   res://project.binary�9      *      �\�zğ�������i   res://tiles.png.import  `      �      ��
�#�V��f�"   res://tileset.tres  �       k      �o�����	�@��[   res://tilesheet.tscn`/      
      ���p�d����4�**GDSC   ,      Q        ���ӄ�   ��ƶ   ����������¶   ��������¶��   �����������������������ض���   �������������������۶���   �������ƶ���   ������Ӷ   ������ƶ   ���������Ŷ�   �������������Ŷ�   ���ڶ���   ζ��   ϶��   ������������   ���¶���   ������������¶��   �������ض���   ��Ҷ   �������ƶ���   ���������Ӷ�   �����ׄ򶶶�   ���������ض�   ���������Ŷ�   ������������������ض   ���۶���   ����������Ŷ   �����������¶���   ���Ӷ���   �������¶���   �����������ƶ���   �����������¶���   �������¶���   ���ƶ���   ��������¶��   ������������   ��Ŷ   �������ڶ���   �������ڶ���   ����������ڶ   �������������Ķ�   ������   ����������ƶ   ���Ŷ���                                                                       	      
         '      /      0      9      B      C      I      S      T      Z      m      n      w      }      �      �      �      �      �      �      �       �   !   �   "   �   #   �   $   �   %   �   &   �   '   �   (   �   )   �   *     +   	  ,   
  -     .     /     0   ,  1   6  2   7  3   >  4   F  5   G  6   H  7   P  8   Y  9   `  :   h  ;   w  <   �  =   �  >   �  ?   �  @   �  A   �  B   �  C   �  D   �  E   �  F   �  G   �  H   �  I   �  J   �  K   �  L   �  M   �  N   �  O     P     Q   3YYYYYY;�  VNOY;�  V�  PQY;�  V�  PQYY;�  V�  PQY;�  V�  PQYY0�  P�  V�  QV�  ;�	  �  T�
  PQ�  �  )�  �	  V�  �  L�  T�  MNO�  �  )�  �	  V�  �  L�  T�  ML�  T�  M�  T�  P�  Q�  �  ;�  �  T�  PQ�  �  �  T�  �  �  �  T�  YYYY0�  P�  V�  R�  V�  R�  V�  QV�  ;�  �  T�  PQ�  �  &�  �  �  �  T�  V�  .�  �  ;�  �  T�  PQT�  �  T�  �  �  �  ;�  �  T�  P�  �  �  Q�  P�  R�  Q�  ;�  �  T�  P�  �  �  Q�  P�  R�  Q�  �  ;�  �  P�  R�  �  Q�  ;�   �  T�  PQT�!  P�  Q�  �  �  �  �  )�  �  T�
  PQV�  &P�   T�"  P�  Q�  T�  P�  Q�  QV�  �  T�#  P�  R�  Q�  �  ;�  �  T�  �  �   �  T�  PQY�  �  *�  
�  T�  V�  &�  T�$  P�  QV�  ;�  �  T�  �  *�  
�  T�  V�  &�   T�"  P�  P�  R�  QQV�  &�  L�  MT�$  P�  QV�  &�  T�%  P�  R�  Q�  V�  �  T�&  P�  R�  R�  L�  ML�  MQ�  �  �  �  �  �  �  �  �  �  T�  �  �  �  T�  YYYY0�'  P�  V�  R�(  V�  R�)  V�  QV�  �  L�(  T�  ML�(  T�  M�)  �  �  T�#  P�(  R�)  QYYYY0�*  P�  V�  QV�  )�  �  T�+  PQV�  )�  �  L�  MV�  �  T�&  P�  R�  R�  L�  ML�  MQY` [gd_scene load_steps=4 format=2]

[ext_resource path="res://tileset.tres" type="TileSet" id=1]

[sub_resource type="GDScript" id=1]
script/source = "extends Node2D

var ftm := preload(\"res://fov_tilemap.gd\").new() # Import the script
var FPS := [] # Array for FPS measurements

onready var Map := $Map # Grab the map node once
onready var Camera := $Camera # Get camera node once

func _ready():
	# Spawn random tiles for 100x100 cells.
	var x = 0
	var y = 0
	while x < 100:
		while y < 100:
			Map.set_cell(x,y,randi()%13)
			y += 1
		y = 0
		x += 1
	
	Map.set_cell(2,3,-1)
	
	ftm.load_map(Map) # Load the map into the script


func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		var avg = 0
		for fps in FPS:
			avg += fps
		avg = avg / FPS.size()
		print(\"Average FPS: \",avg)
		get_tree().quit()
	
	FPS.append(Performance.get_monitor(Performance.TIME_FPS)) # Log FPS each frame
	
	ftm.draw_map(Map, Camera, 1) # Update the tilemap every frame and set a margin of 1
"

[sub_resource type="GDScript" id=2]
script/source = "extends Camera2D

var addsub = Vector2(0.05,0.05) #Interval for zooming

func _unhandled_input(event): #Take care of camera zooming
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			if zoom < Vector2(1.45,1.45): #Max zoom: 1.5
				zoom += addsub
				position = get_camera_screen_center()
		
		elif event.button_index == BUTTON_WHEEL_UP:
			if zoom > Vector2(0.5,0.5): #Max zoom: 0.5
				zoom -= addsub
				position = get_camera_screen_center()
			
		get_tree().set_input_as_handled()

func _process(delta): #Take care of camera movement
	var pixelspeed = 200 #Speed of the camera in pixel/frame

	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		if get_position().y >= get_camera_position().y:
			position.y -= pixelspeed * delta
			get_tree().set_input_as_handled()
			
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		if get_position().y <= get_camera_position().y:
			position.y += pixelspeed * delta
			get_tree().set_input_as_handled()
			
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		if get_position().x <= get_camera_position().x:
			position.x += pixelspeed * delta
			get_tree().set_input_as_handled()
			
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		if get_position().x >= get_camera_position().x:
			position.x -= pixelspeed * delta
			get_tree().set_input_as_handled()
"

[node name="Main" type="Node2D"]
script = SubResource( 1 )

[node name="Map" type="TileMap" parent="."]
tile_set = ExtResource( 1 )
cell_size = Vector2( 20, 20 )
format = 1
tile_data = PoolIntArray( 131074, 11, 0, 131077, 11, 0, 131079, 11, 0, 131082, 11, 0, 196610, 11, 0, 196613, 11, 0, 196615, 11, 0, 196618, 11, 0, 262146, 11, 0, 262147, 11, 0, 262148, 11, 0, 262149, 11, 0, 262151, 11, 0, 262154, 11, 0, 327682, 11, 0, 327685, 11, 0, 327687, 11, 0, 393218, 11, 0, 393221, 11, 0, 393223, 11, 0, 393226, 11, 0 )

[node name="Camera" type="Camera2D" parent="."]
current = true
limit_smoothed = true
script = SubResource( 2 )
GDSTx   <            �  PNG �PNG

   IHDR   x   <   ��~�   sRGB ���  RIDATx���JA�k69H@���\���`@9x�9�����K �>@�'�=�!"��A�lN=��TwWw�����awg{���?U]�����6�s��cËU�i^z1�.=���b�86��x�WZ?��c����~�<����y
�
_�
L�$mp�N��D�������k�3���&���d���%�u_��z�I)�m�	��F�󔶏�-��nHN6P�/���1k�66��J�Tv�`��u3���6��=��Ԍ����v�J�\=�ut����ŷ�
����Y�4�g�R\��q�O��1Tjwݤ>QOTM%���d���S룫-r��T�J�I8r�^��E6�U���3� ��N�\����iP��S:�(�w�ߒ�K�<�9�KE�	S���_u�P|�8���[�������J��O%-��j�b{_J����D����T%}��f�>��������3$�H�k0��e�߫�}Z�Y��5t�!��iO:eXS�����l�}��*���w���g���F���'A �t�)�(cC���t��i�*Z���=����S�@��`S$S�vm��8��]�T�s��l����(oJ�����g���ٶG�N������B~����9���/�C���Aڋ�{�{T8ɦh<qH�as��ğ��(N�֢��i���~t�I��r-J3�7�drvw�Qx�k�A���zo���SK��l�]�0�zXSJ�dj�����2r����6AnUJ��MЛd������A�P5w�)�i3|�� \Qw��V��ԤIB&����óҦA�^,�V7�t��T
}�)�|�O�D���Da�r��$��ҷ��7+b��^���<�?�J��k�I/��%��D���/����ڄ�F�o�TaFg.����V�@�R�vM.G�i=���q͔�#XM"���^�^l�Ԇu���PǷ5�&-&��LЋ-���Kw�p���8_�}��M&��b.���ͣqO��f�u���q_�������1:�	Z�7����q!=����|p���Y�.�f��C`<=;(�V����ֹ����Q�n���'�f�f���h�O��uL�S��s�����oj�N�MR�HE�Oĩqu�JR��&[��gҥ�(.�fjK�G��  �����w�,1q��\D�#BG�������=i0�M����ĵA��\�&(s<���%�[�Az��)T�Flkd2Ѕ�F�t�ͥ�-�eYgk�iD��KL�,]tI���L��}�F8����1Ns�=�t+�2�k�k��I<l��X��k宱\=��uFu��7�+�?J �<Q�k��i���Tm��u��"��$RtGu�����64�    IEND�B`�        [remap]

importer="texture"
type="StreamTexture"
path="res://.import/tiles.png-20e12ed313f9b52ca4483ea23302e684.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://tiles.png"
dest_files=[ "res://.import/tiles.png-20e12ed313f9b52ca4483ea23302e684.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
            [gd_resource type="TileSet" load_steps=2 format=2]

[ext_resource path="res://tiles.png" type="Texture" id=1]

[resource]

0/name = "ground"
0/texture = ExtResource( 1 )
0/tex_offset = Vector2( 0, 0 )
0/modulate = Color( 1, 1, 1, 1 )
0/region = Rect2( 0, 0, 20, 20 )
0/is_autotile = false
0/occluder_offset = Vector2( 10, 10 )
0/navigation_offset = Vector2( 10, 10 )
0/shapes = [  ]
1/name = "ground2"
1/texture = ExtResource( 1 )
1/tex_offset = Vector2( 0, 0 )
1/modulate = Color( 1, 1, 1, 1 )
1/region = Rect2( 20, 0, 20, 20 )
1/is_autotile = false
1/occluder_offset = Vector2( 10, 10 )
1/navigation_offset = Vector2( 10, 10 )
1/shapes = [  ]
2/name = "ground3"
2/texture = ExtResource( 1 )
2/tex_offset = Vector2( 0, 0 )
2/modulate = Color( 1, 1, 1, 1 )
2/region = Rect2( 40, 0, 20, 20 )
2/is_autotile = false
2/occluder_offset = Vector2( 10, 10 )
2/navigation_offset = Vector2( 10, 10 )
2/shapes = [  ]
3/name = "ground4"
3/texture = ExtResource( 1 )
3/tex_offset = Vector2( 0, 0 )
3/modulate = Color( 1, 1, 1, 1 )
3/region = Rect2( 60, 0, 20, 20 )
3/is_autotile = false
3/occluder_offset = Vector2( 10, 10 )
3/navigation_offset = Vector2( 10, 10 )
3/shapes = [  ]
4/name = "ground5"
4/texture = ExtResource( 1 )
4/tex_offset = Vector2( 0, 0 )
4/modulate = Color( 1, 1, 1, 1 )
4/region = Rect2( 0, 20, 20, 20 )
4/is_autotile = false
4/occluder_offset = Vector2( 10, 10 )
4/navigation_offset = Vector2( 10, 10 )
4/shapes = [  ]
5/name = "ground6"
5/texture = ExtResource( 1 )
5/tex_offset = Vector2( 0, 0 )
5/modulate = Color( 1, 1, 1, 1 )
5/region = Rect2( 20, 20, 20, 20 )
5/is_autotile = false
5/occluder_offset = Vector2( 10, 10 )
5/navigation_offset = Vector2( 10, 10 )
5/shapes = [  ]
6/name = "ground7"
6/texture = ExtResource( 1 )
6/tex_offset = Vector2( 0, 0 )
6/modulate = Color( 1, 1, 1, 1 )
6/region = Rect2( 40, 20, 20, 20 )
6/is_autotile = false
6/occluder_offset = Vector2( 10, 10 )
6/navigation_offset = Vector2( 10, 10 )
6/shapes = [  ]
7/name = "ground8"
7/texture = ExtResource( 1 )
7/tex_offset = Vector2( 0, 0 )
7/modulate = Color( 1, 1, 1, 1 )
7/region = Rect2( 0, 40, 20, 20 )
7/is_autotile = false
7/occluder_offset = Vector2( 10, 10 )
7/navigation_offset = Vector2( 10, 10 )
7/shapes = [  ]
8/name = "ground9"
8/texture = ExtResource( 1 )
8/tex_offset = Vector2( 0, 0 )
8/modulate = Color( 1, 1, 1, 1 )
8/region = Rect2( 20, 40, 20, 20 )
8/is_autotile = false
8/occluder_offset = Vector2( 10, 10 )
8/navigation_offset = Vector2( 10, 10 )
8/shapes = [  ]
9/name = "ground10"
9/texture = ExtResource( 1 )
9/tex_offset = Vector2( 0, 0 )
9/modulate = Color( 1, 1, 1, 1 )
9/region = Rect2( 40, 40, 20, 20 )
9/is_autotile = false
9/occluder_offset = Vector2( 10, 10 )
9/navigation_offset = Vector2( 10, 10 )
9/shapes = [  ]
10/name = "ground11"
10/texture = ExtResource( 1 )
10/tex_offset = Vector2( 0, 0 )
10/modulate = Color( 1, 1, 1, 1 )
10/region = Rect2( 60, 40, 20, 20 )
10/is_autotile = false
10/occluder_offset = Vector2( 10, 10 )
10/navigation_offset = Vector2( 10, 10 )
10/shapes = [  ]
11/name = "ground12"
11/texture = ExtResource( 1 )
11/tex_offset = Vector2( 0, 0 )
11/modulate = Color( 1, 1, 1, 1 )
11/region = Rect2( 80, 40, 20, 20 )
11/is_autotile = false
11/occluder_offset = Vector2( 10, 10 )
11/navigation_offset = Vector2( 10, 10 )
11/shapes = [  ]
12/name = "ground13"
12/texture = ExtResource( 1 )
12/tex_offset = Vector2( 0, 0 )
12/modulate = Color( 1, 1, 1, 1 )
12/region = Rect2( 100, 40, 20, 20 )
12/is_autotile = false
12/occluder_offset = Vector2( 10, 10 )
12/navigation_offset = Vector2( 10, 10 )
12/shapes = [  ]

     [gd_scene load_steps=2 format=2]

[ext_resource path="res://tiles.png" type="Texture" id=1]

[node name="Node2D" type="Node2D" index="0"]

position = Vector2( 40, 50 )

[node name="ground" type="Sprite" parent="." index="0"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 0, 0, 20, 20 )

[node name="ground2" type="Sprite" parent="." index="1"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 20, 0, 20, 20 )

[node name="ground3" type="Sprite" parent="." index="2"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 40, 0, 20, 20 )

[node name="ground4" type="Sprite" parent="." index="3"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 60, 0, 20, 20 )

[node name="ground5" type="Sprite" parent="." index="4"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 0, 20, 20, 20 )

[node name="ground6" type="Sprite" parent="." index="5"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 20, 20, 20, 20 )

[node name="ground7" type="Sprite" parent="." index="6"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 40, 20, 20, 20 )

[node name="ground8" type="Sprite" parent="." index="7"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 0, 40, 20, 20 )

[node name="ground9" type="Sprite" parent="." index="8"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 20, 40, 20, 20 )

[node name="ground10" type="Sprite" parent="." index="9"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 40, 40, 20, 20 )

[node name="ground11" type="Sprite" parent="." index="10"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 60, 40, 20, 20 )

[node name="ground12" type="Sprite" parent="." index="11"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 80, 40, 20, 20 )

[node name="ground13" type="Sprite" parent="." index="12"]

position = Vector2( -30, -100 )
texture = ExtResource( 1 )
region_enabled = true
region_rect = Rect2( 100, 40, 20, 20 )


        [remap]

path="res://fov_tilemap.gdc"
          ECFG
      _global_script_classes             _global_script_class_icons             application/config/name         FOV Tilemaps   application/run/main_scene         res://main.tscn '   debug/gdscript/warnings/unused_argument             display/window/vsync/use_vsync          7   rendering/quality/intended_usage/framebuffer_allocation          >   rendering/quality/intended_usage/framebuffer_allocation.mobile          (   rendering/2d/snapping/use_gpu_pixel_snap         #   rendering/quality/2d/use_pixel_snap               