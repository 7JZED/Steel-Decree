extends Area2D
signal MoveLock


func _on_water_collsion_block_area_entered(area: Area2D) -> void:
	SignalManager.MoveLock.emit(true)


func _on_water_collsion_block_area_exited(area: Area2D) -> void:
	SignalManager.MoveLock.emit(false)
