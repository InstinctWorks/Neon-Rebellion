extends Control

## Controls Health Bar

var max_health = 100  
var current_health = max_health  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_health(value):
	current_health = clamp(value, 0, max_health)
	#var hp_string: String = str(value)
	#if label != null:
		#label.text = "HP = " + str(value)

func set_max_health(value):
	max_health = max(value, 1)
	#var max_hp_string: String = str(max_hp)
	#label.text = "HP = " + str(max_hp)

## Handles Signal Emitted from Player 
func _on_player_health_changed(value: Variant) -> void:
	set_health(value)
