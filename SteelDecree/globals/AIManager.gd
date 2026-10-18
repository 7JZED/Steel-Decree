extends Node

var CardList
var CardListID

var ActiveCards: Dictionary = {}


signal AICollsionCarrier(send)
signal AITurnPassoff(Cards)
signal AICardInfoRequest(DataRequested)
signal AICardInfoPassoff(Data)

func _ready() -> void:
	SignalManager.AITurnPassoff.connect(_Turn_Begin)
	SignalManager.AICollsionCarrier.connect(_NewData)
	SignalManager.AICardInfoRequest.connect(_InfoRequest)
func _Turn_Begin():
	if CardManager.CurrentPlayingTeam == "Blue":
		#grabs top cards
		var SelectedCards: Array = GetHighestBlueCards()
		SelectedCards.shuffle()
		SelectedCards = SelectedCards.slice(0, 5)
		print("SEARCH ME" + str(SelectedCards))
		for i in SelectedCards.size():
			#checks if they exist to prevent errorss
			if SelectedCards.size() > i:
				SignalManager.AITurnPassoff.emit(SelectedCards[i])
			else:
				break

## not usebale at the moment (maybe)
func _NewData(send):
	var IDTemp = send.CardID
	if send.size() >= 1:
		ActiveCards[str(IDTemp) + " NEARBY"] = send
		#print("---------------------------------------------------------------------")
		#print("NEW AI COLLISION DATA")
		#print(JSON.stringify(ActiveCards, "\t"))
	else:
		ActiveCards[str(IDTemp) + " NEARBY"] = {}
		IDTemp = send.CardID
		#print("---------------------------------------------------------------------")
		#print("NEW AI COLLISION DATA")
		#print(JSON.stringify(ActiveCards, "\t"))

@warning_ignore("unused_parameter")
func _InfoRequest(DataRequested):
	if DataRequested == "RedHighest":
		AICardInfoPassoff.emit(GetHighestRedCards)

# RE USABLE FUNCS --------------------------------------------------------------
func GetHighestRedCards():
	var Nodes = get_tree().get_nodes_in_group("Red")
	var PrevHighH = -1
	var PrevHighNodes = []
	for node in Nodes:
		if node.get("CardHealth") > PrevHighH:
			PrevHighNodes = [node]
			PrevHighH = node.get("CardHealth")
		elif node.get("CardHealth") == PrevHighH:
			PrevHighNodes.append(node)
	return PrevHighNodes

func GetHighestBlueCards():
	var Nodes = get_tree().get_nodes_in_group("Blue")
	var PrevHighH = -1
	var PrevHighNodes = []
	for node in Nodes:
		if node.get("CardHealth") > PrevHighH:
			PrevHighNodes = [node]
			PrevHighH = node.get("CardHealth")
		elif node.get("CardHealth") == PrevHighH:
			PrevHighNodes.append(node)
	return PrevHighNodes
