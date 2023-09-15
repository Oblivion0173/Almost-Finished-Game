extends CharacterBody2D
class_name NewPlayer
@export var damage : int = 10
@export var health : float = 100
@export var can_be_hit : bool = true
enum {MOVE, ATTACK, IDLE, DEATH}
@onready var dash_timer = $Dash/Dash_Timer
var normalspeed = 150
var direction = 1
var SPEED = 150
const JUMP_VELOCITY = -400.0
const dash_speed = 2500
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var spriteplayer = $AnimationPlayer
var input = Vector3.ZERO
var state = MOVE
var sword = Vector3.ZERO
var dash_input = false

static var player
func _ready():
	player = self
func _physics_process(delta):
	input = get_input()
	match state:
		MOVE: move_state(input, delta)
		ATTACK: attack_state(input, delta)
		IDLE: idle_state(input, delta)
		DEATH: death_state(delta)

func get_input():
		#Controls Movement
	input.x = Input.get_axis("a", "d")
	input.y = Input.get_axis("w", "s")
#	dash_input = Input.is_action_just_pressed("ui_accept")
		#Controls Attack
	sword.x = Input.get_action_strength("left_click")
	sword.y = Input.get_action_strength("right_click")
	sword.z = Input.get_action_strength("ui_accept")
	return input

func move_state(input, delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		# Handle Jump.
	if input.y < 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.y < 0:
		spriteplayer.play("Jump")
	if velocity.y > 0:
		spriteplayer.play("Fall")
		#Add speed to velocity vector
	if input.x:
		direction = input.x
		velocity.x = input.x * SPEED
		#Deccelerate to 0
	if not input.x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#Go Idle on No movement
	if velocity.x == 0 and velocity.y == 0:
		state = IDLE
	if input.x and is_on_floor():
		spriteplayer.play("Run")
	if input.x < 0:
		#Flip Sprite
		$Sprite2D.flip_h = true
		#Flip Hitbox
		$Sprite2D/Regular_Attack.scale.x = -1
		$Sprite2D/Low_Attack.scale.x = -1
		$Parry/Parry_Hitbox.position.x = -11
	if input.x > 0:
		#Flip Sprite
		$Sprite2D.flip_h = false
		#Flip Hitbox
		$Sprite2D/Regular_Attack.scale.x = 1
		$Sprite2D/Low_Attack.scale.x = 1
		$Parry/Parry_Hitbox.position.x = 11
#	if dash_input:
#		start_dash(1.3)
#		velocity.x = dash_speed * direction if is_dashing() else SPEED * direction
##		velocity.x = 1150 * direction
#		$AnimatedSprite2D.play("Roll")
##		await $AnimatedSprite2D.animation_finished
##		SPEED = 150
##		start_dash(0.3)
##		if is_dashing(): 
##			SPEED = dash_speed
##		else:
##			SPEED = 150
	if sword and is_on_floor() and $Attack_Cooldown.is_stopped():
		state = ATTACK
	if health == 0:
		state = DEATH
	move_and_slide()

func attack_state(input, delta):
		#Attack_High
	if sword.x and $Attack_Cooldown.is_stopped():
		$Sprite2D/Regular_Attack/R_Hitbox.disabled = false
		spriteplayer.play("Regular_Attack")
		$Attack_Cooldown.start()
		#Attack Low
	if sword.y and $Attack_Cooldown.is_stopped():
		$Sprite2D/Low_Attack/L_Hitbox.disabled = false
		spriteplayer.play("Low_Attack")
		$Attack_Cooldown.start()
		#Parry
	if sword.z and $Attack_Cooldown.is_stopped():
		spriteplayer.play("Parry")
#		await spriteplayer.animation_finished
		$Attack_Cooldown.start()

		#Return to Idle
	if not spriteplayer.is_playing():
		state = IDLE

func idle_state(input, delta):
	spriteplayer.play("Idle")
		#Disable Hitboxes
	$Sprite2D/Regular_Attack/R_Hitbox.disabled = true
	$Sprite2D/Low_Attack/L_Hitbox.disabled = true
	if input:
		state = MOVE
	if sword and $Attack_Cooldown.is_stopped():
		state = ATTACK
	else:
		pass

func death_state(delta):
	spriteplayer.play("Death")
	await spriteplayer.animation_finished
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished():
	state = IDLE

func _on_timer_timeout():
	state = IDLE

###########################---------------ATTACKING-----------------#######################
func _on_low_attack_body_entered(body):
	if body is DamageableViking:
		body.hit(damage)
	print(body.name)

func _on_regular_attack_body_entered(body):
	if body is bat or golem:
		body.hit(damage)
	print(body.name)

func hit(damage : int):
	if can_be_hit:
		health -= damage
	print(health)

########################---------------DASH---------------------------#######################
func start_dash(duration):
	dash_timer.wait_time = duration
	dash_timer.start()

func is_dashing():
	return !dash_timer.is_stopped()
