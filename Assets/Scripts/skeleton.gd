extends CharacterBody2D

const SPEED: = 60
var direction: = 0
var can_attack: = true
var is_dying: = false
var roaming: = true
var arrow_scene: = preload("res://Assets/Scenes/arrow.tscn")
const arrow_speed: int = 150
var times_timer_run: = 0
var arrows: = []
var arrow_instance
var can_die: = false
var attack_animation_playing: = false
var is_taking_damage: = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var animated_sprite: = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var timer: = %Attack_Cooldown
@onready var damage_area: = %Enemy_Damage_Zone
@onready var anim_timer: Timer = $Timers/Anim_Timer
@onready var detection_area: Area2D = $Detection_Area
@onready var boom: AudioStreamPlayer2D = $Boom
@onready var shoot: AudioStreamPlayer2D = $Shoot
@onready var damage: AudioStreamPlayer2D = $Damage
@onready var anim_timer_2: Timer = $Timers/Anim_timer2
@onready var anim_timer_3: Timer = $Timers/Anim_timer3




func _physics_process(delta: float) -> void :
	var overlapping_bodies = detection_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body == player:
			player_detection()


			if is_instance_valid(player) and player.global_position.x > global_position.x and not is_dying:
				animated_sprite.flip_h = false
				direction = -1
				if velocity.x != 0 and not is_dying:
					animated_sprite.play("Walk")
			else:
				if not is_dying:
					animated_sprite.flip_h = true
					direction = 1
					if velocity.x != 0 and not is_dying:
						animated_sprite.play("Walk")


	var at_edge = not ray_cast_down_left.is_colliding() if direction == -1 else not ray_cast_down_right.is_colliding()
	var hit_wall = ray_cast_left.is_colliding() if direction == -1 else ray_cast_right.is_colliding()


	if not at_edge and not hit_wall:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		if not is_dying and not attack_animation_playing and not is_taking_damage:
			animated_sprite.play("Idle")


	for arrow in arrows:
		if is_instance_valid(arrow):
			arrow.global_position += arrow.direction * arrow_speed * delta


	velocity += get_gravity() * delta
	move_and_slide()


func _on_attack_cooldown_timeout() -> void :
	times_timer_run = 0
	can_attack = true
	attack()
	timer.stop()

func _on_damage_enemy_area_body_entered(_body: Node2D) -> void :
	if can_die:
		if player.has_jumped and not is_dying:
			Global.mobs_killed += 1
			player.jump(350)
			can_attack = false
			is_dying = true
			animated_sprite.stop()
			animated_sprite.play("Death")
			boom.playing = true
			anim_timer.start()

	if player.has_jumped and not is_dying:
		can_die = true
		player.jump(350)
		damage.playing = true
		animated_sprite.play("Damage")
		is_taking_damage = true
		anim_timer_3.start()




func _on_timer_timeout() -> void :
	if is_instance_valid(arrow_instance):
		arrows.erase(arrow_instance)
		arrow_instance.queue_free()
	queue_free()



func player_detection():
	if times_timer_run == 0:
		can_attack = false
		timer.start()
		times_timer_run = 1

func attack():
	if can_attack and not Global.is_player_dead and not is_dying:
		if not is_taking_damage:
			animated_sprite.play("Attack")
			attack_animation_playing = true
			anim_timer_2.start()
		shoot.playing = true
		arrow_instance = arrow_scene.instantiate()
		get_parent().add_child(arrow_instance)
		arrows.append(arrow_instance)


		arrow_instance.global_position = global_position


		arrow_instance.direction = (player.global_position - arrow_instance.global_position).normalized()
		arrow_instance.rotation = arrow_instance.direction.angle()


		var arrow_timer = Timer.new()
		arrow_timer.wait_time = 3.0
		arrow_timer.one_shot = true
		arrow_timer.connect("timeout", Callable(self, "_remove_arrow").bind(arrow_instance))
		arrow_instance.add_child(arrow_timer)
		arrow_timer.start()

func _remove_arrow(arrow):
	if is_instance_valid(arrow):
		arrows.erase(arrow)
		arrow.queue_free()

func _on_anim_timer_2_timeout() -> void :
	anim_timer_2.stop()
	attack_animation_playing = false



func _on_anim_timer_3_timeout() -> void :
	anim_timer_3.stop()
	is_taking_damage = false


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
