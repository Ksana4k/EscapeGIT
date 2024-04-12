extends CharacterBody2D

var bullet = preload("res://player/bullet.tscn")
var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@onready var hurtbox_collision_shape_2d = $Hurtbox/HurtboxCollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
@onready var crosshair = $Crosshair
@onready var crosshair_timer = $CrosshairTimer
@onready var gun_shot = $GunShot
@onready var jump_sound = $JumpSound


const GRAVITY : int = 1000
@export var speed : int = 800
@export var maximum_horizontal_speed : int = 280
@export var slow_down_speed : int = 9000

@export var jump : int = -320
@export var jump_horizontal_speed : int = 500
@export var max_jump_horizontal_speed : int = 250
@export var jump_count : int = 1

@export var shoot_cd : float = 1.0
@export var hold_gun_time : float = 1.0

enum  State { Idle, Run, Jump, Fall, Shoot, Shoot_stand}

var current_state : State
var muzzle_position : Vector2
var crosshair_position
var current_jump_count : int

var can_move : bool
var can_shoot : bool

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position
	crosshair_position = crosshair.position
	crosshair.visible = false
	can_move = true
	can_shoot = true

func _process(delta):
	if HealthManager.current_health <= 0:
		player_death()

func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position()
	shoot_stand(delta)
	shoot_up(delta)
	player_shooting(delta)
	crosshair_visibility()
	
	move_and_slide()
	
	player_animations()
	#print("State: ", State.keys()[current_state], )

func _input(event : InputEvent):
	if !can_move:
		return
	
	if(event.is_action_pressed("down")) && is_on_floor():
		position.y += 1
		#for one way
		#current_state = State.Jump

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	if !is_on_floor() && current_state == State.Idle:
		current_state = State.Jump
	
	if !is_on_floor() && current_state == State.Run:
		current_state = State.Jump

func player_idle(delta : float):
	if is_on_floor() && !current_state == State.Shoot_stand:
		current_state = State.Idle

func player_run(delta : float):
	if !can_move:
		return
	
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
	if !can_move:
		return
	
	var jump_input : bool = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and jump_input:
		jump_sound.play()
		current_jump_count = 0
		velocity.y = jump
		current_jump_count += 1
		current_state = State.Jump
		
	if !is_on_floor() and jump_input and current_jump_count < jump_count:
		jump_sound.play()
		velocity.y = jump
		current_jump_count += 1
		current_state = State.Jump
	
	if !is_on_floor() and current_state == State.Jump:
		
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, - max_jump_horizontal_speed, max_jump_horizontal_speed)

func shoot_stand(delta : float):
	if !can_shoot:
		return
	
	var direction : float = -1 if animated_sprite_2d.flip_h == true else 1
	
	if Input.is_action_just_pressed("shoot") && current_state == State.Idle:
		gun_shot.play()
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot_stand
		shoot_cd_start()
		get_tree().create_timer(hold_gun_time).timeout.connect(on_hold_gun_timeout)
	
	
	
	if Input.is_action_just_pressed("shoot") && current_state == State.Jump :
		gun_shot.play()
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		shoot_cd_start()

func shoot_up(delta : float):
	if !can_shoot:
		return
	
	var direction : float = -1 if animated_sprite_2d.flip_h == true else 1
	
	if Input.is_action_just_pressed("up"):
		gun_shot.play()
		muzzle_position = Vector2(0,-38)
		muzzle_position = muzzle.position
		
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = -1
		bullet_instance.move_x_direction = false
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		shoot_cd_start()
	

func player_shooting(delta : float):
	if !can_shoot:
		return
	
	var direction = input_movement()
	
	if direction != 0  and Input.is_action_just_pressed("shoot"):
		gun_shot.play()
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot
		shoot_cd_start()

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
	elif current_state == State.Shoot:
		animated_sprite_2d.play("shoot_run")
	elif current_state == State.Shoot_stand:
		animated_sprite_2d.play("shoot_stand")
	

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
		i_frames()
		print("Enemy Entered ", body.damage_amount)
		
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		HealthManager.decrease_health(body.damage_amount)
	
	if HealthManager.current_health == 0:
		player_death()

func _on_crosshair_timer_timeout():
	crosshair.visible = false

func i_frames():
	hurtbox_collision_shape_2d.set_deferred("disabled", true)
	await get_tree().create_timer(1.0).timeout
	hurtbox_collision_shape_2d.set_deferred("disabled", false)

func freeze():
	velocity.x = 0
	velocity.x = 0
	can_move = false

func unfreeze():
	can_move = true

func player_hurt_effect():
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
	tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)

func player_take_damage_effect():
	i_frames()
	player_hurt_effect()

func on_hold_gun_timeout():
	current_state = State.Idle

func shoot_cd_start():
	can_shoot = false
	await get_tree().create_timer(shoot_cd).timeout
	can_shoot = true


func test_shoot_stand():
	var direction : float = -1 if animated_sprite_2d.flip_h == true else 1
	if Input.is_action_just_pressed("shoot") && current_state == State.Shoot_stand:
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.move_x_direction = true
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot_stand
		shoot_cd_start()
		get_tree().create_timer(hold_gun_time).timeout.connect(on_hold_gun_timeout)
