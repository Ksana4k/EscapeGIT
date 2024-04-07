extends Node2D

@onready var collision_polygon_2d = $Area2D/CollisionPolygon2D

@export var damage_amount : int = 1


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		collision_polygon_2d.set_deferred("disabled",true)
		await get_tree().create_timer(1.0).timeout
		collision_polygon_2d.set_deferred("disabled",false)

