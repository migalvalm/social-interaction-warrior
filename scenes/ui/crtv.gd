extends CanvasLayer

@onready var crtv_shader: ColorRect = $CRTVShader

func _ready() -> void:
	GameEvents.player_damaged.connect(on_player_damaged)
	GameEvents.game_started.connect(on_game_started)
	GameEvents.game_ended.connect(on_game_ended)
	
func on_player_damaged() -> void:
	$AnimationPlayer.play('hit')

func on_game_started() -> void:
	warp(1.5, 1.5)

func on_game_ended() -> void:
	warp(0.2, 1.0)

func warp(begin: float, end: float) -> void:
	var warp_tween = create_tween()
	warp_tween.tween_property(
		crtv_shader.material, 'shader_parameter/warp_amount', begin, end
	).set_ease(
		Tween.EASE_OUT
	).set_trans(
		Tween.TRANS_BOUNCE
	)
