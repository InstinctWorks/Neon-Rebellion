extends Control

## Handles the Game UI

## Onready Variables
@onready var xp_bar = $CanvasLayer/XP_Bar
@onready var upgrade_menu = $CanvasLayer2/Upgrade_Menu
@onready var time_label: Label = $Time_Label

@onready var kill_counter = $Label
@onready var player = $"../.."

var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var enemy = preload("res://Enemy/enemy.tscn").instantiate()
	var boss = preload("res://Enemy/boss.tscn").instantiate()
	enemy.enemy_died.connect(update_kills)
	boss.boss_died.connect(update_kills)
	
	xp_bar.set_xp()
	
	time_label.text = format_time(elapsed_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	time_label.text = format_time(elapsed_time)

func update_kills() -> void:
	player.kills += 1
	kill_counter.text = "KILLS = " + str(player.kills)
	print("Game UI: KILLS Update")

## Update the XP Bar
func update_xp(amount: int) -> void:
	xp_bar.add_xp(amount)
	print("Game UI: XP Sent to XP Bar")

func format_time(seconds) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)

func _on_xp_bar_level_up() -> void:
	upgrade_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Engine.time_scale = 0
