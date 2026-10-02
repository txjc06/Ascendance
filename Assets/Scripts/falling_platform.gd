extends StaticBody2D

@onready var collision_shape: = %CollisionShape2D
@onready var timer: = $Timer
@onready var timer2: = $Timer2
@onready var animated_sprite: = $AnimatedSprite2D
@onready var raycast: = $RayCast2D
var wait: = 0

func _process(delta: float) -> void :
	if raycast.is_colliding() and not wait == 1:
		timer.start()
		wait = 1


func _on_timer_timeout() -> void :
	collision_shape.disabled = true
	animated_sprite.play("default")
	timer.stop()
	timer2.start()


func _on_timer_2_timeout() -> void :
	collision_shape.disabled = false
	timer2.stop()
	wait = 0
	animated_sprite.play_backwards()
