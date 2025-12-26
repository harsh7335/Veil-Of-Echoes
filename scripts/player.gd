extends CharacterBody2D

var wave_scene = preload("res://scenes/sound_wave.tscn")
@onready var glow_light = $GlowLight
@onready var death_sound = $DeathSound
@onready var fade_anim = $FadeLayer/FadeAnims

var can_use_horn = true
var horn_cooldown = 2.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_dir="down"
var move_speed : float = 100
var if_dead = false

func _ready() -> void:
	fade_anim.play("fade_in")

func _physics_process(delta: float) -> void:
	if if_dead:
		return
	player_movement(delta)
	handle_horn_input()
	if velocity.length() > 0 and $Timer.is_stopped():
		$Footsteps.pitch_scale = randf_range(0.8, 1.2)
		$Footsteps.play()
		$Timer.start(0.4)



func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir="right"
		play_anim(1)
		velocity.x=move_speed
		velocity.y=0
	elif Input.is_action_pressed("left"):
		current_dir="left"
		play_anim(1)
		velocity.x=-move_speed
		velocity.y=0
	elif Input.is_action_pressed("down"):
		current_dir="down"
		play_anim(1)
		velocity.x=0
		velocity.y=move_speed
	elif Input.is_action_pressed("up"):
		current_dir="up"
		play_anim(1)
		velocity.x=0
		velocity.y=-move_speed
	else :
		play_anim(0)
		velocity.x=0
		velocity.y=0
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $Animations
	
	if dir=="right":
		anim.flip_h = false
		if movement==1:
			anim.play("side_run")
		elif movement==0:
			#if attack_ip == false:
			anim.play("side_idle")
	if dir=="left":
		anim.flip_h = true
		if movement==1:
			anim.play("side_run")
		elif movement==0:
			#if attack_ip == false:
			anim.play("side_idle")
	if dir=="up":
		anim.flip_h = false
		if movement==1:
			anim.play("back_run")
		elif movement==0:
			#if attack_ip == false:
			anim.play("back_idle")
	if dir=="down":
		anim.flip_h = false
		if movement==1:
			anim.play("front_run")
		elif movement==0:
			#if attack_ip == false:
			anim.play("front_idle")

func handle_horn_input():
	if Input.is_action_just_pressed("wave") and can_use_horn:
		if Global.horns_left > 0:
			spawn_sound_wave()
			Global.horns_left -= 1 
			can_use_horn = false
			glow_light.energy = 0.2
			get_tree().create_timer(horn_cooldown).timeout.connect(reset_horn_cooldown)
			#update_ui()
		else:
			print("Out of blasts!")
			# Optional: Play a "click" or "fail" sound here later

func reset_horn_cooldown():
	can_use_horn = true
	glow_light.energy = 1
	# Optional: Play a "ding" sound or flash the player to show it's ready
func spawn_sound_wave():
	var wave = wave_scene.instantiate()
	wave.global_position = global_position + Vector2(0,4)
	get_tree().current_scene.add_child(wave)

func death():
	if_dead = true
	death_sound.play()
	fade_anim.play("fade_out")
	await fade_anim.animation_finished
	get_tree().call_deferred("reload_current_scene")
