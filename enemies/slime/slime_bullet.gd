extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var slime_bullet = $SlimeBullet

@export var speed : int = 600
var direction
var damage_amount : int = 1
var move_x_direction : bool
var lifetime : float = 2.0
var hit : bool = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	if direction > 0:
		slime_bullet.flip_h = true
	position.x += abs(speed * delta) * direction

func bullet_impact():
	hit = true
	speed = 0
	animation_player.play("Hit")


func _on_area_2d_body_entered(body):
	#print("hit")
	bullet_impact()
	
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		bullet_impact()
