extends Boss_State

var can_transition: bool = false
 
func enter():
	super.enter()
	animation_player.play("skill")
	await animation_player.animation_finished
	can_transition = true
 
 
func teleport():
	if player == null:
		return
	
	var chance = randi() % 2
	match chance:
		0:
			owner.position = player.position + Vector2.RIGHT * 40
		1:
			owner.position = player.position + Vector2.LEFT * 40
 
 
func transition():
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
