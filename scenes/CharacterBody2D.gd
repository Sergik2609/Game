extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -80.0
var jetpack = 100
var max_jetpack = 100
var max_hp = 100
var hp = 100
var handed = "pickaxe"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var tilemap = $"../TileMap"
var damaged = false
var dmg = false
var wood = 0
var dirt =0
var rock = 0
var oranges = 0
var leaf = 0
var crystal = 0
var eye = 0
var bulbs = 0
var mushroom = 0
var max_amount = 99
var inv_open = false
var atkL = false
var atkR = false
var atkU = false
var atkD = false
var open_pc = false

func _ready():
	$Camera2D/pc/Label.text = str("Welcome to official U.W. OS
Write /help for info")
func _physics_process(delta):
	if Input.is_action_pressed("test"):
		get_tree().change_scene_to_file("res://scenes/test.tscn")
	$left.monitoring = false
	$right.monitoring = false
	$down.monitoring = false
	$up.monitoring = false
	
	if !open_pc:
		attacking()
		inv()
		inv_show()
	$Camera2D/inventory/leaves.play("default")
	$Camera2D/inventory/wood.play("default")
	$Camera2D/inventory/dirt.play("default")
	$Camera2D/inventory/organics.play("default")
	$Camera2D/inventory/bulbs.play("default")
	if !open_pc:
		hand()
	$ui.play("new_animation")
	$Camera2D/jet.value = jetpack
	$Camera2D/jet.max_value = max_jetpack
	$Camera2D/hp.value = hp
	$Camera2D/hp.max_value = max_hp
	if open_pc:
		$Camera2D/pc.show()
	else:
		$Camera2D/pc.hide()
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_pressed("z"):
		zoom()
	if hp < 0:
		await get_tree().create_timer(0.5).timeout
		get_tree().quit()
	if dmg:
		falling_dmg()
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		if jetpack<max_jetpack:
				jetpack+=1
	if jetpack == 0:
		$AnimatedSprite2D.play("fall")
		#print(velocity.y)
	if Input.is_action_pressed("ui_accept") && jetpack > 0 && !open_pc:
		jetpack-=1
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("fly")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction && !open_pc:
		velocity.x = direction * SPEED
		if !Input.is_action_pressed("ui_accept") && is_on_floor():
			$AnimatedSprite2D.play("walk")
			if jetpack<max_jetpack:
				jetpack+=1
		elif !is_on_floor() && !Input.is_action_pressed("ui_accept"):
			$AnimatedSprite2D.play("fall")
	elif !direction && !Input.is_action_pressed("ui_accept") && is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("default")
		
		if jetpack<max_jetpack:
				jetpack+=1
	if Input.is_action_pressed("-"):
		$"../".cave()
	if Input.is_action_pressed("digdown")or Input.is_action_pressed("digleft")or Input.is_action_pressed("digright") or Input.is_action_pressed("digup") && !open_pc:
		var yg = 0
		var xs = 0
		if Input.is_action_pressed("digdown"):
			yg = 15
		elif Input.is_action_pressed("digup"):
			yg = -15
		elif Input.is_action_pressed("digleft"):
			xs = -15
		elif Input.is_action_pressed("digright"):
			xs = 15
		var m_pos =Vector2i(self.global_position.x+xs,self.global_position.y+yg)
		var tile_m_pos = tilemap.local_to_map(m_pos)
		
		$AnimationPlayer.play("dig")
		var dirts = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1),Vector2i(0,2),Vector2i(1,2),Vector2i(2,2),Vector2i(3,2),Vector2i(0,4),Vector2i(1,4),Vector2i(2,4),Vector2i(3,4),Vector2i(0,5),Vector2i(1,5),Vector2i(2,5),Vector2i(3,5),Vector2i(0,6),Vector2i(1,6),Vector2i(2,6),Vector2i(3,6)]
		var rocks = [Vector2i(0,3),Vector2i(1,3),Vector2i(2,3),Vector2i(3,3)]
		var trees = [Vector2i(4,0),Vector2i(4,1),Vector2i(4,2),Vector2i(4,4),Vector2i(4,5),Vector2i(5,1),Vector2i(5,4),Vector2i(9,0),Vector2i(9,1),Vector2i(9,2),Vector2i(9,3),Vector2i(9,5)]
		var leaves = [Vector2i(5,0),Vector2i(5,2),Vector2i(5,5)]
		var mushrooms = [Vector2i(4,6),Vector2i(5,6),Vector2i(6,6),Vector2i(7,6),Vector2i(8,6)]
		var orange = [Vector2i(8,3)]
		var organics = [Vector2i(5,3)]
		var crystalix = [Vector2i(7,3)]
		var bulb = [Vector2i(7,4)]
		if tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in rocks && handed =="pickaxe":
			tilemap.set_cell(0,tile_m_pos,0,Vector2(4,3))
			if rock != max_amount:
				rock += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in orange && handed =="pickaxe":
			tilemap.set_cell(0,tile_m_pos,0,Vector2(4,3))
			if oranges != max_amount:oranges += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in crystalix && handed =="pickaxe":
			tilemap.set_cell(0,tile_m_pos,0,Vector2(4,3))
			if crystal != max_amount:crystal += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in organics && handed =="pickaxe":
			tilemap.set_cell(0,tile_m_pos,0,Vector2(4,3))
			if eye != max_amount:eye += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) == Vector2i(0,7):
			pass
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in trees && handed =="axe":
			tilemap.erase_cell(0,tile_m_pos)
			if wood != max_amount:wood += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in bulb && handed =="axe":
			tilemap.erase_cell(0,tile_m_pos)
			if bulbs != max_amount:bulbs += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in mushrooms && handed =="axe":
			tilemap.erase_cell(0,tile_m_pos)
			if mushroom != max_amount:mushroom += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in dirts && handed =="pickaxe":
			tilemap.set_cell(0,tile_m_pos,0,Vector2(4,3))
			if dirt != max_amount:dirt += 1
		elif tilemap.get_cell_atlas_coords(0,tile_m_pos,0) in leaves && handed =="sword":
			tilemap.erase_cell(0,tile_m_pos)
			if leaf != max_amount:leaf += 1
		print(tile_m_pos)
	else:
		$AnimationPlayer.play("RESET")
	move_and_slide()
	
func falling_dmg():
	if velocity.y > 750:
		await get_tree().create_timer(0.1).timeout
		if is_on_floor():
			damaged = true
			hp -= 10
			await get_tree().create_timer(0.5).timeout
			damaged = false
		
func hand():
	if Input.is_action_just_pressed("slot1"):
		$item.play("pickaxe")
		handed = "pickaxe"
	if Input.is_action_just_pressed("slot2"):
		$item.play("sword")
		handed = "sword"
	if Input.is_action_just_pressed("slot3"):
		$item.play("axe")
		handed = "axe"
func zoom():
	if Input.is_action_pressed("zoom+"):
		if $Camera2D.zoom < Vector2(5.5,5.5):
			$Camera2D.zoom += Vector2(0.1,0.1)
	if Input.is_action_pressed("zoom-"):
		if $Camera2D.zoom > Vector2(0.1,0.1):
			$Camera2D.zoom -= Vector2(0.1,0.1)
			

func inv():
	$Camera2D/inventory/wood/wood.text = str(wood,"/",max_amount)
	$Camera2D/inventory/dirt/lamps.text = str(dirt,"/",max_amount)
	$Camera2D/inventory/rocks/rocks.text = str(rock,"/",max_amount)
	$Camera2D/inventory/oranges/oranges.text = str(oranges,"/",max_amount)
	$Camera2D/inventory/crystaliy/crystal.text = str(crystal,"/",max_amount)
	$Camera2D/inventory/organics/eye.text = str(eye,"/",max_amount)
	$Camera2D/inventory/bulbs/lamps.text = str(bulbs,"/",max_amount)
	$Camera2D/inventory/mushroom/mush.text = str(mushroom,"/",max_amount)
	$Camera2D/inventory/leaves/leaves.text = str(leaf,"/",max_amount)
func inv_show():
	if !inv_open:
		$Camera2D/inventory.hide()
	else:$Camera2D/inventory.show()
	if Input.is_action_just_pressed("inv"):
		if !inv_open:
			inv_open = true
		else:
			inv_open = false
func attacking():
	if Input.is_action_pressed("digleft"):
		$left.monitoring = true
		atkL = true
		await get_tree().create_timer(0.1).timeout
		$left.monitoring = false
		atkL = false
	if Input.is_action_pressed("digright"):
		$right.monitoring = true
		atkR = true
		await get_tree().create_timer(1).timeout
		$right.monitoring = false
		atkR = false
	if Input.is_action_pressed("digdown"):
		$down.monitoring = true
		atkD = true
		await get_tree().create_timer(1).timeout
		$down.monitoring = false
		atkD = false
	if Input.is_action_pressed("digup"):
		atkU = true
		$up.monitoring = true
		await get_tree().create_timer(1).timeout
		$up.monitoring = false
		atkU = false
	
	
	



func _on_left_body_entered(body):
	if body.is_in_group("enemy"):
		if atkL:
			if handed == "sword":
				body.hp -= 0.3
			else:
				body.hp -= 0.1
			atkL = false


func _on_right_body_entered(body):
	if body.is_in_group("enemy"):
		if atkR:
			if handed == "sword":
				body.hp -= 0.3
			else:
				body.hp -= 0.1
			atkR = false

func _on_down_body_entered(body):
	if body.is_in_group("enemy"):
		if atkD:
			if handed == "sword":
				body.hp -= 0.3
			else:
				body.hp -= 0.1
			atkD = false


func _on_up_body_entered(body):
	if body.is_in_group("enemy"):
		if atkU:
			if handed == "sword":
				body.hp -= 0.3
			else:
				body.hp -= 0.1
			atkU = false

func _on_button_pressed():
	open_pc =false


func _on_line_edit_text_submitted(new_text):
	if new_text == "/help":
		$Camera2D/pc/Label.text = "/help - information
		/ship.launch - launch the ship
		/quota.check - find out the current quota
		/deadline.check - find out the number of days until delivery
		/inventory.store - storage all your inventory(impossible on the planet)
		/storage.check - find out the contents of your storage
		/exit - leave the computer"
	elif new_text == "/ship.launch":
		if $"../ship".state == "fly":
			self.position.x -= 20
			$"../ship/Area2D".monitoring = false
			$"../ship/Area2D2".monitoring = false
			$"../ship".state = "land"
			$"..".generate_world()
			$Camera2D/pc/LineEdit.text = str("")
			await get_tree().create_timer(18).timeout
			$"..".world_state = "exploring"
			$"../ship/Area2D2".monitoring = true
			$"../ship/Area2D".monitoring = true
		elif $"../ship".on_floor or $"../ship".state != "fly":
			$"../ship/Area2D".monitoring = false
			self.position.x -= 20
			$"../ship".state = "fly"
			$"../ship".fly()
			gravity = -200
			$"../ship/door1".disabled = false
			$"../ship/door2".disabled = false
			$Camera2D/pc/LineEdit.text = str("")
			$"..".world_state = "space"
			await get_tree().create_timer(18).timeout
			$"../ship/Area2D".monitoring = true
			gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
			$"..".del()
	elif new_text == "/exit":
		self.position.x -= 20
		$Camera2D/pc/LineEdit.text = str("")
	elif new_text == "/inventory.store":
		if !$"../ship".is_on_floor():
			$"..".wood = wood
			$"..".dirt = dirt
			$"..".rock = rock
			$"..".oranges = oranges
			$"..".leaf = leaf
			$"..".crystal = crystal
			$"..".eye = eye
			$"..".bulbs = bulbs
			$"..".mushroom = mushroom
			self.wood = 0
			self.dirt =0
			self.rock = 0
			self.oranges = 0
			self.leaf = 0
			self.crystal = 0
			self.eye = 0
			self.bulbs = 0
			self.mushroom = 0
			$Camera2D/pc/LineEdit.text = str("")
	elif new_text == "/storage.check":
		$Camera2D/pc/Label.text = str("woods:",$"..".wood, \
		 "\ndirts:",$"..".dirt, \
		 "\nrocks:",$"..".rock, \
		 "\noranges:",$"..".oranges, \
		"\nleaves:",$"..".leaf, \
		"\ncrystals:",$"..".crystal, \
		"\norganics:",$"..".eye, \
		"\nbulbs:",$"..".bulbs, \
		"\nmushrooms:",$"..".mushroom)
		$Camera2D/pc/LineEdit.text = str("")
	$Camera2D/pc/LineEdit.text = str("")
	
