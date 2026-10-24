extends Node2D

@onready var TypeLabel = $Sprite2D/Label

#given when card is made
var CardID: int 
var CardType
var CardHealth
var Team

#AI
signal AICollsionCarrier(send) # prolly useless
var ActiveCards:Dictionary = {}
signal AITurnPassoff

# inter card cordination
signal ActionPerformed

#selection
var Selected
signal NewSelection

#movement
signal MoveInit
var PointDistance = 0
var SelectedCords = Vector2(0,0)

#attack
signal AttackInit
signal TargetSelect(ID)
var AttackMode: bool = false


func _ready() -> void:
	
	#sets the card health etc to the card type
	TypeLabel.text = str(CardType)
	CardHealth = CardType
	$"Sprite2D/ID label".text = str(CardID)
	
	#add to groups for ai
	add_to_group(str(CardHealth))
	add_to_group(Team)
	
	# connecting all funcs
	SignalManager.NewSelection.connect(NewSelect)
	SignalManager.MoveInit.connect(_Move)
	SignalManager.AttackInit.connect(Attack)
	SignalManager.ActionPerformed.connect(Action)
	SignalManager.AITurnPassoff.connect(AIMain)
	#telemtry
	print("---------------------------------------------------------------------")
	print("NEW CARD DATA")
	print("new card id ", CardID,)
	print("team ", Team)
	
	#starts as red so this only needs to run on blue
	if Team == "Blue":
		$TeamMarker.texture = load("res://assets/MarkerB.svg")
	$CardSelectionMarker.visible = false

func _process(_delta: float) -> void:
	
	#marker pos
	$CardSelectionMarker.global_position = position + Vector2(0, -50)
	$TeamMarker.global_position = position + Vector2(0, 37)
	PointDistance =  SelectedCords.distance_to(global_position)
	
	#card despawner
	if CardHealth <= 0:
		queue_free()
	if CardManager.CurrentSelectedCard == self and PointDistance < 150:
		$MovementPotentialIndicator.set_point_position(1, $MovementPotentialIndicator.to_local(SelectedCords))

func _unhandled_input(event: InputEvent) -> void:
	# selects cords
	if Input.is_action_just_pressed("SelectionMouse"):
		SelectedCords = get_global_mouse_position()
	
	if PointDistance < 150:
		$MovementPotentialIndicator.visible = true
	if CardManager.CurrentSelectedCard != self or PointDistance > 150:
		$MovementPotentialIndicator.visible = false
	if CardManager.CurrentSelectedCard == self:
		$MovementPotentialIndicator.set_point_position(1, $MovementPotentialIndicator.to_local(SelectedCords))

func Attack(IDOverride: int = -1):
	AttackMode = true
	#attacker
	if CardManager.CurrentSelectedCard == self:
		print("poo1")
		CardManager.AttackingNum = CardHealth
		CardManager.AttackingTeam = Team
		if IDOverride == -1:
			await SignalManager.TargetSelect
		print("poo2")
		AttackMode = false
		SignalManager.ActionPerformed.emit("Normal")
		
	#receiver
	else:
		var ReceivingID
		print("poopen")
		if IDOverride == -1:
			print('butt1')
			ReceivingID = IDOverride
		else:
			print('butt2')
			ReceivingID = await SignalManager.TargetSelect
		if ReceivingID == CardID and CardManager.AttackingTeam != Team and PointDistance <= 200 or IDOverride == -1:
			print('butt3')
			CardHealth = CardHealth - CardManager.AttackingNum
			$Sprite2D/Label.text = str(CardHealth)
		print("butt4")
		AttackMode = false
		add_to_group(str(CardHealth))

func _Move():
	if CardManager.CurrentSelectedCard == self and PointDistance < 150 and Team == CardManager.CurrentPlayingTeam:
		global_position = SelectedCords
		SignalManager.ActionPerformed.emit("Normal")

#selection detection(rhyme not intended)
func _on_area_2d_selection() -> void:
	#normal selection
	if AttackMode == false and Team == CardManager.CurrentPlayingTeam:
		SignalManager.NewSelection.emit()
		CardManager.CurrentSelectedCard = self
		$CardSelectionMarker.visible = true
	#attack selection
	if AttackMode == true:
		SignalManager.TargetSelect.emit(CardID)

func NewSelect():
	if AttackMode == false:
		$CardSelectionMarker.visible = false

func Action():
	if CardManager.CurrentPlayingTeam != Team:
		NewSelection.emit()



## AI ONLY ----------------------------------------
func AIMain(SelectedCards):
	if SelectedCards == self:
		var Attackable = FindCloseCards()
		print(str(CardID) + str(Attackable))
		CardManager.CurrentSelectedCard = self
		Attackable.shuffle()
		Attack(Attackable[0].CardID)
		SignalManager.AttackInit.emit()

#finds nearby cards within threshold
func FindCloseCards(Threshold: int = 200):
	var AllCards = get_tree().get_nodes_in_group("Red")
	var NearCards: Array = []
	for Cards in AllCards:
		var Distance = global_position.distance_to(Cards.global_position)
		if Distance < Threshold:
			NearCards.append(Cards)
	return NearCards
