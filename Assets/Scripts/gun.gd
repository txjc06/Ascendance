extends Node2D

const BULLET = preload("res://Assets/Scenes/bullet.tscn")
var input_cooldown = 0.0
const COOLDOWN_TIME = 0.075

@onready var muzzle: Marker2D = $Marker2D
@onready var fire: AudioStreamPlayer2D = $Fire

func _process(delta: float) -> void :
	if input_cooldown > 0:
		input_cooldown -= delta

	look_at(get_global_mouse_position())

	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.5
	else:
		scale.y = 0.5

	if Input.is_action_just_pressed("fire") and input_cooldown <= 0:
		fire.playing = true
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		input_cooldown = COOLDOWN_TIME
