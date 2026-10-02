extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().find_child("Player")

var bullet_health: = 200
var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void :

	acceleration = (player.position - position).normalized() * 700

	velocity += acceleration * delta
	rotation = velocity.angle()
	velocity = velocity.limit_length(300)
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void :
	if body.has_method("bullet"):
		bullet_health -= 50
		body.bullet()
		if bullet_health <= 0:
			body.bullet()
			queue_free()
	if body.has_method("player"):
		body.damage()
		queue_free()
