extends KinematicBody2D

onready var anim : AnimationPlayer = get_node("AnimationPlayer")
onready var sound : AudioStreamPlayer = get_node("Hiss")

#sound and animation on detection 
func _on_Detector_area_entered(_area):
	if anim.is_playing() == false:
		sound.play()
	anim.play("Extend")

#tries to grab on exit as well 
func _on_Detector_area_exited(_area):
	if anim.is_playing() == false:
		sound.play()
	anim.play("Extend")
