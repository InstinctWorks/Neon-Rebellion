extends Control

## Handles the Pause Menu

@onready var main = $"../../../"
@onready var player = get_tree().get_root().get_node("/root/World/Player")

func _on_resume_pressed() -> void:
	main.pause_Menu()


func _on_main_menu_pressed() -> void:
	main.restart_game()
	player.set_physics_process(true)
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main_menu.tscn")
