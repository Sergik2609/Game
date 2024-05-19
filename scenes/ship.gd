extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var state = "fly"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor = false
func _ready():
	fly()
func _physics_process(delta):
	gravity = 2500
	if state == "land":
		velocity.y = gravity * delta
		move_and_slide()
		if on_floor:
			$AnimatedSprite2D.play("default")
			$door1.disabled = true
			$door2.disabled = true
		elif state == "fly":
			$door1.disabled = false
			$door2.disabled = false
func fly():
	while state == "fly":
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("flying")
		move_and_slide()
		await get_tree().create_timer(0.1).timeout
	


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("tile"):
		on_floor = true


func _on_area_2d_2_body_exited(body):
	if body.is_in_group("tile"):
		on_floor = false
