extends CanvasLayer


func _on_retry_button_pressed():
	GameManager.restart_game()
	queue_free()


func _on_main_menu_button_pressed():
	GameManager.restart_game()
	GameManager.main_menu()
	queue_free()
