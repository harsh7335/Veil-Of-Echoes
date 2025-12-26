extends CharacterBody2D

var time_sum = 0.0
@export var patrol_speed = 50
@export var patrol_points : Array[Marker2D]

@export var chase_speed = 75
var is_hunting = false

enum { PATROL, HUNT }
var state = PATROL
var current_point_index = 0
@export var hearing_range = 250

@onready var nav_agent = $NavigationAgent2D

func _ready() -> void:
	if patrol_points.size() > 0:
		nav_agent.target_position = patrol_points[0].global_position

func _physics_process(delta: float) -> void:
	if state == PATROL:
		process_patrol()
		AudioManager.get_node("Ambience").pitch_scale = 1.0
		$BreathingSound.pitch_scale = move_toward($BreathingSound.pitch_scale, 1.0, delta * 2)
		$BreathingSound.volume_db = move_toward($BreathingSound.volume_db, 0, delta * 10)
		
		$Timer.wait_time = 0.4
		$FootstepSound.pitch_scale = move_toward($FootstepSound.pitch_scale, 1.0, delta * 2)
		$FootstepSound.volume_db = move_toward($FootstepSound.volume_db, -6, delta * 10)
	
	elif state == HUNT:
		process_hunt()
		AudioManager.get_node("Ambience").pitch_scale = 0.8
		$BreathingSound.pitch_scale = move_toward($BreathingSound.pitch_scale, 1.5, delta * 2)
		$BreathingSound.volume_db = move_toward($BreathingSound.volume_db, 8.0, delta * 10)
		
		$Timer.wait_time = 0.3
		$FootstepSound.pitch_scale = move_toward($FootstepSound.pitch_scale, 1.3, delta * 2)
		$FootstepSound.volume_db = move_toward($FootstepSound.volume_db, 5.0, delta * 10)
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.length() > 1.0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
		#look_at(next_path_position)
	move_and_slide()
	time_sum += delta
	var flicker = 1.5 + sin(time_sum * 5) * 0.5
	$LeftEye.energy = flicker
	$RightEye.energy = flicker
	if velocity.length() > 0 and $Timer.is_stopped():
		$FootstepSound.pitch_scale=randf_range(0.8, 1.2)
		$FootstepSound.play()
		$Timer.start(0.4)

func _on_hearing_area_area_entered(area):
	if area.is_in_group("sound_wave"):
		var noise_location = area.global_position
		var distance = global_position.distance_to(noise_location)
		#var space_state = get_world_2d().direct_space_state
		#var query = PhysicsRayQueryParameters2D.create(global_position, noise_location)
		#query.collision_mask = 1
		#query.exclude = [get_rid()]
		#
		#var result = space_state.intersect_ray(query)
		#if result:
			##print("Enemy: I heard something, but a wall blocked the sound.")
			#return # Ignore the noise, do NOT start hunting
		#else:
		if distance <= hearing_range:
			go_to_noise(noise_location)
		else:
			print("noise heard but far")

func go_to_noise(target_pos):
	#print("Enemy: Heard noise at ", target_pos)
	state = HUNT
	nav_agent.target_position = target_pos
	


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print("CAUGHT YOU!")
		body.death()


func process_patrol():
	if patrol_points.is_empty(): 
		velocity = Vector2.ZERO
		return
	if nav_agent.is_navigation_finished():
		current_point_index = (current_point_index + 1) % patrol_points.size()
		nav_agent.target_position = patrol_points[current_point_index].global_position
		return
	var next_pos = nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * patrol_speed

func process_hunt():
	if nav_agent.is_navigation_finished():
		#print("Enemy: Lost the trail. Returning to patrol.")
		state = PATROL
		if patrol_points.size() > 0:
			nav_agent.target_position = patrol_points[current_point_index].global_position
		return
	var next_pos = nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * chase_speed
