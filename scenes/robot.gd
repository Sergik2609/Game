extends CharacterBody2D
@onready var tilemap = $"../TileMap"
var SPEED = 50.0
const JUMP_VELOCITY = -350.0
var state = "idle"
var hp = 25
var direction = 0
var target_x = 0
var target_y = 0
var chasing = false
var dir = 0
var Ydirection = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

func _physics_process(delta):
	if direction:
		velocity.x = direction * SPEED
		velocity.y = 0 
		move_and_slide()
	if Ydirection:
		velocity.x = 0
		velocity.y = Ydirection * SPEED
		move_and_slide()
	elif state == "idle" && !chasing:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if hp < 1:
		get_tree().queue_delete(self)
func _on_area_2d_body_entered(body):
	if body.is_in_group("pl"):
		chasing = true
		state = "walk"
		chase(body)
func _on_area_2d_body_exited(body):
	if body.is_in_group("pl"):
		direction = 0
		Ydirection = 0
		chasing = false
		state = "idle"
		chase(null)
func dash():
	SPEED = 200.0
	state = "dash"
	await get_tree().create_timer(0.1).timeout
	SPEED = 50.0 
	state = "walk" 
func chase(target):
	while chasing:
			var px = target.global_position.x
			var py = target.global_position.y
			var m_pos =Vector2(px, py)
			var tile_m_pos = $TileMap.local_to_map(m_pos)
			if int(tile_m_pos.x) > int(tile_m_pos.x):
				direction = 1
			elif int(tile_m_pos.x) < int(tile_m_pos.x):
				direction = -1
			elif int(tile_m_pos.x) == int(tile_m_pos.x):
				direction = 0
			if int(tile_m_pos.y) < int(tile_m_pos.y):
				Ydirection = -1
			elif int(tile_m_pos.y) > int(tile_m_pos.y):
				Ydirection = 1
			elif int(tile_m_pos.y) == int(tile_m_pos.y):
				Ydirection = 0
			await get_tree().create_timer(randi_range(1,1.5)).timeout
	if !chasing:
		direction = 0
		Ydirection = 0



func _on_attack_body_entered(body):
	if body.is_in_group("pl"):
		body.hp -= 15
