extends Node2D

@export var sprite:Sprite2D

@onready var radio: float = (sprite.texture.get_size() * sprite.scale).length() /2.0

var dragging: bool = false
#guarda el dedo que inicia el drag (-1 es el Mouse)
var drag_touch_index: int = -1

func _input(event: InputEvent) -> void:
	#EVENTOS TACTILES:
	if event is InputEventScreenTouch:
		#INICIO del touch:
		if not dragging and event.pressed:
			if (event.position - sprite.global_position).length() < radio:
				dragging = true
				drag_touch_index = event.index
		#FIN del touch:
		elif dragging and not event.pressed and event.index == drag_touch_index:
			_finalizar_arrastre()
	
	elif event is InputEventScreenDrag:
		if dragging and event.index == drag_touch_index:
			owner.global_position = event.position
	
	# EVENTOS DE MOUSE PC:
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not dragging and event.pressed:
			if(event.position - sprite.global_position).length() < radio:
				dragging = true
				drag_touch_index = -1
		
		elif dragging and not event.pressed and drag_touch_index == -1:
			_finalizar_arrastre()
	elif event is InputEventMouseMotion and dragging and drag_touch_index == -1:
		owner.global_position = event.position
	

func _finalizar_arrastre() -> void:
	dragging = false
	drag_touch_index = -1
	if owner.has_method("soltar_herramienta"):
		owner.soltar_herramienta()
