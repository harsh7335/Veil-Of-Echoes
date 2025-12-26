extends Node2D

var spooky_sounds = [
	preload("res://assets/SFX/ghostly-humming-63204.mp3"),
	preload("res://assets/SFX/her-laugh-40333.mp3"),
	preload("res://assets/SFX/squeak-metal-low-volume.mp3"),
	preload("res://assets/SFX/whisper5-94457.mp3"),
	preload("res://assets/SFX/door-creaking-121673.mp3")
	]

var min_time = 15.0
var max_time = 45.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	start_random_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spooky_timer_timeout() -> void:
	play_random_sound()
	
	start_random_timer()

func start_random_timer():
	var random_wait = randf_range(min_time, max_time)
	$SpookyTimer.start(random_wait)

func play_random_sound():
	print("played randsound")
	var random_index = randi() % spooky_sounds.size()
	$SpookySfx.stream = spooky_sounds[random_index]
	
	$SpookySfx.pitch_scale = randf_range(0.8, 1.1)
	$SpookySfx.volume_db = randf_range(-5.0, 0.0)
	
	$SpookySfx.play()
	
