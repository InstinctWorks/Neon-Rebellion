extends Control

## Upgrade Menu

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	player = get_tree().get_root().get_node("/root/World/Player")
	


func _on_option_1_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Engine.time_scale = 1
	visible = false
	
	player.upgrade("hp")
	
	pass # Replace with function body.


func _on_option_2_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Engine.time_scale = 1
	visible = false
	
	player.upgrade("speed")
	
	pass # Replace with function body.


func _on_option_3_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Engine.time_scale = 1
	visible = false
	
	player.upgrade("dmg")
	
	pass # Replace with function body.
