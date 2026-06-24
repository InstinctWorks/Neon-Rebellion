extends CharacterBody2D

## Player

## onready variables
#@onready var health_UI = $healthUI
@onready var health_bar = $Health_Bar
@onready var kill_counter = $Camera2D/Game_UI/Label  # Temporary Label
@onready var xp_counter = $Camera2D/Game_UI/Label2  # Temporary Label 
@onready var game_ui: Control = $Camera2D/Game_UI
@onready var i_frames: Timer = $"I-Frames"
@onready var animationPlayer = $AnimationPlayer  
@onready var animatedSprite = $AnimatedSprite2D

## Constant Variables

#const ACCELERATION = 10.0
#const FRICTION = 100.0

const INVINCIBILITY_DURATION = 0.3  # Duration of Invinvibility period in seconds (Invincibility Frames)
const FLASH_INTERVAL = 0.1  # Flash Interval in seconds (Damage Indicator)

const DAMAGE_DURATION = 1.00  # Damage Duration for flashes
@export var LAUNCH_OFFSET = 50  # Launch Offset position for projectiles
const MAX_SPEED = 1500

@export var ATTACK_INTERVAL = 1.0  # Attack Interval in seconds (Attack Cooldown)
var MAX_ATTACKSPEED = 0.30


## References
const projectile = preload("res://Projectiles/projectile.tscn")

## Signals
signal health_changed(value)
signal player_died()

# Variables
#var sprite  # Sprite Reference
#var Idle_Sprite
#var Run_Sprite
#var current_sprite

var max_hp = 100  # Max Health
var current_hp = max_hp  # Set the Player Current Health
var speed = 300.0
var base_dmg = 25  # Base dmg
var dmg = base_dmg  # Set the Player dmg
var dmg_multipler = 1.0  # 
var kills = 0  # 


var attack_timer = 0.0  # Attack Timer to control the Player Auto Attacks
var flash_timer = FLASH_INTERVAL  # Timer for Flashes
var damage_timer = DAMAGE_DURATION # Timer for damage indicator
var invincible_timer = 0

var xp = 0  # XP Counter

var taking_damage = false  # Flag Check if the Player is taking damage
var invincible = false  # Flag Check if the Player is invincible 

var is_alive = true  # Flag Check if the Player is alive

var paused = false  # Flag Check if the game is paused for any reasons (Implement in the future)


func _ready():
	health_bar.enable_fade = false
	#health_UI.set_max_health(max_hp)  # Set Player Max HP in health UI
	health_bar.set_max_health(max_hp)  # Set Player Max HP in health bar
	#health_bar.init_health(max_hp)
	health_bar.bar_timer.start()
	
	#sprite = get_node("Sprite2D")  # Intialize the Player Sprite
	#Idle_Sprite = get_node("IdleSprite")
	#Run_Sprite = get_node("RunSprite")
	#current_sprite = Idle_Sprite
	
	#taking_damage = true
	
	add_to_group("Player")  # Add Player to a group


## Update the Player Visibility - Antoine
#func update_player_visibility():
	#sprite.visible = sprite.visible


func _physics_process(delta):
	
	if is_alive:
		## Movement Control
		var velocity = Vector2.ZERO
		var input_vector = Vector2.ZERO
		
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			#animationPlayer.play("Run")
			if !taking_damage:
				animatedSprite.play("Run")
			
			velocity = input_vector * speed
			#velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)
		else:
			#animationPlayer.play("Idle")
			if !taking_damage:
				animatedSprite.play("Idle")
			
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
			
			#health_bar.visible = true
			#health_bar.self_modulate = Color(1,1,1,1)
			#health_bar.damage_bar.self_modulate = Color(1,1,1,1)
			#health_bar.modulate = Color(1,1,1,1)
			
			## Flash the Player when taking damage (Toggle Visibility On/Off)
			if flash_timer <= 0:
				#print("Taking Damage")
				flash_timer = FLASH_INTERVAL  # Reset the flash timer
				#sprite.visible = !sprite.visible  # Flip the Visibility (true/false)
				#update_player_visibility()  # Update the Player Sprite Visibility
				#current_sprite.visible = !current_sprite.visible
				animatedSprite.play("Hurt")
				animatedSprite.visible = !animatedSprite.visible
			
			if damage_timer <= 0:
				taking_damage = false
				invincible = false
				animatedSprite.visible = true
				#sprite.visible = true  # Set the Player visibility to true
				#health_bar.bar_timer.start()
				#update_player_visibility()  # Update the Player to be visible
				#current_sprite.visible = true
		
		## Flip Sprite Horizontally to face left/right
		#animatedSprite.flip_h = velocity.x < 0
		
		if velocity.x < 0:
			animatedSprite.flip_h = true
		elif velocity.x > 0:
			animatedSprite.flip_h = false
		
		move_and_collide(velocity * delta)
		
		#move_and_slide()

## Handles the collecting of items

#func collect(item: String):
	#var world = get_tree().get_root().get_node("/root/World")
	#
	#if item == "xp":
		#var xp_drop = preload("res://Collectibles/xp.tscn").instantiate()
		#
		#xp += xp_drop.xp
		#
		#xp_counter.text = "XP = " + str(xp)
		#
		#game_ui.update_xp(xp_drop.xp)
		##print("XP Collected: XP Level = ", xp)
	#elif item == "nuke":
		#var enemies = get_tree().get_nodes_in_group("Enemy")
		#
		#for enemy in enemies:
			#if enemy.has_method("die") and !enemy.boss:
				#enemy.die()  # Destroy all enemies by removing them from the scene
		#world.current_enemies = 0  # Reset current enemies count in world script
		#print("All enemies destroyed!")
	#elif item == "healing":
		#if current_hp < max_hp:
			##current_hp = clamp(current_hp, 0, max_hp)
			#current_hp += round(max_hp * 0.25)
			##var potential_hp = current_hp + round(max_hp * 0.25)
			#current_hp = clamp(current_hp, 0, max_hp)
			#health_changed.emit(current_hp)
			#print("Player Healed: ", current_hp)
	#
	#world.current_items -= 1

func collect(item: Object):
	var world = get_tree().get_root().get_node("/root/World")
	
	#print("Player Collected: ", item.name)
	
	if item.is_in_group("xp"):
		var xp_drop = preload("res://Collectibles/xp.tscn").instantiate()
		
		xp += xp_drop.xp
		
		#xp_counter.text = "XP = " + str(xp)
		
		game_ui.update_xp(item.xp)
		#print("XP Collected: XP Level = ", xp)
	elif item.is_in_group("nuke"):
		var enemies = get_tree().get_nodes_in_group("Enemy")
		
		# Destroy all enemies by removing them from the scene
		for enemy in enemies:
			if enemy.has_method("die") and !enemy.boss:
				enemy.die() 
		world.current_enemies = 0  # Reset current enemies count in world script
		
		# Destroy Extra Nukes
		for nuke in get_tree().get_nodes_in_group("nuke"):
			nuke.queue_free()
		world.current_nukes = 0  # Reset current nukes count in world
		
		world.current_items -= 1
		
		print("All enemies destroyed!")
	elif  item.is_in_group("healing"):
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
	
	if nearest_enemy and nearest_enemy.is_alive:
		var direcction = (nearest_enemy.global_position - global_position).normalized()
		
		var bullet = projectile.instantiate()
		#print("Player Damage: ", bullet.dmg, "* ", dmg_multipler)
		bullet.dmg = dmg * dmg_multipler
		
		
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


#func start_i_frames():
	#invincible = true
	#i_frames.start()

#func end_i_frame():
	#invincible = false

## Turns off i-frames when timer runs out
func _on_i_frames_timeout() -> void:
	invincible = false

## Handles damage taken
func take_damage(dmg: int, source: Node):
	
	## Skips damage step if invincible
	if invincible:
		#print("Player: Player is Invincible")
		return
	
	#if !invincible:
	current_hp -= dmg
	health_changed.emit(current_hp)
	
	taking_damage = true
	#invincible = true
	
	damage_timer = DAMAGE_DURATION
	invincible_timer = INVINCIBILITY_DURATION
	#flash_timer = FLASH_INTERVAL # Reset the flash timer
	
	## Apply i-frames if the Player is taking damage from the Boss
	if source.has_method("is_boss"):
		invincible = true
		i_frames.start()
	
	#print("Player Current Health: ", current_hp, "/", max_hp)
	
	if current_hp <= 0:
		print("Player has Died")
		die()
		#pass

func upgrade(upgrade: String):
	
	if upgrade == "hp":
		max_hp *= 1.25
		current_hp += round(max_hp * 0.25)
		current_hp = clamp(current_hp, 0, max_hp)
		
		health_bar.set_max_health(max_hp)
		health_changed.emit(current_hp)
	elif upgrade == "speed":
		if speed < MAX_SPEED:
			speed += 25
		if ATTACK_INTERVAL > MAX_ATTACKSPEED:
			ATTACK_INTERVAL -= 0.1
		print("Player Speed: %s --- Player Attack Speed: %s" % [speed, ATTACK_INTERVAL])
	elif upgrade == "dmg":
		dmg_multipler += 0.15
		dmg = base_dmg * dmg_multipler
		print("Player: DMG Upgraded! DMG Now = ", dmg)

func die():
	is_alive = false
	#visible = false
	#update_player_visibility()
	self.set_physics_process(false)
	
	BackgroundMusic.fade_out_and_stop(2.0)  # Fades out over 2 seconds, then stops

	animatedSprite.play("Death")
	
	await get_tree().create_timer(2.5).timeout
	
	player_died.emit()
	#get_tree().reload_current_scene()
	#print("Game Reset")
