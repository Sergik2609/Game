extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var state = "idle"
var hp = 5
var direction = 0
var target_x = 0
var target_y = 0
var chasing = false
var dir = 0
var jumping = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	while true:
		dir = randi_range(-1,1)
		await get_tree().create_timer(randi_range(1,2)).timeout
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction && state != "atk":
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
	elif !direction && is_on_floor() && state != "atk":
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("default")
	if state == "atk":
		direction = 0
	move_and_slide()
	if hp < 1:
		get_tree().queue_delete(self)
	if jumping:
		jump()
		jumping = false
func jump():
	if is_on_floor() && chasing && state != "atk":
		velocity.y = JUMP_VELOCITY
func _on_area_2d_body_entered(body):
	if body.is_in_group("pl"):
		chasing = true
		chase(body)
func _on_area_2d_body_exited(body):
	if body.is_in_group("pl"):
		chasing = false
		chase(null)
func chase(target):
	while chasing:
			await get_tree().create_timer(randi_range(0.5,1.5)).timeout
			if target.global_position.x > self.global_position.x && state != "atk":
				direction = 1
			elif target.global_position.x < self.global_position.x && state != "atk":
				direction = -1
			else:
				direction = 0
			if randi_range(1,10) > 7:
				jump()
	if !chasing:
		direction = 0


func _on_attack_body_entered(body):
	if body.is_in_group("pl"):
		body.hp -= 15
		var i = 0
		while i < 1:
			state = "atk"
			$AnimatedSprite2D.play("AtkHurt")
			await get_tree().create_timer(0.2).timeout
			i += 1
		state = "walk"
