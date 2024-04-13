extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("start")
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://ui/main_menu_screen.tscn")
