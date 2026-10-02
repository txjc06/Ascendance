extends Control

@onready var start: Button = %Start
@onready var exit: Button = %Exit
@onready var reset: Button = %Reset
@onready var transition_node: Node2D = $TransitionNode
@onready var transition_node_anim: = transition_node.find_child("AnimationPlayer")
@onready var best_time_label: Label = $Main_menu/Best_time
@onready var time: Label = $Main_menu/Time
@onready var tryhard_label: Label = $Main_menu/Tryhard


var best_time = 0
var tryhard: bool

func _ready() -> void :
	var game_data = Global.load_game()


	if game_data["best_time"] != "":
		best_time_label.visible = true
		time.visible = true
		best_time = game_data["best_time"]
		Global.best_time = convert_time_to_seconds(game_data["best_time"])
		Global.best_time_str = best_time
		print(best_time)
	else:
		best_time_label.visible = false
		time.visible = false

	tryhard = game_data["tryhard"]
	time.text = str(best_time)
	tryhard_label.visible = tryhard

	if Global.current_level > 1:
		start.text = "Resume"
	else:
		start.text = "Start"


func convert_time_to_seconds(time_string: String) -> float:
	var parts = time_string.split(":")
	if parts.size() == 2:
		var minutes = int(parts[0])
		var seconds = int(parts[1])
		return float(minutes * 60 + seconds)
	else:

		print("Invalid time format: ", time_string)
		return 0



func _on_start_pressed() -> void :
	Global.game_finished = false
	transition_node.visible = true
	transition_node_anim.play("Fade_out")
	await transition_node_anim.animation_finished
	if Global.current_level == 1 and is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Assets/Scenes/Area/Starting_Area.tscn")
	elif Global.current_level == 2 and is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Assets/Scenes/Area/The_Underground.tscn")
	elif Global.current_level == 3 and is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Assets/Scenes/Area/The_Underground_lvl3.tscn")
	elif Global.current_level == 4 and is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Assets/Scenes/Area/End.tscn")


func _on_exit_pressed() -> void :
	transition_node.visible = true
	transition_node_anim.play("Fade_out")
	await transition_node_anim.animation_finished
	get_tree().quit()





func _on_reset_pressed() -> void :
	Global.has_taken_damage = false
	Global.newgameplus = false
	Global.game_finished = false
	Global.collected_coins = 0
	Global.collected_coins_previous = 0
	Global.death_counter = 0
	start.text = "Start"
	Global.current_level = 1
	Global.time = 0
