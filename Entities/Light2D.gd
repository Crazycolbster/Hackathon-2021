extends Light2D
var rng = RandomNumberGenerator.new()#Allows random numbers

func _physics_process(delta):
	rng.randomize()#Random seed for each fire
	var flicker = rng.randi_range(0,10)#Random check to have fire flicker
	if flicker == 10:
		energy = rng.randf()#Random brightness level when flickering


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
