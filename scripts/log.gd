extends Node2D

signal picked_up

func _ready():
	$Area2D.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("picked_up")
		queue_free()
