extends Area2D

@export_file("*.tscn") var filepath: String
@export var can_open = true

func _process(delta):
	pass

func _on_body_entered(body):
	if can_open == false: return
	if not body is NewPlayer: return
	if filepath.is_empty(): return
	get_tree().paused = true
	await Transitions.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file(filepath)
	Transitions.fade_from_black()
