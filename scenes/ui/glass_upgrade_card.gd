extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var glass: PlayerGlass

func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_pressed)

func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate = Color.WHITE
	$AnimationPlayer.play('in')

func update_progress():
	var current_quantity = 0
	if SaveManager.save_data['player']['glasses'].has(glass.id):
		current_quantity = SaveManager.save_data['player']['glasses'][glass.id]['quantity']
	
	var is_maxed: bool = current_quantity >= glass.max_quantity
	var currency = SaveManager.save_data['player']['currency']
	var percent = min(currency / glass.experience_cost, 1)
	
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed: purchase_button.text = "MAX"
	progress_label.text = str(currency) + '/' + str(glass.experience_cost)
	count_label.text = "x%d" % current_quantity

func set_glass_upgrade(current_glass):
	self.glass = current_glass
	name_label.text = glass.title
	description_label.text = glass.description
	update_progress()

func on_purchase_pressed():
	if glass == null: return
	GlassProgression.add_glass_upgrade(glass)
	
	SaveManager.save_data['player']['currency'] -= glass.experience_cost
	SaveManager.save()
	
	get_tree().call_group('glass_upgrade_card', 'update_progress')
	$AnimationPlayer.play('selected')
