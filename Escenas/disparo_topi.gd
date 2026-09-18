extends Area2D

#Variables
var velocidad: float= 300.0
var danio: int = 10

#Funciones
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _physics_process(delta: float) -> void:
	global_position.x -= velocidad * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Topi:
		return
		
	if area.has_method ("recibir_danio"):
			area.recibir_danio(danio)
			queue_free()
			return
	if area.get_parent() != null and area.get_parent().has_method("recibir_danio"):
		area.get_parent().recibir_danio(danio)
		queue_free()
		return
		
