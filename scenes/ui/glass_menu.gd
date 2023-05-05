extends CanvasLayer

var player_glass_card_scene = preload('res://scenes/ui/player_glass_card.tscn')

signal back_pressed

@onready var grid_container = %GridContainer
@onready var glasses_container = %GlassesContainer
@onready var play_button: Button = %PlayButton
@onready var button_container = $ButtonContainer
@onready var tips = %Tips
@onready var objective = %Objective

func _ready():
	play_button.pressed.connect(on_play_pressed)
	for player_glass_id in GlassManager.GLASSES.keys():
		var player_glass_card_instance = player_glass_card_scene.instantiate()
		grid_container.add_child(player_glass_card_instance)
		player_glass_card_instance.selected.connect(on_selected)
		player_glass_card_instance.set_class_card(player_glass_id)

func on_play_pressed():
	ScreenTransition.transition_to_scene('res://scenes/main/main.tscn', true)
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()

func on_selected() -> void:
	glasses_container.visible = false
	button_container.visible = true
	tips.visible = true
	objective.visible = true
	
