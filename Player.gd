extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec)
var velocity = Vector2()
var screen_size # Size of the game window
# Clicked position
var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
	
func _process(delta):
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()	
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("diabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
