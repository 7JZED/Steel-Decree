extends Node2D

@onready var TeamLabel = $Sprite2D/Area2D/Label

var AttackMode
var CardID
var Team
var CardHealth = 50

signal AttackInit
signal Selection
var ReceivingID: int

func _ready() -> void:
	Selection.connect(_on_area_2d_selection)
	SignalManager.AttackInit.connect(_Attack)
	if Team == "Blue":
		TeamLabel.text = "B"
	if Team == "Red":
		TeamLabel.text = "R"

func _process(delta: float) -> void:
	#card despawner
	if CardHealth <= 0:
		print(CardHealth)
		queue_free()

func _Attack():
	AttackMode = true
	var ReceivingID = await SignalManager.TargetSelect
	if ReceivingID == CardID and CardManager.AttackingTeam != Team:
		CardHealth = CardHealth - CardManager.AttackingNum
	AttackMode = false


func _on_area_2d_selection() -> void:
	if AttackMode == true:
		SignalManager.TargetSelect.emit(CardID)
