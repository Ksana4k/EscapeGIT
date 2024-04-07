extends StaticBody2D

var bullet = load("res://enemies/slime/slime_bullet.tscn")
var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

@onready var collision_shape_2d = $Hurtbox/CollisionShape2D
@onready var slime = $Slime


@onready var sprite_2d = $Sprite2D
@onready var muzzle = $Muzzle
@onready var animation_player = $AnimationPlayer

@export var shooting : bool 

@export var firerate : float = 2
@export var health_amount : int = 2
@export var damage_amount : int = 1

@export var face_right : bool
var direction
var on_screeen : bool

func _ready():
	shooting = true
	shoot()
	get_direction()

func _physics_process(delta):
	if health_amount <= 0:
		die()

func _on_hurtbox_area_entered(area):
	print("hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		i_frames()
		if health_amount <= 0:
			die()

func shoot():
	while shooting:
		animation_player.play("Fire")
		
		
		await get_tree().create_timer(firerate).timeout


func get_direction():
	if face_right == true:
		sprite_2d.flip_h = true
		muzzle.position.x = -muzzle.position.x
		direction = 1
	elif face_right == false:
		direction = -1

func release_bullet():
	if on_screeen == true:
		slime.play()
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)

func take_damage():
	pass

func die():
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()

func i_frames():
	collision_shape_2d.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	if health_amount <= 0:
		return
	collision_shape_2d.set_deferred("disabled", false)


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screeen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screeen = false
