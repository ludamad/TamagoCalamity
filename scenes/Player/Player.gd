extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

var velocity := Vector2.ZERO
export var walk_speed := 150 


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = true
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
		animatedSprite.animation = "Run"
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		animatedSprite.animation = "Run"
	else:
		animatedSprite.play("Idle")
	velocity = velocity.normalized() * walk_speed
	velocity = move_and_slide(velocity)
