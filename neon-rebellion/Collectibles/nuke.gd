extends Area2D

## Nuke

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("nuke")
	add_to_group("Collectibles")

func _on_body_entered(body):
	if "Player" in body.name:
		body.collect(self)
		#body.collect("nuke")
		queue_free()
	#print(body.name)
