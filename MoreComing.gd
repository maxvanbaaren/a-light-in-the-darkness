extends Node2D

onready var hud = get_node("/root/Hud").get_node("CanvasLayer")

#hud not visible 
func _ready():
	hud.get_node("Sprite").visible = false;
	hud.get_node("Sprite2").visible = false;
	hud.get_node("Sprite3").visible = false;


