extends  Area2D
class_name EscudoDefensivo #Funcionalidad para protección

@export var vida_maxima: int = 150
var vida_actual: int



func _ready() -> void:

	vida_actual = vida_maxima #Es muy importante agregarla al mismo grupo de las plantas
	add_to_group ("plantas")# porque topi esta programado para atacarlas


# Función que los Topis/Cristales van a llamar cuando impacten
func recibir_danio(dmg: int) -> void:
	vida_actual -= dmg
	print("El escudo recibió ", dmg, " de daño. Vida restante: ", vida_actual)
	animar_danio()  # Efecto visual de daño (Feedback para el jugador)
	
	if vida_actual <= 0:
		destruirse()

func animar_danio() -> void:
	# Un Tween rápido para que parpadee en rojo al recibir un golpe
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 0, 0), 0.1)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)

func destruirse() -> void:
	queue_free()
