extends RigidBody2D

var danio: int = 10
var fuerza_disparo: float = 1200.0

func _ready() -> void:
	#conecta el nodo que avisa si sale de la pantalla
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	
	var direccion = Vector2.RIGHT
	var impulso = direccion * fuerza_disparo
	apply_central_impulse(impulso)

#CUANDO SALE DE PANTALLA SE ELIMINA LA BALA
func _on_screen_exited() -> void:
	queue_free()
	

func _on_body_entered(body: Node) -> void:
	if body is Capi:
		return
	
	if body.has_node ("GestorDeHp"):
		body.get_node("GestorDeHp").recibir_danio(danio)
		queue_free()
