extends ProgressBar

## Controls Health Bar

#@onready var health_bar = $ProgressBar
@onready var stylebox: StyleBoxFlat
@onready var damage_timer = $Damage_Timer
@onready var bar_timer = $Bar_Timer
@onready var damage_bar = $Damage_Bar

var max_health = 100  
var current_health = max_health  
#var health = 0 : set = _set_health
var fade = 0

var enable_fade = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#stylebox = theme_overrides_styles.fill as StyleBoxFlat
	pass


## Handles Visual Update every frame
func _process(delta):
	#var health_percentage = value / max_value
	#if health_percentage > 0.5:
		#self.bg_color = Color(0, 1, 0)  # Green
	#elif health_percentage > 0.25:
		#stylebox.bg_color = Color(1, 1, 0)  # Yellow
	#else:
		#stylebox.bg_color = Color(1, 0, 0)  # Red
	
	if fade > 0:	
		fade -= delta
		#self_modulate = Color(1,1,1,fade)
		#damage_bar.self_modulate = Color(1,1,1,fade)
		self.modulate = Color(1,1,1,fade)
	
	pass

#func init_health(_health):
	#current_health = _health
	#max_health = current_health
	#value = current_health
	#damage_bar.max_value = current_health
	#damage_bar.value = current_health


#func _set_health(new_health):
	#var prev_health = health
	#health = min(max_value, new_health)
	#value = health
	#self.modulate = Color(1,1,1,1)
	#
	#if health <= 0:
		#queue_free()
	#
	#if health < prev_health:
		#damage_timer.start()
	#else:
		#damage_bar.value = health


## Set Health and Update the Health Bar
func set_health(new_health):
	var prev_health = current_health
	
	current_health = clamp(new_health, 0, max_health)
	
	value = current_health  # Update the Health Bar value
	self.modulate = Color(1,1,1,1)  # Reset the Health Bar to be visible if fade was enabled
	
	if current_health <= 0:
		queue_free()
	
	if current_health < prev_health:
		damage_timer.start()
	else:
		damage_bar.value = current_health
		bar_timer.start()
	
	#damage_bar.value = current_health

## Set Max Health
func set_max_health(new_health):
	max_health = max(new_health, 1)
	current_health = max_health
	
	max_value = max_health  # Update the Health Bar max value
	value = current_health
	
	self.modulate = Color(1,1,1,1)
	bar_timer.start()
	
	damage_bar.max_value = current_health
	damage_bar.value = current_health

## Handles Signal Emitted from Player 
func _on_player_health_changed(value: Variant) -> void:
	set_health(value)


func _on_enemy_health_changed(value: Variant) -> void:
	set_health(value)

func _on_boss_health_changed(value: Variant) -> void:
	set_health(value)


func _on_damage_timer_timeout() -> void:
	damage_bar.value = current_health
	bar_timer.start()


func _on_bar_timer_timeout() -> void:
	#visible = false
	if enable_fade:
		self.fade = 1
