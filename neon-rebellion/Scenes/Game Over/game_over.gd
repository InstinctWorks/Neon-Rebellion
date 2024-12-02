extends Control


## Game Over Menu

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas_layer.visible = false

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Engine.time_scale = 1  ## Resume the game


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main_menu.tscn")
