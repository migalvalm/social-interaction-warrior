extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_okay = preload('res://resources/abilities/okay.tres')
var upgrade_fuckyou = preload('res://resources/abilities/fuckyou.tres')
var upgrade_bye = preload('res://resources/abilities/bye.tres')
var upgrade_damage = preload('res://resources/abilities/damage.tres')
var upgrade_speed_talk = preload('res://resources/abilities/speed_talk.tres')
var upgrade_player_speed = preload('res://resources/abilities/player_speed.tres')


func _ready():
	upgrade_pool.add_item(upgrade_okay, 2)
	upgrade_pool.add_item(upgrade_fuckyou, 2)
	upgrade_pool.add_item(upgrade_bye, 2)
	upgrade_pool.add_item(upgrade_damage, 5)
	upgrade_pool.add_item(upgrade_speed_talk, 5)
	upgrade_pool.add_item(upgrade_player_speed, 3)
	
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			'resource': upgrade,
			'quantity': 1
		}
	else:
		current_upgrades[upgrade.id]['quantity'] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]['quantity']
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func update_upgrade_pool(_chosen_upgrade: AbilityUpgrade) -> void:
	pass
	
	
func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func on_level_up(_current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
