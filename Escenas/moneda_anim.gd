extends Node2D

func _ready() -> void:
	$Sprite2D/AnimationPlayer.animation_finished.connect(_eliminar_al_terminar)
	
	
func _eliminar_al_terminar(_nombre):
	queue_free()
