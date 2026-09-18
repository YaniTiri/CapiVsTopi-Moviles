extends Control
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.modulate.a = 0.0
	var tween_in = create_tween()
	tween_in.tween_property(texture_rect, "modulate:a", 1.0, 1.5)
	await tween_in.finished
	await get_tree().create_timer(2.0).timeout
	var tween_out = create_tween()
	tween_out.tween_property(texture_rect, "modulate:a", 0.0, 1.5)
	await tween_out.finished
	get_tree().change_scene_to_file("res://menu/munu.tscn")
