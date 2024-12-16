extends Node2D

## World

## Array of world items
var items_list = [
	preload("res://Collectibles/nuke.tscn"),
	preload("res://Collectibles/healing.tscn"),
	
]

var enemy_list = [
	preload("res://Enemy/enemy.tscn"),
	preload("res://Enemy/drone.tscn"),
	preload("res://Enemy/drone2.tscn")
]

## Onready Variables
#@onready var health_UI = $Player

@onready var player = $Player
@onready var pause_menu = $Player/Camera2D/Pause_Menu
@onready var game_ui = $Game_UI
@onready var game_over: Control = $Game_Over
@onready var enemy_timer: Timer = $Enemy_Timer
@onready var boss_timer: Timer = $Boss_Timer

## Reference Variables
const ENEMY = preload("res://Enemy/enemy.tscn")  
const BOSS = preload("res://Enemy/boss.tscn")

## Constant Varibables 
const MAX_ITEMS = 15  # Max Amount of Items
const MAX_NUKE = 5  # Max Amount of Nukes (Playtest Suggestion to make nukes more scarce 

@export var max_enemy = 100  # Max Amount of Enemies 

var health_multiplier = 1.0
var damage_multiplier = 1.0
var speed_multiplier = 1.0

var boss_health_multiplier = 1.0
var boss_damage_multiplier = 1.0
var boss_speed_multiplier = 1.0

## Counter Variables
var current_enemies = 0  # Set Current Enemies Counter
var current_items = 0  # Set Current Items Counter

var paused = false  # Flag Check if the game if paused 

# Called when the node enters the scene tree for the first time.
func _ready():
	#BackgroundMusic.fade_in(3.0)  # Fade in music over 3 seconds
	BackgroundMusic.play()  
	
	randomize()  
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and Engine.time_scale != 0:  # Allows ESC to pause the game if the game is not already stopped
		pause_Menu()

## Handles Showing/Hiding the Pause Menu
func pause_Menu():
	
	## If paused (true) stop the game, show the pause menu
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		player.set_physics_process(true)
		#print("World: Game Paused")
	## Otherwise paused (false) resume the game, hide the pause menu
	else:
		pause_menu.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.set_physics_process(false)
		#print("World: Game Paused")
	
	paused = !paused

## Reset and Clean the World
func restart_game():
	print("World: Restarting Game")
	
	# 
	#BackgroundMusic.reset_music()
	#BackgroundMusic.fade_in(1.5)  # Fade in music over 3 seconds
	#BackgroundMusic.play()  
	
	#
	var items = get_tree().get_nodes_in_group("Collectibles")
	for item in items:
		#if item.is_in_group("Collectibles"):
		#print("World: Child = ", child.get_groups())
		item.queue_free()
	
	
	if BackgroundMusic.is_playing():
		BackgroundMusic.stop()
	
	BackgroundMusic.fade_in(1.5)
	BackgroundMusic.play()

## Handles Enemy Spawning along the outside of the PLayer's Camera View
func _on_enemy_timer_timeout():
	
	#if current_enemies < max_enemy:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	## Randomize position outside the camera view
	$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
	#print("Spawning enemy at progress ratio: ", $Player/Path2D/PathFollow2D.progress_ratio)
	
	#var enemy = ENEMY.instantiate()
	
	var enemy_type = randi_range(0, enemy_list.size() - 1)  # Randomly choice what Enemy from Enemy array
	var enemy = enemy_list[enemy_type].instantiate()  
	
	enemy.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	#print("Enemy spawned at: ", enemy.global_position)
	
	#enemy.connect("enemy_died", self, "_on_enemy_died")
	
	enemy.max_hp *= health_multiplier
	enemy.dmg *= damage_multiplier
	enemy.base_speed *= speed_multiplier
	
	#print("World: Enemy Stats\nMAX_HEALTH = %s\nDMG = %s\nSPEED = %s" % [enemy.max_hp, enemy.dmg, enemy.base_speed])
	
	add_child(enemy)
	current_enemies += 1
	#print("Spawned an Enemy, now there is: ", current_enemies)
	
	if current_enemies == 0:
		current_enemies = 0  # Reset the wave of enemies
		#print("Reset Wave")

## Handles Item Spawn
func _on_item_timer_timeout():
	
	if current_items < MAX_ITEMS:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		## Randomize position outside the camera view
		$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
		
		var item_spawn = randi_range(0, items_list.size() - 1)  # Randomly choice what item from Items array
		var item = items_list[item_spawn].instantiate()
		
		item.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
		
		add_child(item)
		current_items += 1
		print("Spawned an Item, now there is: ", current_items)

## Handles Boss Spawn
func _on_boss_timer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	## Randomize position outside the camera view
	$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
	#print("Spawning enemy at progress ratio: ", $Player/Path2D/PathFollow2D.progress_ratio)
	
	var boss = BOSS.instantiate()
	
	boss.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	#print("Enemy spawned at: ", enemy.global_position)
	
	#enemy.connect("enemy_died", self, "_on_enemy_died")
	
	## Clears Enemies to allow Boss to be the only target
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.has_method("die"):
			enemy.die()
	
	boss.connect("boss_died", _on_boss_died)
	
	boss.max_hp *= boss_health_multiplier
	boss.dmg *= boss_damage_multiplier
	boss.base_speed *= boss_speed_multiplier
	
	boss_timer.stop()
	enemy_timer.stop()
	
	print("World: Boss Stats - Boss MAX_HEALTH = %s Boss DMG = %s Boss SPEED = %s" % [boss.max_hp, boss.dmg, boss.base_speed])
	
	add_child(boss)

# TODO Revert Boss_Timer when done testing
func _on_boss_died():
	
	health_multiplier *= 1.5
	damage_multiplier *= 1.5
	speed_multiplier *= 1.5
	
	boss_health_multiplier += 1.0
	boss_damage_multiplier += 1.0
	boss_speed_multiplier += 1.0
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.has_method("die"):
			enemy.max_hp *= health_multiplier
			enemy.dmg *= damage_multiplier
			enemy.base_speed *= speed_multiplier
	
	boss_timer.start()
	enemy_timer.start()
	
	print("World: Boss has died! Increasing Enemy Stats! 
		\nHealth Multipler = %s Damage Multiplier = %s Speed Multipler = %s" % [health_multiplier, damage_multiplier, speed_multiplier])

## Display Game Over Menu when Player dies
func _on_player_player_died() -> void:
	Engine.time_scale = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_over.visible = true  
	game_over.canvas_layer.visible = true
