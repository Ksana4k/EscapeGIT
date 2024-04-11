extends CharacterBody2D

@export var damage_amount : int = 1
@export var speed : int = 40

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var attack_area = $AttackArea
@onready var damage_area = $DamageArea

var direction : Vector2

var health: = 15:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			damage_area.monitoring = false
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			ClueManager.increase_clue(1)

func _ready():
	attack_area.monitoring = false
	set_physics_process(false)

func _process(_delta):
	if player == null:
		return
	
	direction = player.position - position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
		attack_area.scale.x = -1
	else:
		animated_sprite.flip_h = false
		attack_area.scale.x = 1

func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)

func take_damage():
	health -= 1

func hit():
	attack_area.monitoring = true
	await get_tree().create_timer(1).timeout
	end_of_hit()

func end_of_hit():
	attack_area.monitoring = false


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		body.player_take_damage_effect()
		print("player hit")

func _on_damage_area_area_entered(area):
	if area.is_in_group("Player"):
		HealthManager.decrease_health(damage_amount)
		area.player_take_damage_effect()
		print("player hit")
