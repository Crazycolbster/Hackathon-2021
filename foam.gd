extends RigidBody2D

# Bullet parameters
export var SPEED = 20
export var DESPAWN = .5

onready var animation = $AnimationPlayer
onready var timer = $DespawnTimer

func initialize(new_position, new_rotation):
	position = new_position
	rotation_degrees = new_rotation


func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(3)
	apply_impulse(Vector2(), Vector2(SPEED,0).rotated(rotation))


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_foam_body_entered(_body):
	timer.start(DESPAWN)
	animation.play("FadeOut")
	


func _on_DespawnTimer_timeout():
	queue_free()


func _on_despawn_timer_timeout():
	queue_free()
