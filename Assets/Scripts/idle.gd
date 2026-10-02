extends State

@onready var collision: CollisionShape2D = $"../../Player_Detection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")
@onready var boss_music: AudioStreamPlayer = owner.get_parent().find_child("BossMusic")


var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)

func transition():
	if player_entered:
		Global.fight_started = true
		boss_music.play()
		get_parent().change_state("Follow")

func _on_player_detection_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		player_entered = true
