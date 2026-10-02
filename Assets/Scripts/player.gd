extends CharacterBody2D

@export var speed: = 120
@export var jump_power: = 300.0
@onready var animated_sprite: = %AnimatedSprite2D
@onready var coyote_timer: = $"Coyote time"
@onready var progress_bar: = $TextureProgressBar
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX
@onready var died_sfx: AudioStreamPlayer2D = $DiedSFX
@onready var landed: AudioStreamPlayer2D = $Landed
@onready var run: AudioStreamPlayer2D = $Run
@onready var damage_timer: Timer = $Damage_timer
@onready var gun_position: Marker2D = $GunPosition
@onready var respawn_sound: AudioStreamPlayer2D = $RespawnSound
@onready var particles_left: AnimatedSprite2D = $AnimatedSprite2D/Particles_Left
@onready var particles_right: AnimatedSprite2D = $AnimatedSprite2D/Particles_Right
@onready var jump_position: Marker2D = $JumpPosition
@onready var pause_screen: CanvasLayer = $"../Pause_Screen"
@onready var transition_node: Node2D = %TransitionNode
@onready var transition_node_anim: = transition_node.find_child("AnimationPlayer")
@onready var gun_sound: AudioStreamPlayer = $Gun_sound


const GUN = preload("res://Assets/Scenes/gun.tscn")
const JUMP = preload("res://Assets/Scenes/jump.tscn")
var speed_multiplier: = 1
var jump_multiplier: = -1.0
var direction: = 0
var can_move: = true
var can_jump: = false
var has_jumped: = false
var health: = 100
var is_in_menu: = false
var times_timer_run: = 0
var is_being_hit: = false
var can_play_audio: = true
var has_played_landed: = true
var can_jump_special: = true

func _ready() -> void :
	Global.is_player_dead = false
	Global.update_death_count()
	transition_node.visible = true
	transition_node_anim.play("Fade_in")
	await transition_node_anim.animation_finished
	transition_node.visible = false
	Global.set_score()
	if Global.has_died_this_round:
		respawn_sound.play()
	Global.first_time_playing = true
	if is_instance_valid(get_parent().find_child("BackgroundMusic")) and not is_instance_valid(get_parent().find_child("Last_Level")):
		Global.Background_SFX(true)
	if Global.newgameplus:
		var gun_instance = GUN.instantiate()
		get_parent().find_child("Player").add_child(gun_instance)
		gun_instance.position = gun_position.position
		if Global.current_level == 1:
			gun_sound.play()

func _physics_process(delta: float) -> void :
	Global.time = Global.time + delta

	progress_bar.value = move_toward(progress_bar.value, health, 100 * delta)


	coyote_time()
	landed_logic()


	if not is_on_floor() and can_move:
		velocity += get_gravity() * delta
		if not is_being_hit:
			animated_sprite.play("Falling")


	if Input.is_action_just_pressed("jump") and can_jump and can_move and not has_jumped and not is_in_menu:
		particles_left.visible = false
		particles_right.visible = false
		jump(jump_power)



	if Input.is_action_just_pressed("menu") and not Global.is_player_dead:
		if not is_in_menu:
			Engine.time_scale = 0.1
			is_in_menu = true
			pause_screen.visible = true
		else:
			Engine.time_scale = 1
			is_in_menu = false
			pause_screen.visible = false


	var input_direction: = Input.get_axis("move_left", "move_right")
	if input_direction and can_move:
		velocity.x = input_direction * speed * speed_multiplier
	elif can_move:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)


	if input_direction == -1 and can_move and not is_in_menu:
		animated_sprite.flip_h = true
		if is_on_floor() and not is_being_hit:
			animated_sprite.play("Run")
			particles_right.play("Right")
			if not has_jumped:
				particles_right.visible = true
			if can_play_audio:
				run.playing = true
				can_play_audio = false
	elif input_direction == 1 and can_move and not is_in_menu:
		animated_sprite.flip_h = false
		if is_on_floor() and not is_being_hit:
			animated_sprite.play("Run")
			particles_left.play("Left")
			if not has_jumped:
				particles_left.visible = true
			if can_play_audio:
				run.playing = true
				can_play_audio = false
	elif input_direction == 0 and is_on_floor() and not is_being_hit and can_move:
		animated_sprite.play("Idle")
		particles_left.visible = false
		particles_right.visible = false
	else:
		if can_move:
			%AnimatedSprite2D.play("Hit")


	move_and_slide()

func player():
	pass


func death():
	if not Global.is_player_dead:
		Global.is_player_dead = true
		can_move = false
		velocity = Vector2.ZERO
		animated_sprite.play("Death")
		Global.show_death_screen()
		died_sfx.playing = true



func coyote_time():
	if is_on_floor():
		has_jumped = false
		can_jump = true
		times_timer_run = 0
	else:
		if times_timer_run == 0:
			coyote_timer.start()
			times_timer_run = 1



func damage():
	if not Global.is_player_dead:
		Global.has_taken_damage = true
		health -= 25
		%AnimatedSprite2D.play("Hit")
		hurt_sfx.playing = true
		is_being_hit = true
		Engine.time_scale = 0.1
		damage_timer.start()
		if health <= 0:
			is_being_hit = false
			death()

func heal():
	Global.healSFX()
	health += 50
	if health > 100:
		health = 100
	else:
		progress_bar.value = health

func _on_restart_pressed() -> void :
	Global.is_player_dead = false
	Global.fight_started = false
	transition_node.visible = true
	transition_node_anim.play("Fade_out")
	await transition_node_anim.animation_finished
	if is_instance_valid(get_tree()):
		get_tree().reload_current_scene()
	Engine.time_scale = 1


func _on_coyote_time_timeout() -> void :
	can_jump = false
	coyote_timer.stop()

func jump(p_jump_power: float) -> void :
	if can_jump_special:
		jump_sfx.playing = true
		var jump_instance = JUMP.instantiate()
		get_tree().root.add_child(jump_instance)
		jump_instance.position = jump_position.global_position
		has_jumped = true
		velocity.y = p_jump_power * jump_multiplier
		has_played_landed = false
		await jump_instance.animation_finished
		jump_instance.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void :
	is_being_hit = false


func landed_logic():
	if is_on_floor() and not has_played_landed:
		landed.playing = true
		has_played_landed = true


func _on_run_finished() -> void :
	can_play_audio = true


func _on_damage_timer_timeout() -> void :
	damage_timer.stop()
	Engine.time_scale = 1


func _on_resume_pressed() -> void :
	Engine.time_scale = 1
	is_in_menu = false
	pause_screen.visible = false

func _on_main_menu_pressed() -> void :
	if not Global.game_finished:
		Global.collected_coins = Global.collected_coins_previous
		is_in_menu = false
		Global.is_player_dead = false
		Global.fight_started = false
		Engine.time_scale = 1
		transition_node.visible = true
		transition_node_anim.play("Fade_out")
		await transition_node_anim.animation_finished
		if is_instance_valid(get_tree()):
			Engine.time_scale = 1
			get_tree().change_scene_to_file("res://Assets/Scenes/Area/main_menu.tscn")
	else:
		Global.mobs_killed = 0
		Global.has_taken_damage = false
		Global.collected_coins = 0
		Global.collected_coins_previous = 0
		is_in_menu = false
		Global.is_player_dead = false
		Global.fight_started = false
		Engine.time_scale = 1
		transition_node.visible = true
		transition_node_anim.play("Fade_out")
		await transition_node_anim.animation_finished
		if is_instance_valid(get_tree()):
			Engine.time_scale = 1
			get_tree().change_scene_to_file("res://Assets/Scenes/Area/main_menu.tscn")
