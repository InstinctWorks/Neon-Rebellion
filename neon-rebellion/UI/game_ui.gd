extends Control

## Handles the Game UI

## Onready Variables
@onready var xp_bar = $CanvasLayer/XP_Bar
@onready var upgrade_menu = $CanvasLayer/Upgrade_Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xp_bar.set_xp()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Update the XP Bar
func update_xp(amount: int) -> void:
	xp_bar.add_xp(amount)
	print("Game UI: XP Sent to XP Bar")


func _on_xp_bar_level_up() -> void:
	upgrade_menu.visible = true
