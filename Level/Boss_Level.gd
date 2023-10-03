extends Node2D
@onready var door = $Door
@onready var timer = $Timer
@onready var golem = $Golem
@onready var golem_2 = $Golem2
var bat = load("res://Enemies/Bat/bat.tscn")
var door_open = false

func _process(delta):
	if timer.is_stopped():
		start_timer()
	print(timer.time_left)
	if door_open == false:
		door.can_open = false
	if door_open == true:
		door.can_open = true
	if golem == null and golem_2 == null:
		door_open = true
	else:
		door_open = false

func _ready():
	pass

func start_timer():
	timer.start()


func _on_timer_timeout():
	spawn_bats(Vector2(249,-117))
	spawn_bats(Vector2(-168, -117))
	


func spawn_bats(pos):
	var instance = bat.instantiate()
	instance.position = pos
	add_child(instance)
