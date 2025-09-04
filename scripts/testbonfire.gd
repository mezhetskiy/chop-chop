extends StaticBody2D

@export var burn_duration := 10.0
var time_left := 0.0
var is_burning := true

@onready var anim = $AnimatedSprite2D
@onready var progress_bar = $TestProgressBar
@onready var audio = $AudioStreamPlayer2D
@onready var hint_ui = $Hint
var hint_show := false

func _ready() -> void:
	start_fire()

func add_fire():
	if not is_burning:
		start_fire()
	else: 
		time_left += 5.0
		if time_left > burn_duration:
			time_left = burn_duration
	progress_bar.value = time_left

func _process(delta: float) -> void:
	if is_burning:
		time_left -= delta
		progress_bar.value = time_left
		if time_left <= 0:
			extinguish()
			
			
func start_fire():
	time_left = burn_duration
	is_burning = true
	anim.play("idle")
	

func extinguish():
	is_burning = false
	progress_bar.visible = false
	audio.stop()
	get_tree().change_scene_to_file("res://scenes/testscenes/game_over_ui.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		audio.play()
		
		if not hint_show:
			hint_ui.visible = true
			hint_show = true
			await get_tree().create_timer(3).timeout
			hint_ui.visible = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		audio.stop()
