extends Area2D

signal AICollsionCarrier()

var  ToSend: Dictionary = {
	"CardHealth": null,
	"CardTeam": null,
	"CardID": null
}

func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	ToSend["CardHealth"] = area.get_parent().get_parent().CardHealth
	ToSend["CardTeam"] = area.get_parent().get_parent().Team
	ToSend["CardID"] = area.get_parent().get_parent().CardID
	print(ToSend)
	print(str(area) + "entered")


func _on_area_exited(area: Area2D) -> void:
	print(str(area) + 'exit')
