extends CharacterBody2D

@onready var bark = $Bark

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

@export var health_amount : int = 3
@export var damage_amount : int = 1

func _physics_process(delta):
	if health_amount <= 0:
		die()

func _on_hurtbox_area_entered(area : Area2D):
	print("hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		
		if health_amount <= 0:
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = global_position
			get_parent().add_child(enemy_death_effect_instance)
			queue_free()

func die():
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		bark.play()
