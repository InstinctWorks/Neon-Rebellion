extends Control

## Handles Main Menu


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
	Engine.time_scale = 1  # Ensures the game resumes/play


func _on_quit_pressed() -> void:
	get_tree().quit()
