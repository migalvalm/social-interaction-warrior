extends Node

signal experience_vial_collected(number)
signal glass_ability_upgrade(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal game_started
signal game_ended

func emit_experience_vial_collected(number: float) -> void:
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	glass_ability_upgrade.emit(upgrade, current_upgrades)

func emit_player_damaged():
	player_damaged.emit()

func emit_game_started():
	game_started.emit()

func emit_game_ended():
	game_ended.emit()
