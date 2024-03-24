extends CharacterBody2D

var bullet = preload("res://player/bullet.tscn")
var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
@onready var crosshair = $Crosshair
@onready var crosshair_timer = $CrosshairTimer

const GRAVITY : int = 1000
@export var speed : int = 1000
@export var maximum_horizontal_speed : int = 300
@export var slow_down_speed : int = 4000

@export var jump : int = -300
@export var jump_horizontal_speed : int = 1000
@export var max_jump_horizontal_speed : int = 300
@export var jump_count : int = 1

enum  State { Idle, Run, Jump, Fall, DoubleJump, Shoot, Shoot_stand}

var current_state : State
var muzzle_position : Vector2
var crosshair_position
var current_jump_count : int

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position
	crosshair_position = crosshair.position
	crosshair.visible = false

func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position()
	shoot_stand(delta)
	player_shooting(delta)
	crosshair_visibility()
	
	move_and_slide()
	
	player_animations()
	#print("State: ", State.keys()[current_state])

func _input(event : InputEvent):
	if(event.is_action_pressed("down")) && is_on_floor():
		position.y += 1

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta : float):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta : float):
	if !is_on_floor():
		return
	
	var direction = input_movement()
	
	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, - maximum_horizontal_speed, maximum_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true 

func player_jump(delta : float):
	var jump_input : bool = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and jump_input:
		current_jump_count = 0
		velocity.y = jump
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and jump_input and current_jump_count < jump_count:
		velocity.y = jump
		current_jump_count += 1
		current_state = State.DoubleJump
		
	
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, - max_jump_horizontal_speed, max_jump_horizontal_speed)

func shoot_stand(delta : float):
	var direction : float = -1 if animated_sprite_2d.flip_h == true else 1
	
	if Input.is_action_just_pressed("shoot") && current_state == State.Idle:
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot_stand

func player_shooting(delta : float):
	var direction = input_movement()
	
	if direction != 0  and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot

func player_muzzle_position():
	var direction = input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
		crosshair.position.x = crosshair_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x
		crosshair.position.x = -crosshair_position.x

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif velocity.y >= 1 :
		animated_sprite_2d.play("fall")
	elif current_state == State.Run and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.DoubleJump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("run_shoot")
	

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	
	GameManager.game_over()
	
	queue_free()

func crosshair_visibility():
	if Input.is_action_just_pressed("shoot"):
		crosshair.visible = true
		crosshair_timer.start()

func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	
	return direction

func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy Entered ", body.damage_amount)
		
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		HealthManager.decrease_health(body.damage_amount)
	
	if HealthManager.current_health == 0:
		player_death()

func _on_crosshair_timer_timeout():
	crosshair.visible = false
