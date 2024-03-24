extends Node
const GRAVITY : float = 300.0

signal gained_clues(int)

var current_checkpoint : checkpoint

var player : PlayerEntity

#coins
var clues : int

func apply_gravity(entity : CharacterBody2D, delta : float) -> void:
	entity.velocity.y += GRAVITY * delta

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_clues(clues_gained : int):
	clues += clues_gained
	emit_signal("gained_clues", clues_gained)
