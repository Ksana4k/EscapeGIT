extends CanvasLayer

@onready var label = $MarginContainer/VBoxContainer/Label

func _ready():
	ClueManager.on_clue_changed.connect(on_clue_received)

func on_clue_received(current_clue : int):
	label.text = str(current_clue, "/4")
