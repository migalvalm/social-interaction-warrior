extends CanvasLayer

signal back_pressed

@export var glasses: Array[PlayerGlass] = []

var glass_upgrade_card_scene = preload('res://scenes/ui/glass_upgrade_card.tscn')

@onready var grid_container = %GridContainer
@onready var back_button: Button = %BackButton

func _ready():
	back_button.pressed.connect(on_back_pressed)

	for glass in glasses:
		var glass_upgrade_card_instance = glass_upgrade_card_scene.instantiate()
		grid_container.add_child(glass_upgrade_card_instance)
		glass_upgrade_card_instance.set_glass_upgrade(glass)

func on_back_pressed():
	ScreenTransition.transition_to_scene('res://scenes/ui/main_menu.tscn')
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()
