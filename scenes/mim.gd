extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0
var state = "idle"
var hp = 35
var direction = 0
var target_x = 0
var target_y = 0
var chasing = false
var dir = 0
var jumping = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction:
		velocity.x = direction * SPEED
		if direction && is_on_floor():
			$AnimatedSprite2D.play("walk")
	elif !direction && is_on_floor() && state == "idle" && !chasing:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("default")
	move_and_slide()
	if hp < 1:
		get_tree().queue_delete(self)
	if jumping:
		jump()
		jumping = false
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
func _on_area_2d_body_entered(body):
	if body.is_in_group("pl"):
		state = "tr"
		chasing = true
		$AnimatedSprite2D.play("transforming")
		await get_tree().create_timer(0.5).timeout
		chase(body)
func _on_area_2d_body_exited(body):
	if body.is_in_group("pl"):
		direction = 0
		state = "tr"
		chasing = false
		$AnimatedSprite2D.play("reversetr")
		await get_tree().create_timer(0.9).timeout
		state = "idle"
func chase(target):
	while chasing:
			if target.global_position.x > self.global_position.x:
				direction = 1
			elif target.global_position.x < self.global_position.x:
				direction = -1
			else:
				direction = 0
			jump()
			await get_tree().create_timer(randi_range(0.5,3)).timeout
	if !chasing:
		direction = 0




func _on_attack_body_entered(body):
	if body.is_in_group("pl"):
		body.hp -= 35

