extends Node

var CardList
var CardListID

var ActiveCards: Dictionary = {}


signal AICollsionCarrier(send)
signal AITurnPassoff

func _ready() -> void:
	SignalManager.AITurnPassoff.connect(_Turn_Begin)
	SignalManager.AICollsionCarrier.connect(_NewData)

func _Turn_Begin():
	pass
	


func _NewData(send):
	var IDTemp = send.CardID
	ActiveCards[str(IDTemp) + "NEARBY"] = send
	


# RE USABLE FUNCS --------------------------------------------------------------
