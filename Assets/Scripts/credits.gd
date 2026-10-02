extends Area2D

@onready var camera: = %Player.get_node("Camera")
@onready var player: = %Player
@onready var credits_camera: Camera2D = %CreditsCamera
@onready var animation_player: AnimationPlayer = %AnimationPlayer as AnimationPlayer
@onready var credits_music: AudioStreamPlayer = $"../../CreditsMusic"
@onready var credits: Label = $"../../Credits"
@onready var time: Label = $"../../Credits/Time"

func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		Global.newgameplus = true
		Global.game_finished = true
		Global.current_level = 1
		camera.enabled = false
		credits_camera.enabled = true
		player.global_position = Vector2(0, 0)
		player.can_move = false
		animation_player.play("camera")
		credits_music.play()
		credits.global_position = Vector2(1740, 167)
		credits.visible = true
		await animation_player.animation_finished
		animation_player.play("credits_animation")


		var final_time = Global.time


		var total_seconds = int(final_time)
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60


		var formatted_time = "%02d:%02d" % [minutes, seconds]


		time.text = formatted_time


		if Global.best_time == 0 or Global.time < Global.best_time:

			Global.best_time = final_time
			Global.save_game(formatted_time, Global.tryhard)
		else:
			Global.save_game(Global.best_time_str, Global.tryhard)

		Global.time = 0
