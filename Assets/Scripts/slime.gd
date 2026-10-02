extends CharacterBody2D

const SPEED = 60
var direction = 1
var can_attack = true
var is_dying = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var animated_sprite: = %AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var timer: = %Attack_Cooldown
@onready var damage_area: = %Enemy_Damage_Zone
@onready var anim_timer: Timer = %Anim_Timer
@onready var boom: AudioStreamPlayer2D = $Boom




func _ready() -> void :
	pass

func _physics_process(delta: float) -> void :
	velocity += get_gravity() * delta
	move_and_slide()
	if is_dying == false:
		animated_sprite.play("Idle")



func _process(delta: float) -> void :
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if not ray_cast_down_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if not ray_cast_down_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if not is_dying:
		position.x += direction * SPEED * delta

	if can_attack and not Global.is_player_dead:
		var overlapping_bodies = damage_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body == player:
				Global.damage_player(body)
				can_attack = false
				timer.start()
				break

func _on_attack_cooldown_timeout() -> void :
	can_attack = true
	timer.stop()

func enemy():
	pass


func _on_damage_enemy_area_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		if player.has_jumped == true and not is_dying:
			Global.mobs_killed += 1
			player.jump(350)
			can_attack = false
			is_dying = true
			animated_sprite.stop()
			animated_sprite.play("Death")
			boom.playing = true
			anim_timer.start()


func _on_timer_timeout() -> void :
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void :
	if body.has_method("bullet") and not is_dying:
		Global.mobs_killed += 1
		body.bullet()
		can_attack = false
		is_dying = true
		animated_sprite.stop()
		animated_sprite.play("Death")
		boom.playing = true
		anim_timer.start()
