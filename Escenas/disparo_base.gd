extends Area2D

class_name DisparoBase

var velocidad: float = 200.0
var danio: int = 5

func _ready() -> void:
	#conecta el nodo que avisa si sale de la pantalla
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	
	#CONECTA SEÑAL DE AREA CON AREA
	area_entered.connect(_on_area_entered)
	
func _physics_process(delta: float) -> void:
	mover_proyectil(delta)
	

func mover_proyectil(delta: float) -> void:
	global_position.x += velocidad * delta
	
#CUANDO SALE DE PANTALLA SE ELIMINA LA BALA
func _on_screen_exited() -> void:
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	#SI EL AREA QUE CHOCA TIENE EL METODO RECIBIR DAÑO:
	if area.has_method("recibir_danio"):
		area.recibir_danio(danio)
		#EL DISPARO SE DESTRUYE
		queue_free()
