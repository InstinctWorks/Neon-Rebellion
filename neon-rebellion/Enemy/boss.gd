extends CharacterBody2D

## Enemy (Melee)



## Onready Variables
@onready var health_bar = $CanvasLayer/Health_Bar


## Constant Variables

const drag_speed = 100.0


const FLASH_INTERVAL = 0.1  # Flash Interval in seconds (Damage Indicator)
const DAMAGE_DURATION = 1.0  # Damage Duration for flashes
const target = "Player"
const dmg = 5

## References
const xp = preload("res://Collectibles/xp.tscn")
var world = preload("res://Scenes/World/world.tscn")

## Signals
signal boss_died
signal health_changed(value)

## Variables
var max_hp = 1000
var current_hp = max_hp
var base_speed = 150
var speed = base_speed

var flash_timer = 0.0  # Timer for Flashes
var damage_timer = 0.0 # Timer for damage indicator

var is_alive = true  # Flag Check if the Enemy is alive
var taking_damage = false  # Flag Check if the Enemy is taking damage

## Player Referemce
var player

## Enemy Sprite Reference
var sprite

var direction  # Check where the player is

var boss = true  # Flag Check for Boss

func _ready():
	health_bar.enable_fade = false
	health_bar.set_max_health(max_hp)
	
	sprite = get_node("Sprite2D")
	player = get_tree().get_root().get_node("/root/World/Player")
	world = get_tree().get_root().get_node("/root/World")
	add_to_group("Enemy")
	$Hurtbox.add_to_group("Enemy")

func update_enemy_visibility():
	sprite.visible = visible

func _physics_process(delta):
	
	if !player.is_alive:
		return
		
	## Determine the direction the enemy will be facing (Left/Right)  
	direction = (player.global_position - global_position).normalized()
	
	## Calculate distance to the player  
	var distance_to_player = position.distance_to(player.position)
	
	## Calculate the height distance to the player
	#var height_distance = abs(player.global_position.y - global_position.y)
	
	#position += (player.position - position) / drag_speed  # Move towards the player
	
	var velocity = direction * speed
	
	#print("Direction to Player: ", direction)
	
	#velocity = (player.global_position - global_position).normalized() * speed
	
	## Flip Sprite Horizontally to face left/right
	sprite.flip_h = direction.x < 0
	
	#print(velocity)
	
	#var collision = move_and_collide(velocity * delta)
	#
	#if collision:
		#var collided_object = collision.get_collider()
		##print("Collision Detected with: ", collided_object)
		#
		#if collided_object.name == "Player":
			#collided_object.take_damage(dmg)
	
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
			update_enemy_visibility()  # Update the Enemy Sprite Visibility
		
		if damage_timer <= 0:
			taking_damage = false
			visible = true  # Set the Enemy visibility to true
			health_bar.bar_timer.start()
			update_enemy_visibility()  # Update the Enemy to be visible
			print("Enemy: Damage Timer ran out")
	
	move_and_collide(velocity * delta)
	#move_and_slide()

## Handles Damage Taken
func take_damage(dmg):
	current_hp -= dmg
	health_changed.emit(current_hp)
	
	health_bar.enable_fade = false  # Disable Health Bar Fading for Boss
	
	print("Boss Current Health: ", current_hp)
	
	taking_damage = true
	damage_timer = DAMAGE_DURATION
	
	if current_hp <= 0:
		#print("Enemy Died")
		die()

## Handles Enemy death
func die():
	var xp_drop = xp.instantiate()
	xp_drop.position = global_position
	xp_drop.update_xp(50)
	#print("Boss: XP Drop Value = ", xp_drop.xp)
	
	emit_signal("boss_died")  # Emit Signal when enemy dies
	
	#player.kills += 1
	#player.kill_counter.text = "KILLS = " + str(player.kills)
	
	#print("Current Enemies: ", world.current_enemies)
	#world.current_enemies -= 1
	
	get_tree().root.add_child(xp_drop)
	
	queue_free()


#func _on_hurtbox_area_entered(area):
	##print(area.name)
	#if "projectile" in area.name:
		#take_damage(player.dmg)

## Start Damage Timer if the Player enters
func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Hitbox Area Entered: ", area.name)
	if area.name == "Hurtbox" and area.get_parent().name == "Player":
		$Damage_Timer.start()

## Stop the Damage Timer if the Player exits
func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.name == "Hurtbox" and area.get_parent().name == "Player":
		$Damage_Timer.stop()

## Applies Damage each time the timer runs out
func _on_damage_timer_timeout() -> void:
	if player:
		player.take_damage(dmg)


func _on_charge_cooldown_timeout() -> void:
	speed = 600
	$Charge_Timer.start()


func _on_charge_timer_timeout() -> void:
	speed = base_speed
