extends Area2D

signal AICollsionCarrier(send)

var  ToSend: Dictionary = {
	"CardHealth": null,
	"CardTeam": null,
	"CardID": null
}

func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() != get_parent().get_parent():
		ToSend["CardHealth"] = area.get_parent().get_parent().CardHealth
		ToSend["CardTeam"] = area.get_parent().get_parent().Team
		ToSend["CardID"] = area.get_parent().get_parent().CardID
		AICollsionCarrier.emit(ToSend)


func _on_area_exited(area: Area2D) -> void:
	pass
