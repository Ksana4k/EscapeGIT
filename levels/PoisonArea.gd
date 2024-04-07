extends Node2D

@onready var collision_shape_2d = $PoisonArea2D/CollisionShape2D
@onready var collision_shape_2d2 = $PoisonArea2D2/CollisionShape2D

@export var damage_amount : int = 1

func _on_poison_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		collision_shape_2d.set_deferred("disabled",true)
		await get_tree().create_timer(1.0).timeout
		collision_shape_2d.set_deferred("disabled",false)


func _on_poison_area_2d_2_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		collision_shape_2d2.set_deferred("disabled",true)
		await get_tree().create_timer(1.0).timeout
		collision_shape_2d2.set_deferred("disabled",false)
