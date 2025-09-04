extends Node2D

@onready var hud = $HUD
var log_scene = preload("res://scenes/objects/log.tscn") 
@onready var hint_ui := $HintUI

func spawn_log(position: Vector2):
	var log = log_scene.instantiate()
	add_child(log)
	log.global_position = position
	
	log.connect("picked_up", Callable(hud, "add_log"))

func _ready():
	if hint_ui:
		hint_ui.visible = true
		await get_tree().create_timer(3).timeout
		hint_ui.visible = false
