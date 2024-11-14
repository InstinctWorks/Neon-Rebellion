extends Area2D

## Player Projectile

const SPEED = 750  

const PROJECTILE_DISTANCE = 1
var direction = Vector2.RIGHT  # Note: Fire Direction (Antoine)
#var projectile_timer = PROJECTILE_DISTANCE
var dmg = 10  # Added Constant for Damage Value

func _physics_process(delta):
	#print("Projectile Direction: ", direction)
	position += direction * SPEED * delta  # Changed so that projectile can be fired left/right (Antoine)


func _on_area_entered(area):
	#print("Projectile is hitting area2d: ", area.name)
	#print("Projectile area2d group: ", area.get_groups())
	
	if area.is_in_group("Collectibles") or area.is_in_group("Player"):
		return
	
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent()
		enemy.take_damage(dmg)
		queue_free()


#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Enemy"):
		#body.take_damage(dmg)
		#queue_free()
