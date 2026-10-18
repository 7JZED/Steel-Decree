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
	CreateCard(0, "Base", "Red", true, Vector2(200,50))
	CreateCard(0, "Base", "Blue", true, Vector2(270, 1000))
	CreateCard(10, "Num", "Blue", true, Vector2(300, 700))

func _AttackInit():
	pass

func _input(event: InputEvent) -> void:
	# gets mouse position
	if Input.is_action_just_pressed("SelectionMouse"):
		SelectedPos = get_viewport().get_mouse_position()

func CreateCard(CardNumber, Type, Team: String = "Blue", LocationOverrideEnable: bool = false, LocationOverride: Vector2 = Vector2(0, 0)):
	if Type == "Num":
		
		var CardInstance = NumCard.instantiate()
		
		# puts card at current selection
		if LocationOverrideEnable == false:
			CardInstance.position = SelectedPos
		if LocationOverrideEnable == true:
			CardInstance.position = LocationOverride

		#id
		CardInstance.CardID = IDNum
		IDNum = IDNum + 1

		#team assignment
		CardInstance.Team = Team
	
		CardInstance.CardType = CardNumber

		add_child(CardInstance)

	#UNUSED BUT KEEPING JUST INCASE
	if Type == "QuickBase":
		for i in range(2):
			var CardInstance = BaseCard.instantiate()
			#the for loop handles the id too
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
	
	if Type == "Base":
		var CardInstance = BaseCard.instantiate()
		CardInstance.Team = Team
		CardInstance.position = LocationOverride
		add_child(CardInstance)
		if Team == "Blue":
			CardInstance.CardID = 0
		if Team == "Red":
			CardInstance.CardID = 1

func _NewCard(CNum):
	if TurnCount > 1:
		SignalManager.ActionPerformed.emit("NewCard")
		CreateCard(CNum, "Num", CurrentPlayingTeam)

func _TurnPass(ActionPerformed: String):
	if ActionPerformed == "NewCard":
		TurnCount = TurnCount - 2
	if ActionPerformed == "Normal":
		TurnCount = TurnCount - 1
	
	if TurnCount <= 0:
		if CurrentPlayingTeam == "Blue":
			CurrentPlayingTeam = "Red"
			TurnCount = 7
			
		elif CurrentPlayingTeam == "Red":
			CurrentPlayingTeam = "Blue"
			TurnCount = 7
			SignalManager.AITurnPassoff.emit()
			
	print("---------------------------------------------------------------------")
	print("TURN DATA")
	print(CurrentPlayingTeam)
	print("turn number ", TurnCount)
