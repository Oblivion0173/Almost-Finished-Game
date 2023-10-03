extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_from_black():
	animation_player.play("Fade_From_Black")
	await animation_player.animation_finished
	
func fade_to_black():
	animation_player.play("Fade_To_Black")
	await animation_player.animation_finished
