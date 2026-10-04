extends Node2D

@onready var TypeLabel = $Sprite2D/Label

#given when card is made
var CardID: int 
var CardType
var CardHealth
var Team

#AI
signal AICollsionCarrier(send)
var ActiveCards:Dictionary = {}

# inter card cordination
signal ActionPerformed

#selection
var Selected: bool = false
signal NewSelection

#movement
signal MoveInit
var PointDistance
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
	
	
	add_to_group(str(CardHealth))
	add_to_group(Team)
	
	SignalManager.NewSelection.connect(NewSelect)
	SignalManager.MoveInit.connect(_Move)
	SignalManager.AttackInit.connect(_Attack)
	SignalManager.ActionPerformed.connect(Action)
	
	print("new card id ", CardID,)
	print("team ", Team)
	
	#starts as red so this only needs to run on blue
	if Team == "Blue":
		$TeamMarker.texture = load("res://assets/MarkerB.svg")
	$CardSelectionMarker.visible = false

func _process(_delta: float) -> void:
	
	#marker pos
	$CardSelectionMarker.global_position = position + Vector2(36, -20)
	$TeamMarker.global_position = position + Vector2(36, 60)
	PointDistance = position.distance_to(SelectedCords)
	
	#card despawner
	if CardHealth <= 0:
		queue_free()

func _unhandled_input(event: InputEvent) -> void:
	# selects cords
	if Input.is_action_just_pressed("SelectionMouse"):
		SelectedCords = get_viewport().get_mouse_position()

func _Attack():
	AttackMode = true

	#attacker
	if Selected == true:
		CardManager.AttackingNum = CardHealth
		CardManager.AttackingTeam = Team
		await SignalManager.TargetSelect
		AttackMode = false
		
	#receiver
	if Selected == false:
		var ReceivingID = await SignalManager.TargetSelect
		if ReceivingID == CardID and CardManager.AttackingTeam != Team and PointDistance <= 200:
			CardHealth = CardHealth - CardManager.AttackingNum
			
		AttackMode = false
		add_to_group(str(CardHealth))

func _Move():
	if Selected == true and PointDistance < 150 and Team == CardManager.CurrentPlayingTeam:
		position = SelectedCords
		SignalManager.ActionPerformed.emit()

#selection detection(rhyme not intended)
func _on_area_2d_selection() -> void:
	if AttackMode == false and Team == CardManager.CurrentPlayingTeam:
		SignalManager.NewSelection.emit()
		print(CardID, " selected")
		Selected = true
		$CardSelectionMarker.visible = true
	if AttackMode == true:
		SignalManager.TargetSelect.emit(CardID)

func NewSelect():
	if AttackMode == false:
		Selected = false
		$CardSelectionMarker.visible = false

func Action():
	if CardManager.CurrentPlayingTeam != Team:
		NewSelection.emit()



## AI ONLY ----------------------------------------
