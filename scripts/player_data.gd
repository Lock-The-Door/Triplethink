extends Node

var chocolate := 0

func give_chocolate(count: int):
	chocolate += count
	print("Player now has ", count, " chocolate")
