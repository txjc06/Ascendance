extends TileMapLayer

@onready var explosion: AnimatedSprite2D = $"../Explosion"
@onready var boom: AudioStreamPlayer2D = $"../Boom"
@onready var victory: AudioStreamPlayer = $"../Victory"
@onready var boss_music: AudioStreamPlayer = $"../BossMusic"


var tiles: Array = [
	Vector2(107, -5), 
	Vector2(107, -4), 
	Vector2(107, -3), 
	Vector2(107, -2), 
	Vector2(107, -1)
]

func _on_stone_golem_defeated() -> void :
	for tile in tiles:
		set_cell(tile, -1)
	boss_music.stop()
	explosion.play("Boom")
	boom.play()
	await boom.finished
	victory.play()
