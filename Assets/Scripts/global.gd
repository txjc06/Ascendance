extends Node

var has_died_this_round: bool
var collected_coins_previous: int
var collected_coins: = collected_coins_previous
var song_position: = 0
var is_player_dead: = false
var fight_started: = false
var first_time_playing: bool = true
var current_level: = 1
var death_counter: int
var time: float
var game_finished: bool = false
var mobs_killed: = 0
var has_taken_damage: = false
var tryhard: = false
var best_time: float
var best_time_str: String
var newgameplus: = false

func Background_SFX(start):
	var background_music = get_node("/root/Area1/BackgroundMusic")
	if is_instance_valid(background_music) and start and first_time_playing:
		background_music.play()
		first_time_playing = false
	elif is_instance_valid(background_music) and start and not first_time_playing:
		background_music.stream_paused = false
	elif is_instance_valid(background_music) and not start:
		background_music.stream_paused = true

func score():
	var displayed_score: = get_node("/root/Area1/CanvasLayer/Score")
	collected_coins += 1
	displayed_score.text = str(collected_coins)

func set_score():
	var displayed_score: = get_node("/root/Area1/CanvasLayer/Score")
	displayed_score.text = str(collected_coins)

func damage_player(body):
	body.damage()

func show_death_screen():
	var player: = get_node("/root/Area1/Player")
	var death_screen: = get_node("/root/Area1/CanvasLayer/Death_Screen")
	player.pause_screen.visible = false
	Global.death_counter += 1
	collected_coins = collected_coins_previous
	Engine.time_scale = 0.5
	death_screen.visible = true
	player.died_sfx.playing = true
	has_died_this_round = true
	is_player_dead = true
	Background_SFX(false)

func update_death_count():
	var death_counter_label: = get_node("/root/Area1/CanvasLayer/Death_counter")
	death_counter_label.text = str(death_counter)


func coinSFX():
	var sfx: = get_node("/root/Area1/SFX/CoinSFX")
	sfx.playing = true

func healSFX():
	var sfx: = get_node("/root/Area1/SFX/HealSFX")
	sfx.playing = true

func save_game(p_best_time: String, p_tryhard: int):
	var save_data = {
		"best_time": p_best_time, 
		"tryhard": p_tryhard
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	var file_path = "user://savegame.json"
	if not FileAccess.file_exists(file_path):
		return {"best_time": "", "tryhard": false}

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(content)
	if parse_result != OK:
		return {"best_time": "", "tryhard": false}

	return json.get_data()
