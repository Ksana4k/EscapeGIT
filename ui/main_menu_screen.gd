extends CanvasLayer

var settings_menu_screen = preload("res://ui/setting_menu_screen.tscn")
var instructions_menu_screen = preload("res://ui/instructions_screen.tscn")


func _on_play_button_pressed():
	GameManager.start_game()
	queue_free()


func _on_exit_button_pressed():
	GameManager.exit_game()


func _on_settings_buttion_pressed():
	var settings_menu_screen_instance = settings_menu_screen.instantiate()
	get_tree().get_root().add_child(settings_menu_screen_instance)


func _on_instruction_button_pressed():
	var instructions_menu_screen_instance = instructions_menu_screen.instantiate()
	get_tree().get_root().add_child(instructions_menu_screen_instance)


