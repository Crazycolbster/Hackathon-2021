extends KinematicBody2D

# Enemy movement
export var acceleration = 30
export var distance_check = 5
export var speed = 100

var HP = 50 #50 strikes from water


onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var path_timer = $PathingTimer

var explosion = preload("res://Entities/Explosion.tscn")
var path #A list that holds... something?
var velocity = Vector2.ZERO


func _ready():
	randomize()
	path_timer.start(randf())


func _physics_process(delta):
	if HP >= 1000:
		HP += 0 #AKA, do nothing
	else:
		HP += 1 #Fire grows when left unchecked
	if not path:
		return

	var distance_to_destination = position.distance_to(path[0])
	if HP <= 0:
		if distance_to_destination > distance_check:
			pass
			#look_at(path[0]) # Works for zombies, if fire actually looks at you, you're either dreaming, or posessed.
			#position = position.linear_interpolate(path[0], (speed * delta) / distance_to_destination)
			#var _motion = move_and_slide(Vector2.ZERO) #Fire will book a flight to find you and kill you
		else:
			path.remove(0)



func _on_HitBox_body_entered(_body):
	HP -= 40
	if HP <= 0:
		var explosion_instance = explosion.instance()
		explosion_instance.position = global_position
		explosion_instance.emitting = true
		get_tree().get_root().find_node("Effects", true, false).add_child(explosion_instance)
		queue_free()


func _on_PathingTimer_timeout():
	path_timer.start(randf())
	make_path()


func make_path():
	var player = get_tree().get_root().find_node("Player", true, false)
	path = navigation.get_simple_path(position, player.position, false)
