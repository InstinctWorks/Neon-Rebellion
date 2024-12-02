extends CharacterBody2D

## Player

## onready variables
@onready var health_UI = $healthUI
@onready var health_bar = $Health_Bar
@onready var kill_counter = $Label  # Temporary Label
@onready var xp_counter = $Label2  # Temporary Label 
@onready var game_ui: Control = $Camera2D/Game_UI

## Constant Variables
const SPEED = 300.0
#const ACCELERATION = 10.0
#const FRICTION = 100.0


const FLASH_INTERVAL = 0.1  # Flash Interval in seconds (Damage Indicator)
@export var ATTACK_INTERVAL = 0.25  # Attack Interval in seconds (Attack Cooldown)
const DAMAGE_DURATION = 1.00  # Damage Duration for flashes
@export var LAUNCH_OFFSET = 50  # Launch Offset position for projectiles

## References
const projectile = preload("res://Projectiles/projectile.tscn")

## Signals
signal health_changed(value)

# Variables
var sprite  # Sprite Reference

var max_hp = 100  # Max Health
var current_hp = max_hp  # Set the Player Current Health
var dmg = 1  # Set the Player dmg
var dmg_multipler = 1  # 
var kills = 0  # 


var attack_timer = 0.0  # Attack Timer to control the Player Auto Attacks
var flash_timer = 0.0  # Timer for Flashes
var damage_timer = 0.0 # Timer for damage indicator

var xp = 0  # XP Counter

var taking_damage = false  # Flag Check if the Player is taking damage

var is_alive = true  # Flag Check if the Player is alive

var paused = false  # Flag Check if the game is paused for any reasons (Implement in the future)


func _ready():
	health_UI.set_max_health(max_hp)  # Set Player Max HP in health UI
	health_bar.set_max_health(max_hp)  # Set Player Max HP in health bar
	#health_bar.init_health(max_hp)
	health_bar.bar_timer.start()
	
	sprite = get_node("Sprite2D")  # Intialize the Player Sprite
	
	taking_damage = true
	
	add_to_group("Player")  # Add Player to a group


## Update the Player Visibility - Antoine
func update_player_visibility():
	sprite.visible = visible


func _physics_process(delta):
	
	if is_alive:
		## Movement Control
		var velocity = Vector2.ZERO
		var input_vector = Vector2.ZERO
		
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			velocity = input_vector * SPEED
			#velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		else:
			velocity = Vector2.ZERO
		
		#print("Player Velocity: ", velocity)
		
		if attack_timer <= 0:
			attack_timer = ATTACK_INTERVAL
			attack()
		
		attack_timer -= delta
		
		## Handles Damaage Indicator when Player takes damage
		if taking_damage:
			
			damage_timer -= delta
			flash_timer -= delta  # Reduce the Flash Timer
			health_bar.visible = true
			#health_bar.self_modulate = Color(1,1,1,1)
			#health_bar.damage_bar.self_modulate = Color(1,1,1,1)
			#health_bar.modulate = Color(1,1,1,1)
			
			## Flash the Player when taking damage (Toggle Visibility On/Off)
			if flash_timer <= 0:
				#print("Taking Damage")
				flash_timer = FLASH_INTERVAL
				visible = !visible  # Flip the Visibility (true/false)
				update_player_visibility()  # Update the Player Sprite Visibility
			
			if damage_timer <= 0:
				taking_damage = false
				visible = true  # Set the Player visibility to true
				#health_bar.bar_timer.start()
				update_player_visibility()  # Update the Player to be visible
		
		move_and_collide(velocity * delta)
		
		#move_and_slide()

##
func collect(item: String):
	var world = get_tree().get_root().get_node("/root/World")
	
	if item == "xp":
		var xp_drop = preload("res://Collectibles/xp.tscn").instantiate()
		
		xp += xp_drop.xp
		
		xp_counter.text = "XP = " + str(xp)
		
		game_ui.update_xp(xp_drop.xp)
		#print("XP Collected: XP Level = ", xp)
	elif item == "nuke":
		var enemies = get_tree().get_nodes_in_group("Enemy")
		
		for enemy in enemies:
			if enemy.has_method("die") and !enemy.boss:
				enemy.die()  # Destroy all enemies by removing them from the scene
		world.current_enemies = 0  # Reset current enemies count in world script
		print("All enemies destroyed!")
	elif  item == "heal":
		if current_hp < max_hp:
			#current_hp = clamp(current_hp, 0, max_hp)
			current_hp += round(max_hp * 0.25)
			#var potential_hp = current_hp + round(max_hp * 0.25)
			current_hp = clamp(current_hp, 0, max_hp)
			health_changed.emit(current_hp)
			print("Player Healed: ", current_hp)
	
	world.current_items -= 1

##
func find_nearest_enemy():
	var nearest_enemy = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy

##
func attack():
	
	var nearest_enemy = find_nearest_enemy()
	
	if nearest_enemy:
		var direcction = (nearest_enemy.global_position - global_position).normalized()
		
		var bullet = projectile.instantiate()
		#print("Player Damage: ", bullet.dmg, "* ", dmg_multipler)
		dmg = bullet.dmg * dmg_multipler
		
		
		## Determine the direction the enemy will be facing (Left/Right)
		var direction = (nearest_enemy.global_position - global_position).normalized()
		
		## Set the direction and speed of the projectile
		bullet.direction = direction
		#bullet.speed = projectile_speed
		
		#var direction_offset = Vector2()
		#
		#if abs(direction.x) > abs(direction.y):
			#direction_offset = Vector2(LAUNCH_OFFSET * sign(direction.x), direction.y)
		#else:
			#direction_offset = Vector2(direction.x, LAUNCH_OFFSET * sign(direction.y))
		#
		#print("Player Bullet Direction: ", bullet.direction)
		
		## Set the position of the projectile
		bullet.position = global_position + direction
		
		#print("Bullet Position: ", bullet.position)
		
		## Spawn the projectile
		owner.add_child(bullet)

##
func take_damage(dmg):
	
	current_hp -= dmg
	health_changed.emit(current_hp)
	
	taking_damage = true
	damage_timer = DAMAGE_DURATION
	#flash_timer = FLASH_INTERVAL # Reset the flash timer
	
	print("Player Current Health: ", current_hp)
	
	if current_hp <= 0:
		print("Player has Died")
		die()
		pass


func die():
	is_alive = false
	visible = false
	update_player_visibility()
	
	#get_tree().reload_current_scene()
	#print("Game Reset")
