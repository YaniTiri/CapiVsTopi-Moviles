extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_sprite_2: AnimatedSprite2D = $AnimatedSprite2D2

func _ready() -> void:

	anim_sprite_2.hide()
	ejecutar_secuencia()

func ejecutar_secuencia() -> void:

	anim_sprite.show()
	anim_sprite.play("bomba")
	
	await get_tree().create_timer(0.12).timeout
	
	anim_sprite_2.show()
	anim_sprite_2.play("bomba") 
	
	await anim_sprite_2.animation_finished
	
	queue_free()
