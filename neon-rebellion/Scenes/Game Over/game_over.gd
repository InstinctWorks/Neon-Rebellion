extends Control


## Game Over Menu

@onready var canvas_layer: CanvasLayer = $CanvasLayer
var world

func _ready() -> void:
	world = get_tree().get_root().get_node("/root/World")
	canvas_layer.visible = false

func _on_restart_pressed() -> void:
	world.restart_game()
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Engine.time_scale = 1  ## Resume the game


func _on_main_menu_pressed() -> void:
	world.restart_game()
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main_menu.tscn")
