extends Node

var scene_transition_screen = preload("res://ui/scene_transition/loading_screen.tscn")

var scenes : Dictionary = { 
"Level1" : "res://levels/level_1.tscn", 
"Level2" : "res://levels/level_2.tscn",
#"Level3" :,
"MainMenu" : "res://ui/main_menu_screen.tscn"
}

func transition_to_scene(level : String):
	var scene_path : String = scenes.get(level)
	
	if scene_path != null:
		var scene_transition_screen_instance = scene_transition_screen.instantiate()
		get_tree().get_root().add_child(scene_transition_screen_instance)
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file(scene_path)
		scene_transition_screen_instance.queue_free()
		get_tree().reload_current_scene()

func loading_screen_only():
	var scene_transition_screen_instance = scene_transition_screen.instantiate()
	get_tree().get_root().add_child(scene_transition_screen_instance)
