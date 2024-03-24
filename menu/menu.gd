class_name main_menu
extends Control

@onready var start_level = preload("res://levels/level_1.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
