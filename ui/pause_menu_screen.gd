extends CanvasLayer

var settings_menu_screen = preload("res://ui/setting_menu_screen.tscn")
var instructions_menu_screen = preload("res://ui/instructions_screen.tscn")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.continue_game()
		queue_free()

func _on_continue_button_pressed():
	GameManager.continue_game()
	queue_free()


func _on_main_menu_button_pressed():
	GameManager.restart_game()
	GameManager.main_menu()
	queue_free()


func _on_button_pressed():
	var settings_menu_screen_instance = settings_menu_screen.instantiate()
	get_tree().get_root().add_child(settings_menu_screen_instance)


func _on_restart_buttion_pressed():
	GameManager.restart_game()
	queue_free()

