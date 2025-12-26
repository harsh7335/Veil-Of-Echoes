extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FadeAnim.play("Fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
