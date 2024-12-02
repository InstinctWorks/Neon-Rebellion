extends Area2D

## Handle XP Collectible

var xp = 5  # Default XP Value

func _ready():
	add_to_group("Collectibles")

func _on_body_entered(body):
	if "Player" in body.name:
		body.collect("xp")
		queue_free()
