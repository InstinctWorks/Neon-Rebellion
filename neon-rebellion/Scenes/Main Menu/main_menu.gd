extends Control

## Handles Main Menu

func _ready() -> void:
	BackgroundMusic.fade_in(0.5)  # Fade in music over 3 seconds
	BackgroundMusic.play() 
	Engine.time_scale = 1 

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
	Engine.time_scale = 1  # Ensures the game resumes/play


func _on_quit_pressed() -> void:
	get_tree().quit()
