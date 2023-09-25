extends Node2D
@onready var wolf = $Wolf
@onready var wolfanimation = $Wolf/AnimationPlayer
@onready var wolfposition = $Wolf
var post_animation = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	pass


#func _on_animation_player_animation_finished(Attack):
#	wolf.position = post_animation
#	pass # Replace with function body.
