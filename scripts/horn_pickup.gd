extends Area2D
@export var amount = 5

# Called when the node enters the scene tree for the first time.
var collected = false
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if collected == true:
		return
	elif body.is_in_group("player"):
		collected = true
		$".".visible = false
		Global.refill_horns(amount)
		print("Refilled! Horns left: ", Global.horns_left)
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		queue_free()
