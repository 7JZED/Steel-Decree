extends Area2D

var MouseState: bool = false
signal Selection


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("SelectionMouse") and  MouseState == true:
		Selection.emit()



func _on_mouse_entered() -> void:
	MouseState = true
	

func _on_mouse_exited() -> void:
	MouseState = false
