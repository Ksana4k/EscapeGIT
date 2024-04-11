extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.continue_game()
		queue_free()



func _on_button_pressed():
	GameManager.continue_game()
	queue_free()
