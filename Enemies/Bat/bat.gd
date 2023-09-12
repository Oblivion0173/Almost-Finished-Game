extends CharacterBody2D
class_name bat
@onready var spriteplayer = $AnimationPlayer

var SPEED = 50
const JUMP_VELOCITY = -400.0
var direction = -1
var hit_speed = 150
var is_dashing = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var damage : int = 10
@export var health : float = 10

func _physics_process(delta):
	if velocity.x != 0:
		spriteplayer.play ("Idle")
	if $WallDetector.is_colliding():
		direction *= -1
		scale.x = -scale.x
	if $FloorDetector.is_colliding():
		velocity.y = -70
	if $CeilingDetector.is_colliding():
		velocity.y = 70
	if is_dashing == true:
		spriteplayer.play("Attack")
	
	if health == 0:
		is_dashing = false
		velocity.x = 0
		velocity.y = 0
		spriteplayer.play("Death")
		await spriteplayer.animation_finished
		self.queue_free()
	move()
	move_and_slide() 


func move():
	if $PlayerDetector.is_colliding():
		velocity = global_position.direction_to($PlayerDetector.get_collider().global_position) * hit_speed
		is_dashing = true
	elif $PlayerDetector2.is_colliding():
		velocity = global_position.direction_to($PlayerDetector2.get_collider().global_position) * hit_speed
		is_dashing = true
	elif $PlayerDetector3.is_colliding():
		velocity = global_position.direction_to($PlayerDetector3.get_collider().global_position) * hit_speed
		is_dashing = true
	elif $PlayerDetector4.is_colliding():
		velocity = global_position.direction_to($PlayerDetector4.get_collider().global_position) * hit_speed
		is_dashing = true
	elif $PlayerDetector5.is_colliding():
		velocity = global_position.direction_to($PlayerDetector5.get_collider().global_position) * hit_speed
		is_dashing = true
	elif $PlayerDetector6.is_colliding():
		velocity = global_position.direction_to($PlayerDetector6.get_collider().global_position) * hit_speed
		is_dashing = true
	else:
		velocity.x = direction * SPEED
		is_dashing = false

func hit(damage : int):
	health -= damage
	print(health)

func _on_hitbox_body_entered(body):
#	if player.is_dashing(): return
	if body is NewPlayer:
		body.hit(damage)
		print(body.name)
	pass
