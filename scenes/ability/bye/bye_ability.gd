extends Node2D
class_name ByeAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var label: Label = %Label

@export var text:String = 'bye'

func _ready() -> void:
	label.text = text
