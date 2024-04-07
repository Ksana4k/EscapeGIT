extends Node2D

@export var damage_amount : int = 2

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $BiteArea2D/CollisionShape2D

func _on_bite_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		animated_sprite_2d.play("bite")
		HealthManager.decrease_health(damage_amount)
		collision_shape_2d.set_deferred("disabled", true)
		
		if HealthManager.current_health > 0:
			body.freeze()
			body.player_take_damage_effect()
			await get_tree().create_timer(1.0).timeout
			if HealthManager.current_health > 0:
				body.unfreeze()
			queue_free()
		
		
		await get_tree().create_timer(1.0).timeout
		queue_free()
