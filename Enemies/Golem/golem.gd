extends CharacterBody2D

enum {MOVE, ATTACK}
@onready var spriteplayer = $AnimationPlayer
const speed = 25
const JUMP_VELOCITY = -400.0
var direction = 1
@onready var sprite = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var stop_move_speed = 0
@onready var vision = $Vision
var state = MOVE
@export var damage : int = 20
@export var health : float = 10
var stunned = false
func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		MOVE: move()
		ATTACK: attack()
	if is_on_wall():
		direction *= -1
		$".".transform.x *= -1


func move():
	spriteplayer.play("Walk")
	velocity.x = direction * speed
	move_and_slide()
	
func attack():
	velocity.x = direction * stop_move_speed
	spriteplayer.play("Attack")

func hit(damage : int):
	health -= damage
	print(health)

func _on_vision_body_entered(body):
	if !stunned:
		state = ATTACK

func _on_vision_body_exited(body):
	await spriteplayer.animation_finished
	state = MOVE


func _on_hitbox_body_entered(body):
	if body is NewPlayer:
		body.hit(damage)
		print(body.name)
	pass


func _on_hitbox_area_entered(area):
#	stunned = true
#	print(stunned)
#	spriteplayer.play("Stun")
#	await spriteplayer.animation_finished
#	stunned = false
	print("stunned")
	
