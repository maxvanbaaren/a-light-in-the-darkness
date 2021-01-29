extends KinematicBody2D

var score : int = 0
var speed : int = 200
var jumpForce : int = 400
var isjumping = false
var isfalling = false
var gravity : int = 1000
var velocity : Vector2 = Vector2() 
onready var sprite : Sprite = get_node("Sprite")
onready var anim : AnimationPlayer = get_node("AnimationPlayer")
var cur_anim = "idle"
var numlight = 3
var isdead = false

var throwing = false
export (int) var light_gravity = 5
export (int) var light_speed = 5
export (float) var light_angle = 330
export (float) var throw_delay = 1
var waited = 0
var directional_force = Vector2()
#lightsource scene
export (PackedScene) var light_scene 
#lightsourcespawn
export (NodePath) var lightsourcespawn_path
onready var lightsourcespawn = get_node(lightsourcespawn_path)

onready var hud = get_node("/root/Hud").get_node("CanvasLayer")
onready var doorbox = get_node("DoorBox")
onready var timer = get_node("distantMonsterTimer")
onready var death_timer = get_node("DeathTimer")


func _physics_process(delta):
	velocity.x = 0
	
	#movement inputs
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		
	#apply velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#gravity
	velocity.y += gravity * delta
	
	#jump input
	#is_action_just_pressed for not continuous jumping
	if Input.is_action_pressed("jump") and is_on_floor() and isdead == false: 
		velocity.y -= jumpForce
		isjumping = true
		#jump sound effect
		var jump_sound = $"JumpSound"
		jump_sound.play()
	#landing sound effect/animation 
	if is_on_floor() and isfalling == true:
		var land_sound = $"LandSound"
		land_sound.play()
		isfalling = false
		AnimationChange("land")
	if velocity.y>0 and !is_on_floor():
		isfalling = true
		isjumping = false
		
	#sprite direction
	if velocity.x < 0:
		sprite.flip_h = true
		light_angle = 210
		update_directional_force()
	elif velocity.x>0:
		sprite.flip_h = false
		light_angle = 330
		update_directional_force()
		
	#animations
	if !is_on_floor():
		 AnimationChange("jump")
	elif is_on_floor():
		if velocity.x == 0:
			AnimationChange("idle")
		elif velocity.x != 0:  
			AnimationChange("running") 
	#throw light
	if Input.is_action_pressed("throwlight"):
		if numlight > 0:
			throwing = true
	elif Input.is_action_just_released("throwlight"):
		throwing = false

#changes animation 
func AnimationChange(new_anim):
	if new_anim != cur_anim:
		anim.play(new_anim)
		cur_anim = new_anim

func update_directional_force():
	directional_force = Vector2(cos(light_angle*(PI/180)), sin(light_angle*(PI/180))) * light_speed

func _ready():
	update_directional_force()
	var music = $"Music"
	music.play() #background music 
	timer.set_wait_time(15) #background noise timer
	timer.start()
	doorbox.get_node("CollisionShape2D").disabled = true #won't unlock door unless you have key
	#hud visible 
	hud.get_node("Sprite").visible = true;
	hud.get_node("Sprite2").visible = true;
	hud.get_node("Sprite3").visible = true;

#throw light source if one hasn't just been thrown 
func _process(delta):
	if(throwing and waited > throw_delay):
		ThrowOnce()
		waited = 0
	elif(waited <= throw_delay):
		waited += delta

#update hud 
func ThrowOnce():
	ThrowLight()
	throwing = false
	numlight-=1
	if(numlight==2):
		hud.get_node("Sprite2").visible = false;
	elif(numlight==1):
		hud.get_node("Sprite3").visible = false;
	elif(numlight==0):
		hud.get_node("Sprite").visible = false;

#spawn light source and toss it 
func ThrowLight():
	var thrownlight = light_scene.instance()
	thrownlight.set_global_position(lightsourcespawn.get_global_position())
	get_parent().add_child(thrownlight)
	thrownlight.toss(directional_force, light_gravity)

#door unlocked 
func _on_KeyBox_area_entered(_area):
	doorbox.get_node("CollisionShape2D").set_deferred("disabled", false)

#screen goes dark on death, death sound played 
func _on_KillBox_area_entered(_area):
	if isdead == false:
		isdead = true
		hud.get_node("Sprite").visible = false;
		hud.get_node("Sprite2").visible = false;
		hud.get_node("Sprite3").visible = false;
		get_node("Light2D").enabled = false
		get_node("Sprite").visible = false
		get_node("DeathSound").play()
		death_timer.set_wait_time(5)
		death_timer.start()

#background sound 
func _on_distantMonsterTimer_timeout():
	get_node("distantMonster").play()
	timer.set_wait_time(25)
	timer.start()

#stop movement when entering open door 
func _on_DoorBox_area_entered(_area):
	speed = 0

#reload scene on death 
func _on_DeathTimer_timeout():
	get_tree().reload_current_scene() 
