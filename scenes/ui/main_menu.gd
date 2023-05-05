extends CanvasLayer

var select_glass_menu_scene = preload('res://scenes/ui/glass_menu.tscn')
var options_scene = preload('res://scenes/ui/options_menu.tscn')
var glass_menu_scene = preload('res://scenes/ui/glasses_menu.tscn')

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var menu: MarginContainer = %Main

func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_play_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	menu.visible = false
	var select_glass_menu_instance = select_glass_menu_scene.instantiate()
	add_child(select_glass_menu_instance)

func on_options_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	menu.visible = false
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))

func on_quit_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	SaveManager.save()
	get_tree().quit()

func on_options_closed(options_instance: Node) -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	options_instance.queue_free()
	menu.visible = true

func on_class_closed(classes_instance: Node) -> void:
	classes_instance.queue_free()
	menu.visible = true
