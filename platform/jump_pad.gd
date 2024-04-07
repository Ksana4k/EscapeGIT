extends Node2D

@export var force : int = -1000

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.velocity.y = force
