extends Node2D
class_name OkayAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var label: Label = %Label

@export var text:String = 'Okay'

func _ready() -> void:
	label.text = text

func start_queue_free_timer():
	await get_tree().create_timer(5).timeout
	
	queue_free()
