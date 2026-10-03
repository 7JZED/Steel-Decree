extends Node

const  NumCard = preload("uid://jhdwwwy2q1v4")
const  BaseCard = preload("uid://bhvrbhdi88vgb")

var IDNum = 2
var SelectedPos: Vector2 = Vector2(300, 300)
var TurnCount: int =  7
var CurrentPlayingTeam = "Red"

var AttackingNum
var AttackingTeam

signal ActionPerformed
signal AITurnPassoff
signal AttackInit

func _ready() -> void:
	SignalManager.NewCard.connect(_NewCard)
	SignalManager.ActionPerformed.connect(_TurnPass)
	SignalManager.AttackInit.connect(_AttackInit)
	CreateCard(0, "Base")


func _AttackInit():
	pass

func _input(event: InputEvent) -> void:
	# gets mouse position
	if Input.is_action_just_pressed("SelectionMouse"):
		SelectedPos = get_viewport().get_mouse_position()

func CreateCard(CardNumber, Type):
	if Type == "Num":
		# puts card at current selection
		var CardInstance = NumCard.instantiate()
		CardInstance.position = SelectedPos

		#id
		CardInstance.CardID = IDNum
		IDNum = IDNum + 1

		#team assignment
		CardInstance.Team = CurrentPlayingTeam
	
		CardInstance.CardType = CardNumber

		add_child(CardInstance)

	if Type == "Base":
		for i in range(2):
			var CardInstance = BaseCard.instantiate()
			if i == 0:
				CardInstance.CardID = i
				CardInstance.Team = "Blue"
				CardInstance.position = Vector2(200,50)
				add_child(CardInstance)
			if i == 1:
				CardInstance.CardID = i
				CardInstance.Team = "Red"
				CardInstance.position = Vector2(270, 1000)
				add_child(CardInstance)

func _NewCard(CNum):
	CreateCard(CNum, "Num")
	SignalManager.ActionPerformed.emit()

func _TurnPass():
	TurnCount = TurnCount - 1
	print("turn number ", TurnCount)
	print(CurrentPlayingTeam)
	if TurnCount == 0:
		if CurrentPlayingTeam == "Blue":
			CurrentPlayingTeam = "Red"
			TurnCount = 7
			return
		if CurrentPlayingTeam == "Red":
			CurrentPlayingTeam = "Blue"
			TurnCount = 7
			AITurnPassoff.emit()
			return
