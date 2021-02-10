extends Control

func initialize(status):
	if status == "Won":
		$VBoxContainer/Label.text = "Be cool about fire safety!"
	else:
		$VBoxContainer/Label.text = "Smoke Jumper Hero"


func _on_Button_pressed():
	var _return = get_tree().change_scene("res://World.tscn")
	queue_free()
