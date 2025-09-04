extends StaticBody2D

@onready var max_hits: int = 2
var current_hits: int = 0
var is_chopped: bool = false


@onready var sprite: AnimatedSprite2D = $animation
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var tree_timer: Timer = $Timer

func _ready():
	current_hits = 0
	
func chop():
	if is_chopped:
		return
		
	current_hits += 1
	$AudioStreamPlayer2D.play()
	
	print("Tree hit:", current_hits, "/", max_hits)
	sprite.play("chop")
	await sprite.animation_finished
	
	if current_hits >= max_hits:
		is_chopped = true
		#sprite.play("death")
		#await sprite.animation_finished
		
		_spawn_log()
		sprite.hide()
		collider.disabled = true
		tree_timer.start(30)
		
		
		#await get_tree().create_timer(10).timeout
		
		is_chopped = false
		current_hits = 0
		show()
		sprite.play("idle")
	else:
		sprite.play("idle")
#func respawn_tree():
	#await get_tree().create_timer(60).timeout
	#current_hits = 0
	#is_chopped = false
	#show()
	#sprite.play("idle")
func _spawn_log():
	var main = get_tree().get_root().find_child("main", true, false)
	if main:
		var offset_x = randf_range(-16, 16)
		var offset_y = randf_range(0, 16)
		var random_offset = Vector2(offset_x, offset_y)
		main.spawn_log(global_position + random_offset)  
	else:
		print("Main сцена не знайдена!")
	#var log_scene = preload("res://scenes/objects/log.tscn")
	#var log_instance = log_scene.instantiate()
	#get_parent().add_child(log_instance)
	#log_instance.global_position = global_position + Vector2(8, 0)


func _on_timer_timeout() -> void:
	sprite.show()
	collider.disabled = false
	current_hits = 0
