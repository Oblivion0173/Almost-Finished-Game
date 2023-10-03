extends CharacterBody2D
class_name golem
enum {MOVE, ATTACK, DEATH, STUNNED}
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
@export var damage : int = 50
@export var health : float = 10
var is_stunned = false
func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		MOVE: move()
		ATTACK: attack()
		DEATH: death()
		STUNNED: stunned()
	if is_on_wall():
		direction *= -1
		$".".transform.x *= -1


func move():
	spriteplayer.play("Walk")
	velocity.x = direction * speed
	if health <= 0:
		state = DEATH
	if is_stunned:
		state = STUNNED
	move_and_slide()

func death():
	spriteplayer.play("Death")
	await spriteplayer.animation_finished
	self.queue_free()
	pass
func attack():
	velocity.x = direction * stop_move_speed
	spriteplayer.play("Attack")

func stunned():
	spriteplayer.play("Stun")
	if health <= 0:
		state = DEATH
	await spriteplayer.animation_finished
	is_stunned = false
	state = MOVE
	pass

func hit(damage : int):
	health -= damage
	print(health)

func _on_vision_body_entered(body):
	if !is_stunned:
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
	print("stunned")
	state = STUNNED

	
