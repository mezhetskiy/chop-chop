extends CharacterBody2D

@export var speed := 100
@onready var animation := $PlayerSprite
var campfire_in_range: Node = null
var facing_direction := "down"
var tree_in_range: Node = null
var is_chopping: bool = false
var has_chopped: bool = false


func _ready():
	$Area2D.connect("body_entered", _on_body_entered)
	$Area2D.connect("body_exited", _on_body_exited)
	$Area2D.connect("area_entered", _on_area_entered)
	$Area2D.connect("area_exited", _on_area_exited)
	animation.connect("frame_changed", _on_frame_changed)

func _on_frame_changed():
	if animation.animation.begins_with("chop_") and animation.frame == 2 and not has_chopped:
		if tree_in_range and tree_in_range.has_method("chop"):
			tree_in_range.chop()
		has_chopped = true
	#if not is_chopping or has_chopped:
		#return
		#
	#if animation.animation == "chop_" + facing_direction and animation.frame == 2:
		#if tree_in_range and tree_in_range.has_method("chop"):
			#tree_in_range.chop() 
			#has_chopped = true

func _on_body_entered(body):
	print("Body entered:", body)
	if body.is_in_group("trees"):
		print("Tree detected!")
		tree_in_range = body
	if body.is_in_group("campfires"):
		campfire_in_range = body

func _on_body_exited(body):
	#if body == tree_in_range:
	if body.is_in_group("trees"):
		print("Tree out of range.")
		tree_in_range = null
	if body.is_in_group("campfires"):
		print("Campfire out of range.")
		campfire_in_range = null

func _on_area_entered(area):
	print("Area entered:", area)
		
	if area.is_in_group("logs"):
		var hud = get_tree().get_root().get_node("HUD")
		hud.add_log()
		area.queue_free()
		#if hud.has_method("add_log"):
			#hud.add_log()
			#print("Log picked up!")
		#else:
			#print("HUD has no method 'add_log'")

func _on_area_exited(area):
	if area.get_parent() == tree_in_range:
		tree_in_range = null
		
func _physics_process(delta):
	if is_chopping:
		return

	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	input_vector.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			facing_direction = "right" if input_vector.x > 0 else "left"
		else:
			facing_direction = "down" if input_vector.y > 0 else "up"
		_play_movement_animation()
	else:
		_play_idle_animation()

func _play_movement_animation():
	if facing_direction == "left":
		animation.flip_h = true
		animation.play("walk_right")
	else:
		animation.flip_h = false
		animation.play("walk_" + facing_direction)

func _play_idle_animation():
	if facing_direction == "left":
		animation.flip_h = true
		animation.play("idle_right")
	else:
		animation.flip_h = false
		animation.play("idle_" + facing_direction)

func _input(event):
	
	if is_chopping:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_chopping = true
		has_chopped = false
		await _play_chop_animation()
		is_chopping = false

	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if campfire_in_range:
			var hud = get_tree().get_root().find_child("HUD", true, false)
			if hud.log_count > 0:
				campfire_in_range.add_fire()
				hud.remove_log()
	#if is_chopping:
		#return
	#
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#is_chopping = true
		#has_chopped = false
		#await _play_chop_animation()
		#is_chopping = false
		#
		#if tree_in_range:
			#print("Tree in range:", tree_in_range)
			#if tree_in_range.has_method("chop"):
				#tree_in_range.chop()
			#else:
				#print("This object has no method 'chop'")
		#else:
			#print("No tree in range.")
			#
		#await _play_chop_animation()	
		#is_chopping = false	
	#
	#if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		#if campfire_in_range:
			#var hud = get_tree().get_root().find_child("HUD", true, false)
			#if hud.log_count > 0:
				#campfire_in_range.add_fire()
				#hud.remove_log()
	
func _play_chop_animation():
	#if is_chopping:
		#return
	#is_chopping = true

	if facing_direction == "left":
		animation.flip_h = true
		animation.play("chop_right")
	else:
		animation.flip_h = false
		animation.play("chop_" + facing_direction)

	await animation.animation_finished
	#is_chopping = false
