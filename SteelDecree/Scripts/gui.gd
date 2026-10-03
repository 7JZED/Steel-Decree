extends Control

@onready var TurnCounter = $TurnCounter


signal NewCard(CNum)
signal AttackInit
signal MoveInit
signal RedEnable
signal BlueEnable
signal ActionPerformed

func _ready() -> void:
	SignalManager.ActionPerformed.connect(_TurnPass)

func _on_num_1_pressed() -> void:
	SignalManager.NewCard.emit(1)

func _on_num_2_pressed() -> void:
	SignalManager.NewCard.emit(2)

func _on_num_3_pressed() -> void:
	SignalManager.NewCard.emit(3)

func _on_num_4_pressed() -> void:
	SignalManager.NewCard.emit(4)

func _on_num_5_pressed() -> void:
	SignalManager.NewCard.emit(5)

func _on_num_6_pressed() -> void:
	SignalManager.NewCard.emit(6)

func _on_num_7_pressed() -> void:
	SignalManager.NewCard.emit(7)

func _on_num_8_pressed() -> void:
	SignalManager.NewCard.emit(8)

func _on_num_9_pressed() -> void:
	SignalManager.NewCard.emit(9)

func _on_num_10_pressed() -> void:
	SignalManager.NewCard.emit(10)

func _on_move_pressed() -> void:
	SignalManager.MoveInit.emit()

func _on_attack_pressed() -> void:
	SignalManager.AttackInit.emit()

func _TurnPass() -> void:
	TurnCounter.text = "Turns Left:" +str(CardManager.TurnCount)
	print("detected")
	
