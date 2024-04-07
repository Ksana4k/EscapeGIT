extends Node

var current_clue : int

signal on_clue_changed

func decrease_clue(clue_amount : int):
	current_clue -= clue_amount
	
	if current_clue < 0:
		current_clue = 0
	
	print("decrease clue called " , current_clue)
	on_clue_changed.emit(current_clue)

func increase_clue(clue_amount : int):
	current_clue += clue_amount
	
	if current_clue < 0:
		current_clue = 0
	
	print("increase clue called " , current_clue)
	on_clue_changed.emit(current_clue)
