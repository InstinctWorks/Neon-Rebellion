extends AudioStreamPlayer

var active_tween: Tween = null

func _ready() -> void:
	if not is_playing():
		play()

func fade_in(duration: float = 2.0):
	print("Fading in Music...")
	
	if active_tween:
		#active_tween.stop_all()
		active_tween.kill()
		active_tween = null
	
	
	volume_db = -80  # Start muted
	
	#var tween = get_tree().create_tween()
	
	active_tween = get_tree().create_tween()
	active_tween.tween_property(self, "volume_db", 0, duration)  # Fade to full volume (0 dB)
	active_tween.finished.connect(_on_fade_in_finished)
	
	#play()
	
	print("Volume After Fade-in: ", volume_db)

func fade_out_and_stop(duration: float = 2.0):
	print("Fading out Music...")  
	
	if active_tween:
		#active_tween.stop_all()
		active_tween.kill()
		active_tween = null
	
	var tween = get_tree().create_tween()  
	
	active_tween = get_tree().create_tween()
	active_tween.tween_property(self, "volume_db", -80, duration)  
	active_tween.finished.connect(_on_fade_out_finished)  # Stop playback when fade-out is done
	
	print("Volume After Fade-out: ", volume_db)  

func _on_fade_in_finished():
	print("Fade-in completed.")
	active_tween = null

func _on_fade_out_finished():
	print("Fade-out completed. Stopping Music.")
	stop()
	active_tween = null

func reset_music():
	print("Resetting Music...")
	
	if active_tween:
		#active_tween.stop_all()
		active_tween.stop()
		active_tween = null
	
	stop()
	volume_db = -80  
	print("Music reset to muted state.") 
