extends Node2D

## World

## Array of world items
var items_list = [
	preload("res://Collectibles/nuke.tscn"),
	preload("res://Collectibles/healing.tscn"),
	
]

@onready var health_UI = $Player

@onready var player = $Player

const ENEMY = preload("res://Enemy/enemy.tscn")  

const MAX_ITEMS = 10  # Max Amount of Items

@export var max_enemy = 25  # Max Amount of Enemies 

var current_enemies = 0  # Set Current Enemies Counter
var current_items = 0  # Set Current Items Counter

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func _on_enemy_timer_timeout():
	
	if current_enemies < max_enemy:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
		#print("Spawning enemy at progress ratio: ", $Player/Path2D/PathFollow2D.progress_ratio)
		
		var enemy = ENEMY.instantiate()
		
		enemy.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
		#print("Enemy spawned at: ", enemy.global_position)
		
		#enemy.connect("enemy_died", self, "_on_enemy_died")
		
		add_child(enemy)
		current_enemies += 1
		#print("Spawned an Enemy, now there is: ", current_enemies)
	
	if current_enemies == 0:
		current_enemies = 0  # Reset the wave of enemies
		print("Reset Wave")

func _on_item_timer_timeout():
	
	if current_items < MAX_ITEMS:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		$Player/Path2D/PathFollow2D.progress_ratio = rng.randf_range(0.0, 1.0)
		
		var item_spawn = randi_range(0, items_list.size() - 1)  # Randomly choice what item from Items array
		var item = items_list[item_spawn].instantiate()
		
		item.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
		
		add_child(item)
		current_items += 1
		print("Spawned an Item, now there is: ", current_items)
	
