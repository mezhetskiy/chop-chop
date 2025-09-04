extends Node2D

@onready var hud = $HUD
var log_scene = preload("res://scenes/objects/log.tscn") 

func spawn_log(position: Vector2):
	var log = log_scene.instantiate()
	add_child(log)
	log.global_position = position
	
	log.connect("picked_up", Callable(hud, "add_log"))
