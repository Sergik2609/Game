extends CharacterBody2D

var SPEED = 50.0
const JUMP_VELOCITY = -350.0
var state = "idle"
var hp = 25
var direction = 0
var target_x = 0
var target_y = 0
var chasing = false
var dir = 0
var jumping = false
var Ydirection = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0


func _physics_process(delta):
	$CPUParticles2D.direction = Vector2(direction*(-1),Ydirection*(-1))
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction:
		velocity.x = direction * SPEED
	if Ydirection:
		velocity.y = Ydirection * SPEED
	if direction && state == "walk":
		$AnimatedSprite2D.play("walk")
	elif state == "idle" && !chasing:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		$AnimatedSprite2D.play("default")
	elif state == "dash":
		$AnimatedSprite2D.play("atkHurt")
	move_and_slide()
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
			if target.global_position.x > self.global_position.x:
				direction = 1
			if target.global_position.x < self.global_position.x:
				direction = -1
			if target.global_position.x == self.global_position.x:
				direction = 0
			if target.global_position.y < self.global_position.y:
				Ydirection = -1
			if target.global_position.y > self.global_position.y:
				Ydirection = 1
			if target.global_position.y == self.global_position.y:
				Ydirection = 0
			await get_tree().create_timer(randi_range(1,1.5)).timeout
			dash()
	if !chasing:
		direction = 0
		Ydirection = 0



func _on_attack_body_entered(body):
	if body.is_in_group("pl"):
		body.hp -= 15
