extends Area2D

onready var closed = get_node("Sprite")
onready var open = get_node("Open")

#door opens
func _on_Door_area_entered(_area):
	var sound = $"sound"
	sound.play()
	closed.visible = false
	open.visible = true
	var timer = get_node("Timer")
	timer.set_wait_time(1)
	timer.start()

#changes scene
func _on_Timer_timeout():
	if get_tree().get_current_scene().get_name() == "L1":
		get_tree().change_scene("res://L2.tscn")
	elif get_tree().get_current_scene().get_name() == "L2":
		get_tree().change_scene("res://L3.tscn")
	elif get_tree().get_current_scene().get_name() == "L3":
		get_tree().change_scene("res://L4.tscn")
	elif get_tree().get_current_scene().get_name() == "L4":
		get_tree().change_scene("res://L5.tscn")
	elif get_tree().get_current_scene().get_name() == "L5":
		get_tree().change_scene("res://MoreComing.tscn")
