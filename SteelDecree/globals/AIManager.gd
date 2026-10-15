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


## not usebale at the moment (maybe)
func _NewData(send):
	var IDTemp = send.CardID
	if send.size() >= 1:
		ActiveCards[str(IDTemp) + " NEARBY"] = send
		print("---------------------------------------------------------------------")
		print("NEW AI COLLISION DATA")
		print(JSON.stringify(ActiveCards, "\t"))
	else:
		ActiveCards[str(IDTemp) + " NEARBY"] = {}
		IDTemp = send.CardID
		print("---------------------------------------------------------------------")
		print("NEW AI COLLISION DATA")
		print(JSON.stringify(ActiveCards, "\t"))



# RE USABLE FUNCS --------------------------------------------------------------
