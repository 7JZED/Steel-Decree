extends Camera2D


var MoveSpeed: float = 4.5 
var ZoomTarget: Vector2 = Vector2(1,1)
var ZoomSpeed = 5

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
	zoom = zoom.lerp(ZoomTarget, ZoomSpeed * delta)

func _unhandled_input(event: InputEvent) -> void:
	#zoom
	if event.is_action_pressed("ScrollIn"):
		ZoomTarget += Vector2(.05,.05)
	if event.is_action_pressed("ScrollOut"):
		ZoomTarget -= Vector2(.05,.05)
	ZoomTarget.x = clamp(ZoomTarget.x,.7,3)
	ZoomTarget.y = clamp(ZoomTarget.y,.7,3)
