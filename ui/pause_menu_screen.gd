extends CanvasLayer

var settings_menu_screen = preload("res://ui/ingame_settings_menu_screen.tscn")

func _on_continue_button_pressed():
	GameManager.continue_game()
	queue_free()


func _on_main_menu_button_pressed():
	GameManager.main_menu()
	queue_free()


func _on_button_pressed():
	var settings_menu_screen_instance = settings_menu_screen.instantiate()
	get_tree().get_root().add_child(settings_menu_screen_instance)
