extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animation = $AnimatedSprite2D
@onready var collision_shape_2d = $DamageArea/CollisionShape2D
@onready var spawn_sound = $SpawnSound

@export var speed : int = 60
@export var damage_amount : int = 1

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
	
 
func _physics_process(_delta):
	if player == null:
		return
	
	var direction = player.position - position
	velocity = direction.normalized() * speed
	move_and_slide()
 
func take_damage():
	death()

func death():
	collision_shape_2d.set_deferred("disabled", true)
	set_physics_process(false)
	animation.play("death")
	await animation.animation_finished
	queue_free()


func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		death()


func _on_timer_timeout():
	death()
