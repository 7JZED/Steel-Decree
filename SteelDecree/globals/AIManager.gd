extends Node

signal AITurnPassoff

func _ready() -> void:
	SignalManager.AITurnPassoff.connect(_Turn_Begin)

func _Turn_Begin():
	pass
