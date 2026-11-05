extends Node

var CardList
var CardListID
var EnemyBase

var ActiveCards: Dictionary = {}


signal AICollsionCarrier(send)
signal AITurnPassoff(Cards)
signal AICardInfoRequest(DataRequested)
signal AICardInfoPassoff(Data)

func _ready() -> void:
	SignalManager.AITurnPassoff.connect(_MainLoop)
	SignalManager.AICollsionCarrier.connect(_NewData)
	SignalManager.AICardInfoRequest.connect(_InfoRequest)
	
	for i in get_tree().get_nodes_in_group("Base"):
		if i.is_in_group("Red"):
			EnemyBase = i

func _MainLoop():
	var SelectedCards: Array = GetHighestBlueCards()
	if CardManager.CurrentPlayingTeam == "Blue":
		print("-----------------------------------------------------------------")
		print("ai cycle begin")
		#grabs top 5 cards
		SelectedCards = SelectedCards.slice(0, 5)
		SelectedCards.shuffle()
	
		#intial attacking
		for i in SelectedCards.size():
			#checks if they exist to prevent errors
			if SelectedCards.size() > i:
				SignalManager.AITurnPassoff.emit(SelectedCards[i])
			else:
				break
	if CardManager.TurnCount >= 0:
		for i in CardManager.TurnCount:
			if CardManager.TurnCount > i:
				SelectedCards.shuffle()
				SignalManager.AITurnPassoff.emit(SelectedCards.front())
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
