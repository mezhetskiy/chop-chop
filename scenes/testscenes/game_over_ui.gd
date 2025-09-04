extends Control


func _ready():
	$AnimatedSprite2D.play("game_over")


func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
