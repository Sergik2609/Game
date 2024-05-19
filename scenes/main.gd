extends Node2D
@onready var tileMap = $TileMap
var surf_noise = FastNoiseLite.new()
var und_noise = FastNoiseLite.new()
var x1 = -300
var x2 = 300
var worldsize = abs(x1)+abs(x2)
var cave_noises = [FastNoiseLite.TYPE_VALUE_CUBIC,FastNoiseLite.TYPE_PERLIN,FastNoiseLite.TYPE_VALUE_CUBIC,FastNoiseLite.TYPE_PERLIN,FastNoiseLite.TYPE_SIMPLEX_SMOOTH]
var biomes = [0,1,2,4,5,6,8]
# 0 - grass, 1 - desert, 2 - snowland, 4 - cyberspace , 5 - dried swamp, 6 - mushroom hills, 8 - dark kingdom
var ores = [Vector2(8, 3), Vector2(7, 3), Vector2(5, 3)]
var enemies = [preload("res://scenes/sheep.tscn"), preload("res://scenes/crystal.tscn"),preload("res://scenes/lightguy.tscn"),preload("res://scenes/mimic.tscn")]
# 1-апельсиниум 2-кристаллий 3-органикс
var wood = 0
var dirt =0
var rock = 0
var oranges = 0
var leaf = 0
var crystal = 0
var eye = 0
var bulbs = 0
var mushroom = 0
var enemys_cur = 0
var enemys_max = 10
var world_state = "space"
func generate_world():
	for x in range(x1,x2):
		for y in range(100,30):
			$TileMap.set_cell(0,Vector2(x,y),0,Vector2(randi_range(0,2),3))
	surf_noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	und_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	surf_noise.seed = randi()
	und_noise.seed = randi()
	var l_border = x1
	#underground()
	#cave()
	while l_border <= worldsize/2:
		var biome_size = randi_range(100,200)
		generate_biome(l_border,l_border + biome_size,FastNoiseLite.TYPE_VALUE_CUBIC,randi_range(30,80),int(biomes.pick_random()))
		l_border += biome_size
	sasha_caves()
func generate_biome(x_left,x_right,noise_type,y_modifier,biome):
	surf_noise.noise_type = noise_type
	for x in range(x_left,x_right):
		var y_level = int(surf_noise.get_noise_2d(x,1)*y_modifier)
		var x_level = int(surf_noise.get_noise_2d(1,y_level)*300)
		if randi_range(0,100) > 90:
			var cell_coord = Vector2i(x+x_level,y_level)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(x+x_level,y_level),0,Vector2(randi_range(6,8),biome))
				$TileMap.set_cell(0,Vector2(x+x_level,y_level+1),0,Vector2(randi_range(0,3),biome))
		elif randi_range(0,1000) < 3:
			if randi_range(0,10) > 5:
				create_tower(x+x_level,y_level-15)
			else:
				create_abandoned_house(x+x_level,y_level-8)
		elif randi_range(0,50) > 48:
			tree(x+x_level,y_level,biome)
		for y in range(55,y_level,-1):
			x_level = int(surf_noise.get_noise_2d(1,y)*300)
			$TileMap.set_cell(0,Vector2(x+x_level,y),0,Vector2(randi_range(0,3),biome))
		
		y_level = int(surf_noise.get_noise_2d(x,20)*y_modifier+30)
		for y in range(100,y_level,-1):
			x_level = int(surf_noise.get_noise_2d(1,y)*300)
			#x_level *= randi_range(-1.5,1.5)
			$TileMap.set_cell(0,Vector2(x+x_level,y),0,Vector2(randi_range(0,2),3))
		
			
func tree(x,y,biome):
	
	var width = randi_range(2,4)
	
	if biome ==1 or biome ==4 or biome == 8:
		var height = randi_range(4,8)
		for yi in range(y-height,y+1):
			var cell_coord = Vector2i(x,yi+1)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(x,yi+1),0,Vector2(4,biome))
		var cell_coord = Vector2i(x,y-height)
		if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
			$TileMap.set_cell(0,Vector2(x,y-height),0,Vector2(5,biome))
		return
	#leaves
	elif biome ==0 or biome == 5 or biome == 6:
		var height = randi_range(3,5)
		for yi in range(y-height,y+1):
			var cell_coord = Vector2i(x,yi+1)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(x,yi+1),0,Vector2(4,biome))
		for xi in range(x-width,x+width):
			var cell_coord = Vector2i(xi,y-height)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(xi,y-height),0,Vector2(5,biome))
		for xi in range(x-width+randi_range(0,1),x+width-randi_range(0,1)):
			var cell_coord = Vector2i(xi,y-height-1)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(xi,y-height-1),0,Vector2(5,biome))
		for xi in range(x-width+1,x+width-1):
			var cell_coord = Vector2i(xi,y-height-2)
			if $TileMap.get_cell_atlas_coords(0,cell_coord,0) == Vector2i(-1,-1):
				$TileMap.set_cell(0,Vector2(xi,y-height-2),0,Vector2(5,biome))
	elif biome == 2:
		var height = 4
		for yi in range(y-height,y+1):
			$TileMap.set_cell(0,Vector2(x,yi+1),0,Vector2(4,biome))
		width = randi_range(3,5)
		for yi in range(y-height,y+1):
			$TileMap.set_cell(0,Vector2(x-1,yi+1),0,Vector2(4,biome))
		for xi in range(x-width,x+width):
			$TileMap.set_cell(0,Vector2(xi,y-1),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-4),0,Vector2(5,biome))
		for xi in range(x-width+1,x+width-1):
			$TileMap.set_cell(0,Vector2(xi,y-2),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-5),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-6),0,Vector2(5,biome))
		for xi in range(x-width+2,x+width-2):
			$TileMap.set_cell(0,Vector2(xi,y-3),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-6),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-7),0,Vector2(5,biome))
			$TileMap.set_cell(0,Vector2(xi,y-8),0,Vector2(5,biome))
		for xi in range(x-width+3,x+width-3):
			$TileMap.set_cell(0,Vector2(xi,y-9),0,Vector2(5,biome))

func sasha_caves():
	for x in range(x1+20, x2+60):
		for y in range(25, 95):
			if int(abs(und_noise.get_noise_2d(x, y)) * 7 * 50)%90 >70:
				$TileMap.set_cell(0,Vector2(x,y),0,Vector2(4,3))
			elif randi_range(0, 1000) > 999:
				create_ore(x, y)

# Функция спавна руды
func create_ore(x, y):
	var ore
	#Самая редкая руда, шанс приязан к высоте
	if randi_range(0, 90) + int(y / 10) > 80:
		if randi_range(0,10) > 5:
			ore = ores[2]
		else:
			create_underground_ruin(x,y)
			return
	elif randi_range(0, 100) > 70:
		ore = ores[1]
	else:
		ore = ores[0]
	
	for xi in range(x - 2, x + 2):
		for yi in range(y - 2, y + 2):
			if randi_range(0, 100) > 50:
				$TileMap.set_cell(0,Vector2(xi,yi),0, ore)
func create_tower(x,y):
	var pattern =$TileMap.tile_set.get_pattern(0)
	$TileMap.set_pattern(0, Vector2i(x,y), pattern)
func create_abandoned_house(x,y):
	var pattern =$TileMap.tile_set.get_pattern(randi_range(1,3))
	$TileMap.set_pattern(0, Vector2i(x,y), pattern)
func create_underground_ruin(x,y):
	var pattern =$TileMap.tile_set.get_pattern(randi_range(4,6))
	$TileMap.set_pattern(0, Vector2i(x,y), pattern)
func cave():
	var depth = randi_range(35,85)
	var notdepth = randi_range(x1+5,x2-5)
	und_noise.noise_type = cave_noises.pick_random()
	und_noise.seed = randi()
	for x in range(randi_range(-45,-10),randi_range(10,45)):  
		for y in range(int(und_noise.get_noise_2d(x,1)*(randi_range(-10,-20))+0),int(und_noise.get_noise_2d(x,1)*randi_range(10,20)+0),-1):
			$TileMap.set_cell(0,Vector2(x+notdepth,y+depth),0,Vector2(4,3))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemys_cur < enemys_max and randi_range(0, 1000) < 5:
		var pos = find_empty_pos()
		if pos != null && world_state == "exploring":
			spawn(pos)

func find_empty_pos():
	var px = $CharacterBody2D.global_position.x
	var py = $CharacterBody2D.global_position.y
	var m_pos =Vector2(px, py)
	var tile_m_pos = $TileMap.local_to_map(m_pos)
	var pos_set = []
	for x1 in range(tile_m_pos[0] - 75, tile_m_pos[0] - 50):
		for y1 in range(tile_m_pos[1] - 10, tile_m_pos[0] + 10):
			if $TileMap.get_cell_atlas_coords(0,Vector2(x1, y1),0) == Vector2i(-1,-1):
				pos_set.append($TileMap.map_to_local(Vector2(x1, y1)))
	for x1 in range(tile_m_pos[0] + 50, tile_m_pos[0] + 75):
		for y1 in range(tile_m_pos[1] - 10, tile_m_pos[0] + 10):
			if $TileMap.get_cell_atlas_coords(0,Vector2(x1, y1),0) == Vector2i(-1,-1):
				pos_set.append($TileMap.map_to_local(Vector2(x1, y1)))
				#4,3
	if pos_set:
		return pos_set.pick_random()
	else:
		return null
func spawn(pos):
	var enemy = enemies.pick_random()
	var enemyspawn = enemy.instantiate()
	enemyspawn.position = pos
	self.add_child(enemyspawn)
	enemys_cur += 1
func _on_area_2d_body_entered(body):
	if body.is_in_group("pl"):
		body.open_pc = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("pl"):
		body.open_pc = false
func del():
	for x in range(-350,550):
		for y in range(-100,100):
			var tile_m_pos = Vector2i(x,y)
			
			tileMap.erase_cell(0,tile_m_pos)
	print("AAAAAAAa")
	
