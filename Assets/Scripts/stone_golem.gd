extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var progress_bar: TextureProgressBar = $UI/ProgressBar
@onready var marker: Marker2D = $Sprite2D/Marker2D
@onready var attack: AudioStreamPlayer2D = $Attack
@onready var death: AudioStreamPlayer2D = $Death
@onready var laser: AudioStreamPlayer2D = $Laser
@onready var victory: AudioStreamPlayer = $"../Victory"

signal defeated



var direction: Vector2
var DEF = 0

var health = 1500:
	set(value):
		if Global.fight_started:
			health = value
			if value <= 0:
				progress_bar.visible = false
				find_child("FiniteStateMachine").change_state("Death")
			elif value <= progress_bar.max_value / 2 and DEF == 0:
				DEF = 5
				find_child("FiniteStateMachine").change_state("ArmorBuff")

func _ready() -> void :
	set_physics_process(false)

func _process(delta: float) -> void :
	direction = player.position - position
	progress_bar.value = move_toward(progress_bar.value, health, maxf(100.0, absf(progress_bar.value - health) * 8.0) * delta)

	if direction.x < 0:
		sprite_2d.flip_h = true
		marker.position = Vector2(-40, -9)
	else:
		sprite_2d.flip_h = false
		marker.position = Vector2(40, -9)

func _physics_process(delta: float) -> void :
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)


func take_damage():
	health -= 10 - DEF

func damage_player():
	Global.damage_player(player)

func melee_attack_sound():
	attack.play()

func death_sound():
	death.play()

func laser_sound():
	laser.play()

func death_fn():
	emit_signal("defeated")
