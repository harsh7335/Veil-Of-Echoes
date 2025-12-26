extends Node2D


var expansion_speed = 6
var fade_speed = 3
var max_scale = 40

func _process(delta):
	# 1. Expand the wave (Scale it up)
	scale += Vector2(expansion_speed, expansion_speed) * delta
	#
	## 2. Fade out the light energy over time
	## We access the PointLight2D child to dim it
	$PointLight2D.energy -= fade_speed * delta
	#
	## 3. Cleanup: If the light is too dim, delete the object
	if $PointLight2D.energy <= 0:
		queue_free()
	
