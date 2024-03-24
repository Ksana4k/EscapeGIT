extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var key_id : String

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		InventoryManager.add_to_inventory("Key1", key_id)
		queue_free()


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("Player"):
		animated_sprite_2d.play("open")


func _on_detection_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		animated_sprite_2d.play("close")
