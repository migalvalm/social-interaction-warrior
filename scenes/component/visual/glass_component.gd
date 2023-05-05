extends Sprite2D

var glass_textures: Dictionary = {
	'deal_with_it': {
		'scale': Vector2(0.015, 0.015),
		'position': Vector2(0, -7.889),
	},
	'boomer': {
		'scale': Vector2(0.005, 0.005),
		'position': Vector2(0, -8)
	},
	'default': {
		'scale': Vector2(0.002, 0.004),
		'position': Vector2(0, -8)
	},
}

func _ready() -> void:
	texture = load(GlassManager.current_glass.texture_path)
	scale = glass_textures[GlassManager.current_glass.id]['scale']
	position = glass_textures[GlassManager.current_glass.id]['position']
