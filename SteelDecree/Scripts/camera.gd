extends Camera2D


var MoveSpeed = 3.0



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	#camera movement
	if Input.is_action_pressed("NumDown"):
		position = Vector2(0, MoveSpeed) + position
	if Input.is_action_pressed("NumUp"):
		position = Vector2(0, -MoveSpeed) + position
	if Input.is_action_pressed("NumLeft"):
		position = Vector2(-MoveSpeed, 0) + position
	if Input.is_action_pressed("NumRight"):
		position = Vector2(MoveSpeed, 0) + position
