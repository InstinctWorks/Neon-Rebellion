extends Control


## Game Over Menu

@onready var canvas_layer: CanvasLayer = $CanvasLayer
var world

func _ready() -> void:
	world = get_tree().get_root().get_node("/root/World")
	canvas_layer.visible = false


func _on_restart_pressed() -> void:
	world.restart_game()
	#BackgroundMusic.fade_in(3.0)  # Fade in music over 3 seconds
	#BackgroundMusic.play()  
	Engine.time_scale = 1  ## Resume the game
	
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_main_menu_pressed() -> void:
	world.restart_game()
	Engine.time_scale = 1
	
	#BackgroundMusic.fade_in(3.0)  # Fade in music over 3 seconds
	#BackgroundMusic.play()  
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main_menu.tscn")
