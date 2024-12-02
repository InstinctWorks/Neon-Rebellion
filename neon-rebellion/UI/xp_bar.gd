extends ProgressBar

## Handles XP Bar

## Signals
signal level_up  

var max_xp = 10  
var current_xp = 0  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Set Health and Update the Health Bar
func set_xp():
	max_xp = max_value
	value = current_xp  # Update the XP Bar value
	

# TODO Implement XP Bar
func add_xp(amount: int) -> void:
	current_xp += amount
	
	if current_xp >= max_xp:
		current_xp -= max_xp
		emit_signal("level_up")
	
	value = current_xp
	
	print("XP Bar: XP Collected = ", current_xp)
