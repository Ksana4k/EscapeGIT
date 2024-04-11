extends Node2D

@export var minion_node : PackedScene
@export var spawn_cd : float = 3.0

var spawning : bool

func _ready():
	spawning = true
	spawn()

func summon():
	var minion = minion_node.instantiate()
	minion.position = self.position
	get_tree().current_scene.add_child(minion)

func spawn():
	while spawning:
		summon()
		await get_tree().create_timer(spawn_cd).timeout
