extends KinematicBody2D

var speed = 50
var vel = Vector2()
var gravity = 1000
var direction = 1
onready var sprite : Sprite = get_node("Sprite")

#movement
func _physics_process(delta):
	vel.x = speed * direction
	vel = move_and_slide(vel, Vector2.UP)
	vel.y += gravity * delta
	if vel.x > 0:
		sprite.flip_h = true
	elif vel.x<0:
		sprite.flip_h = false
	#turns on wall
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	#turns on edge
	if $RayCast2D.is_colliding()==false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
