extends Node2D

@export var sprite:Sprite2D

@onready var radio = (sprite.texture.get_size() * sprite.scale).length() /2

var dragging = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - sprite.global_position).length() <radio:
			if not dragging and event.is_pressed():
				dragging = true
			pass
			
		if dragging and not event.is_pressed():
			dragging = false
			
			#para soltar la bolsa, regadera o lo que sea que drageamos
			owner.soltar_herramienta()
			pass
	
	if event is InputEventMouseMotion and dragging:
		owner.position = event.position
		
