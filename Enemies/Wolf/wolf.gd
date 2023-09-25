extends CharacterBody2D
class_name wolf
enum {MOVE, ATTACK, DEATH, STUNNED}
@onready var spriteplayer = $AnimationPlayer
const speed = 75
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
var is_stunned = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		MOVE: move()
		ATTACK: attack()
		DEATH: death()
	if is_on_wall():
		direction *= -1
		$".".transform.x *= -1
		#if Input.is_action_just_pressed("ui_accept"):
#		spriteplayer.play("Attack")
#
func move():
	spriteplayer.play("Run")
#	$Vision/CollisionShape2D.disabled = true  
	velocity.x = direction * speed
	if health <= 0:                                                                                                                                                                                                                                                     
		state = DEATH
	move_and_slide()

func hit(damage : int):
	health -= damage
	print(health)

func death():
	spriteplayer.play("Death")
	await spriteplayer.animation_finished
	self.queue_free()

func attack():
	velocity.x = direction * stop_move_speed
	spriteplayer.play("Attack")
	pass

func _on_vision_body_entered(body):
		state = ATTACK

func _on_vision_body_exited(body):
	await spriteplayer.animation_finished
	state = MOVE


func _on_hitbox_body_entered(body):
	if body is NewPlayer:
		body.hit(damage)
		print(body.name)


func _on_vision_behind_body_entered(body):
	scale.x *= -1
	direction *= -1
	state = ATTACK


func _on_vision_behind_body_exited(body):
	await spriteplayer.animation_finished
	state = MOVE
