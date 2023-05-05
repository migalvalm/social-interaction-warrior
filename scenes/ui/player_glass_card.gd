extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var select_button: Button = %SelectButton
@onready var texture: TextureRect = %Texture

signal selected

var player_glass: PlayerGlass

func _ready() -> void:
	select_button.pressed.connect(on_select_pressed)

func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate = Color.WHITE
	$AnimationPlayer.play('in')

func update_progress():
	pass

func set_class_card(glass_id):
	self.player_glass = load(GlassManager.GLASSES[glass_id])
	name_label.text = player_glass.title
	texture.texture = load(player_glass.texture_path)
	description_label.text = player_glass.description

func on_select_pressed():
	GlassManager.set_glass(player_glass.id)
	selected.emit()
