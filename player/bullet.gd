extends AnimatedSprite2D

var bullet_impact_effect = preload("res://player/bullet_impact_effect.tscn")
@onready var collision_shape_2d = $Hitbox/CollisionShape2D

var speed : int = 600
var direction : int
var damage_amount : int = 1
var move_x_direction : bool

func _physics_process(delta):
	if move_x_direction:
		move_local_x(direction * speed * delta)
	else:
		move_local_y(direction * speed * delta)


func _on_timer_timeout():
	queue_free()

func get_damage_amount() -> int:
	return damage_amount

func bullet_impact():
	collision_shape_2d.set_deferred("disabled", true)
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()


func _on_hitbox_area_entered(area):
	print("bullet area entered")
	bullet_impact()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Boss"):
		print("boss")
		body.take_damage()
		bullet_impact()
	
	print("bullet body entered")
	
	bullet_impact()
