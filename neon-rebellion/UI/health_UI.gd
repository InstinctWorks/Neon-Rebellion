extends Control

## Health UI

var hp = 5
var max_hp = 5

@onready var label = $Label

func set_health(value):
	hp = clamp(value, 0, 5)
	var hp_string: String = str(value)
	if label != null:
		label.text = "HP = " + str(value)

func set_max_health(value):
	max_hp = max(value, 1)
	var max_hp_string: String = str(max_hp)
	label.text = "HP = " + str(max_hp)

func _ready():
	pass


func _on_player_health_changed(value):
	set_health(value)
