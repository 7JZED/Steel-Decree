extends Sprite2D

var SelectedPos: Vector2 = Vector2(300, 300)

func _process(delta: float) -> void:
	position = SelectedPos


func _input(event: InputEvent) -> void:
	# gets mouse position
	if Input.is_action_just_pressed("SelectionMouse"):
		SelectedPos = get_viewport().get_mouse_position()
