extends Node2D

## World

## Array of world items
var items_list = [
	preload("res://Collectibles/nuke.tscn"),
	preload("res://Collectibles/healing.tscn"),
	
]

## Onready Variables
#@onready var health_UI = $Player

@onready var player = $Player

@onready var pause_menu = $Player/Camera2D/Pause_Menu

## Reference Variables
const ENEMY = preload("res://Enemy/enemy.tscn")  

## Constant Varibables 
const MAX_ITEMS = 10  # Max Amount of Items


@export var max_enemy = 25  # Max Amount of Enemies 

## Counter Variables
var current_enemies = 0  # Set Current Enemies Counter
var current_items = 0  # Set Current Items Counter

var paused = false  # Flag Check if the game if paused 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_Menu()

## Handles Enemy Spawning along the outside of the PLayer's Camera View
func _on_enemy_timer_timeout():
	
	if current_enemies < max_enemy:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		## Randomize position outside the camera view
		$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
		#print("Spawning enemy at progress ratio: ", $Player/Path2D/PathFollow2D.progress_ratio)
		
		var enemy = ENEMY.instantiate()
		
		enemy.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
		#print("Enemy spawned at: ", enemy.global_position)
		
		#enemy.connect("enemy_died", self, "_on_enemy_died")
		
		#add_child(enemy)
		current_enemies += 1
		#print("Spawned an Enemy, now there is: ", current_enemies)
	
	if current_enemies == 0:
		current_enemies = 0  # Reset the wave of enemies
		print("Reset Wave")

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

## Handles Showing/Hiding the Pause Menu
func pause_Menu():
	## If paused (true) stop the game, show the pause menu
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		player.set_physics_process(true)
		print("World: Game Paused")
	## Otherwise paused (false) resume the game, hide the pause menu
	else:
		pause_menu.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.set_physics_process(false)
		print("World: Game Paused")
	
	paused = !paused
