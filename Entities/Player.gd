extends KinematicBody2D

# Player movement
export var ACCELERATION = 75
export var FRICTION = 50
export var SPEED = 200

onready var timer = $RefreshTimer

var water_speed = 300
var foam_speed = 50
var water = preload("res://Entities/Bullet.tscn")
var velocity = Vector2.ZERO


#extinguisher preload
var ext = preload("res://Entities/foam.tscn")

# End game preload
var endgame = preload("res://UI/PlayAgain.tscn")


func _ready():
	add_to_group("enemy_killed")


func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	# Face player towards mouse
	look_at(get_global_mouse_position())

	# Gather movement key input into new input_vector
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION)
		$Sprite.play("test")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		$Sprite.stop()
	velocity = move_and_slide(velocity)

	# Handle weapon firing
	if Input.is_action_pressed("LMB"): #water hose
		hose()
	if Input.is_action_pressed("RMB"): #water hose
		extinguisher()


func death():
	load_endgame("Lost")


func enemy_killed():
	var enemies_remaining = get_parent().get_node("Enemies").get_child_count()
	if enemies_remaining == 0:
		load_endgame("Won")


func hose():
	var water_instance = water.instance()
	water_instance.position = get_global_position()
	water_instance.rotation_degrees = rotation_degrees
	water_instance.apply_impulse(Vector2 (), Vector2(water_speed,0).rotated(rotation + rand_range(-1.1,1.1)))
	get_tree().get_root().call_deferred("add_child", water_instance)
	
func extinguisher():
	var ext_instance = ext.instance()
	ext_instance.position = get_global_position()
	ext_instance.rotation_degrees = rotation_degrees
	ext_instance.apply_impulse(Vector2 (), Vector2(foam_speed,0).rotated(rotation + rand_range(-1.1,1.1)))
	get_tree().get_root().call_deferred("add_child", ext_instance)


func load_endgame(status):
	var engame_instance = endgame.instance()
	engame_instance.initialize(status)
	get_tree().get_root().add_child(engame_instance)
	var _return = get_tree().change_scene_to(engame_instance)


func _on_HitBox_body_entered(_body):
	death()


# Force a refresh on a set interval to catch slow or missed updates (Only seen on the web)
func _on_RefreshTimer_timeout():
	enemy_killed()
