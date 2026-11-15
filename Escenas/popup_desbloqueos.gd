extends CanvasLayer

class_name PopupDesbloqueo

signal cerrado

@onready var fondo: ColorRect = $Fondo
@onready var label_titulo: Label = $Fondo/VBoxContainer/Mensaje
@onready var label_mensaje: Label = $Fondo/VBoxContainer/SegunNivel
@onready var label_continuar: Label = $Fondo/VBoxContainer/Continuar


var puede_avanzar: bool = false


func _ready() -> void:
	animar_entrada()
	esperar_interaccion()


# Función universal: quien la llama decide qué título y texto mostrar
func configurar(titulo: String, mensaje: String) -> void:
	if label_titulo:
		label_titulo.text = titulo
	if label_mensaje:
		label_mensaje.text = mensaje


func animar_entrada() -> void:
	fondo.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(fondo, "modulate:a", 1.0, 0.4)


func esperar_interaccion() -> void:
	# 1 segundo de respiro antes de permitir cerrarlo
	await get_tree().create_timer(1.0).timeout
	puede_avanzar = true
	
	# Si nadie toca nada, a los 3.5 segundos adicionales se cierra solo
	await get_tree().create_timer(3.5).timeout
	cerrar_popup()


func _input(event: InputEvent) -> void:
	if puede_avanzar:
		if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed):
			cerrar_popup()


func cerrar_popup() -> void:
	if not visible:
		return
	visible = false
	cerrado.emit()
	queue_free()
