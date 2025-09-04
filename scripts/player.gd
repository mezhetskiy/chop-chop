extends CharacterBody2D

@export var movement_speed: float = 500
@onready var sprite = $PlayerSprite

var character_direction: Vector2
var 	last_direction: String = "right"

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("walk_left", "walk_right")
	character_direction.y = Input.get_axis("walk_up", "walk_down")


	if character_direction.x > 0:
		sprite.flip_h = false
	elif character_direction.x < 0:
		sprite.flip_h = true
	
	if character_direction.length() > 0:
		velocity = character_direction.normalized() * movement_speed
		
		if abs(character_direction.x) > abs(character_direction.y):
			last_direction = "right"
			sprite.play("walk_right")
		elif character_direction.y < 0:
			last_direction = "up"
			sprite.play("walk_up")
		else:
			last_direction = "down"
			sprite.play("walk_down")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		sprite.animation = "idle_" + last_direction
		
	move_and_slide()
		
