extends Control

## Handles the Game UI

## Onready Variables
@onready var xp_bar = $CanvasLayer/XP_Bar
@onready var upgrade_menu = $CanvasLayer/Upgrade_Menu
@onready var kill_counter = $Label
@onready var player = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xp_bar.set_xp()
	
	var enemy = preload("res://Enemy/enemy.tscn").instantiate()
	var boss = preload("res://Enemy/boss.tscn").instantiate()
	enemy.enemy_died.connect(update_kills)
	boss.boss_died.connect(update_kills)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_kills() -> void:
	player.kills += 1
	kill_counter.text = "KILLS = " + str(player.kills)
	print("Game UI: KILLS Update")

## Update the XP Bar
func update_xp(amount: int) -> void:
	xp_bar.add_xp(amount)
	print("Game UI: XP Sent to XP Bar")


func _on_xp_bar_level_up() -> void:
	upgrade_menu.visible = true
