extends Node

var keys_collected = 0
var horns_left = 5
var max_horns = 5
func refill_horns(amount):
	horns_left += amount
	if horns_left > max_horns:
		horns_left = max_horns
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_level_data():
	keys_collected = 0
	horns_left = max_horns
	
