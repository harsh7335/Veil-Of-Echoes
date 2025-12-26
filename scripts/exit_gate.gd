extends Area2D

@export var required_keys = 0           # How many keys to open?
@export var next_level_path : String
@onready var label = $KeysNeeded/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if required_keys - Global.keys_collected <= 0:
		label.text = "Gate Unlocked"
	elif required_keys - Global.keys_collected == 1 :
		label.text = str(required_keys - Global.keys_collected) + " Key Needed"
	else:
		label.text = str(required_keys - Global.keys_collected) + " Keys Needed"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		check_exit()

func check_exit():
	if Global.keys_collected >= required_keys:
		print("Door Unlocked! Advancing...")
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		call_deferred("change_level")
	else:
		print("Locked! You need ", required_keys, " keys. You have ", Global.keys_collected)
		# Optional: Flash the door red or play "Locked" sound
func change_level():
	Global.reset_level_data()
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("Error: No next level scene assigned in Inspector!")
