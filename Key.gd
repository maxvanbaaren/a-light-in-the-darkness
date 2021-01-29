extends Area2D

#key picked up 
func _on_Key_area_entered(_area):
	var sound = $"pickup"
	if visible == true:
		sound.play()
	visible = false
	
