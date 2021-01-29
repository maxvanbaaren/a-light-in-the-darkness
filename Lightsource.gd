extends KinematicBody2D


var _gravity = 0
var _movement = Vector2()
#percentage decrease per bounce
var bounce = 0.4

#starts timer to disappear 
func _ready():
	var timer = get_node("Timer")
	timer.set_wait_time(10)
	timer.start()

#gravity 
func toss(directional_force, light_gravity):
	_movement = directional_force
	_gravity = light_gravity
	set_physics_process(true)

#movement 
func _physics_process(delta):
	_movement.y += delta * _gravity
	var entity = move_and_collide(_movement)
	if (entity):
		var normal = entity.get_normal()
		_movement = (_movement - 2 * _movement.dot(normal) * normal) * bounce

#disappears on timeout 
func _on_Timer_timeout():
	queue_free()
