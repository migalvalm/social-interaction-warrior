extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial
@onready var hit_random_audio_player: AudioPlayer2DComponent = $AudioPlayer2DComponent

var hit_flash_tween: Tween

func _ready() -> void:
	health_component.health_decreased.connect(on_health_decreased_changed)
	sprite.material = hit_flash_material

func on_health_decreased_changed() -> void:
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	hit_random_audio_player.play_random()
	(sprite.material as ShaderMaterial).set_shader_parameter('lerp_percent', 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(
		sprite.material, 'shader_parameter/lerp_percent', 0.0, .25
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_CUBIC
	)