extends CharacterBody2D

class_name DamageableViking
@onready var player = $"../Player"
var resume = 0
const SPEED = 50
@export var damage : int = 10
@export var health : float = 20
var crouched = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var stand = true
var old_direction = 0
@onready var spriteplayer = $AnimationPlayer
enum {MOVE, ATTACK}
var state = MOVE
var is_in_area = false
var counter = 0
func _physics_process(delta):
#	print("direction is ", direction)
#	print("resume is ", resume)
#	print(is_in_area)
#	print("health is: ", health)
#	print(counter)
#	print("scale is: ", scale.x)
	if !spriteplayer.is_playing():
		counter += 1
#	print(spriteplayer.current_animation)
	match state:
		MOVE: move_enemy(delta)
		ATTACK: attack()
	turn_around()
	crouch_check()
	error_check()
#	if is_in_area == true:
##		resume = direction
#		attack()

func move_enemy(delta):
	if direction == -1: #and health != 10:
		velocity.x = -SPEED
		if not crouched:
			spriteplayer.play("Walk")
		else:
			spriteplayer.play("Crouch")
#		spriteplayer.play("Crouch")
	if direction == 1: #and health != 10:
		velocity.x = SPEED
		if not crouched:
			spriteplayer.play("Walk")
		else:
			spriteplayer.play("Crouch")
	if crouched:
		velocity.x = 0
	if direction == 0:
		velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity * delta
	
#	if health == 10:
#		crouched = true
#		$".".set_collision_layer_value(14, false)
#		$".".set_collision_layer_value(15, true)
	if health == 0:
		direction = 0
		spriteplayer.play("Death")
		await spriteplayer.animation_finished
		self.queue_free()
	move_and_slide()

func crouch_check():
		if health == 10:
			crouched = true
			$".".set_collision_layer_value(14, false)
			$".".set_collision_layer_value(15, true)
func turn_around():
	if $RayCast2D.is_colliding():
		direction *= -1
		scale.x = -scale.x
		state = MOVE

func hit(damage : int):
	health -= damage
	print(health)

func attack():
	old_direction = direction
	direction = 0
#	spriteplayer.stop() #unneccesary maybe?
	spriteplayer.play("Attack")
	await spriteplayer.animation_finished
	direction = old_direction
	error_check()
	state = MOVE

func _on_player_detection_right_body_entered(body):
#		is_in_area = true
	attack()

func _on_player_detection_left_body_entered(body): #Flips enemy towards player
	direction *= -1
	scale.x = -scale.x
 
func _on_player_detection_body_exited(body):
#	is_in_area = false
	await spriteplayer.animation_finished
	state = MOVE
#	direction = resume
#	state = MOVE

func _on_hitbox_body_entered(body):
#	if player.is_dashing(): return
	if body is NewPlayer:
		body.hit(damage)
		print(body.name)
	pass

func error_check():
#	if !spriteplayer.is_playing():
#		direction = 1
#		state = MOVE
	if counter == 45:
		direction = 1
		scale.x = -scale.x
		state = MOVE
		counter = 0
		
#	if direction == 0 and health != 10 and spriteplayer.is_playing("Idle"):
#		spriteplayer.stop()
#		direction = 1
#		state = MOVE
