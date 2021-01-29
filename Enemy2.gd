extends KinematicBody2D

var direction = 0
var speed = 200
var gravity = 1000
var vel = Vector2()
onready var sprite = get_node("Sprite")
var chase = false
var crazy = false
onready var chase_music = $"chasemusic2"

func _physics_process(delta):
	vel.y += gravity * delta
	if vel.x > 0:
		sprite.flip_h = true #flips sprite depending on direction
	elif vel.x<0:
		sprite.flip_h = false
	if chase == true and crazy == false: #chases player
		vel.x = speed * direction
		vel = move_and_slide(vel, Vector2.UP)
	if crazy == true: #while crazy, half speed, goes opposite direction
		vel.x = speed/2 * direction
		vel = move_and_slide(vel, Vector2.UP)
	if crazy == true: #cant chase while crazy 
		get_node("Area2D/CollisionShape2D").disabled = true
		get_node("Area2D2/CollisionShape2D").disabled = true
	if crazy == false: #turns detection back on 
		get_node("Area2D/CollisionShape2D").disabled = false
		get_node("Area2D2/CollisionShape2D").disabled = false
	#chase sound 
	if vel.x != 0 and chase_music.playing == false:
		chase_music.play()

#chase left 
func _on_Area2D_area_entered(_area):
	direction = -1
	chase = true

#chase right 
func _on_Area2D2_area_entered(_area):
	direction = 1
	chase = true

#back to normal 
func _on_Timer_timeout():
	crazy = false

