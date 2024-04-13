extends Node

var main_menu_screen = preload("res://ui/main_menu_screen.tscn")
var pause_menu_screen = preload("res://ui/pause_menu_screen.tscn")
var game_over_screen = preload("res://ui/game_over_screen.tscn")
var level_1 = preload("res://levels/level_1.tscn")
var logo_screen = preload("res://ui/logo/logo_screen.tscn")

func _ready():
	SettingsManager.load_settings()

func start_game():
	if get_tree().paused:
		continue_game()
		return
	
	SceneManager.transition_to_scene("Level1")
	full_heal_player()

func logo_instance():
	var logo_instance = logo_screen.instantiate()
	get_tree().get_root().add_child(logo_instance)

func exit_game():
	get_tree().quit()

func pause_game():
	get_tree().paused = true
	
	var pause_menu_screen_instance = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instance)

func restart_game():
	continue_game()
	get_tree().reload_current_scene()
	full_heal_player()
	ClueManager.current_clue = 0

func main_menu():
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instance)

func game_over():
	var game_over_screen_instance = game_over_screen.instantiate()
	get_tree().get_root().add_child(game_over_screen_instance)

func full_heal_player():
	HealthManager.increase_health(3)

func continue_game():
	get_tree().paused = false
