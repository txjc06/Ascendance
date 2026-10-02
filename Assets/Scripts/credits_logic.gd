extends Label

@onready var rank: Label = $Rank as Label
@onready var death_num: Label = $Death_num as Label
@onready var coin_num: Label = $Coin_num
@onready var mobs_killed_count: Label = $Mobs_killed_count



func _on_area_2dd_3_body_entered(body: Node2D) -> void :
	if Global.collected_coins <= 8 or Global.death_counter >= 15:
		rank.text = "F"
	elif (Global.collected_coins > 8 and Global.collected_coins <= 10) and Global.death_counter < 15:
		rank.text = "E"
	elif (Global.collected_coins > 10 and Global.collected_coins <= 12) and Global.death_counter < 10:
		rank.text = "D"
	elif (Global.collected_coins > 12 and Global.collected_coins <= 16) and Global.death_counter < 9:
		rank.text = "C"
	elif (Global.collected_coins > 16 and Global.collected_coins <= 22) and Global.death_counter < 8:
		rank.text = "B"
	elif (Global.collected_coins > 22 and Global.collected_coins < 26) and Global.death_counter < 7:
		rank.text = "A"
	elif Global.collected_coins == 26 and Global.death_counter > 0:
		rank.text = "S"
	elif Global.collected_coins == 26 and Global.death_counter == 0 and Global.has_taken_damage:
		rank.text = "SS"
	elif Global.collected_coins == 26 and Global.death_counter == 0 and not Global.has_taken_damage:
		rank.text = "SSS"
		Global.tryhard = true

	death_num.text = str(Global.death_counter)
	coin_num.text = str(Global.collected_coins)
	mobs_killed_count.text = str(Global.mobs_killed)
