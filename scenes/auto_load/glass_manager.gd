extends Node

const GLASSES = {
	'default': 'res://resources/glasses/default.tres',
	'deal_with_it': 'res://resources/glasses/deal_with_it.tres',
	'boomer': 'res://resources/glasses/boomer.tres'
}

var current_glass: PlayerGlass = preload(GLASSES.deal_with_it)

func set_glass(glass_id: String) -> void:
	current_glass = load(GLASSES[glass_id])
