extends CanvasLayer

@onready var barra_hp: TextureProgressBar = $Barra_vida_base/TextureProgressBar

func _ready() -> void:
	barra_hp.value = 100
	
	GameManager.actualizar_vida_capi.connect(actualizar_barra_de_vida)
	
func actualizar_barra_de_vida(hp_actual: int) -> void:
	barra_hp.value = hp_actual
