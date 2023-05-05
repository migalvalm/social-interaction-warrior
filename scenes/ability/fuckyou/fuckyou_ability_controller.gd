extends Node

@export var fuck_you_ability_scene: PackedScene
@export var base_wait_time: float

@onready var timer: Timer = $Timer

@export var base_damage = 10
@export var additional_damage_percent: float = 1
var additional_radius_percent: float = 1

func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.glass_ability_upgrade.connect(on_ability_upgrade_added)
	
func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return
	
	var foreground = get_tree().get_first_node_in_group('foreground_layer') as Node2D
	if foreground == null: return
	
	var fuck_you_instance = fuck_you_ability_scene.instantiate() as Node2D
	foreground.add_child(fuck_you_instance)
	
	fuck_you_instance.max_radius = fuck_you_instance.max_radius * additional_radius_percent
	fuck_you_instance.global_position = player.global_position
	fuck_you_instance.hitbox_component.damage = base_damage * additional_damage_percent

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		'speed_talk':
			var percent_reduction = current_upgrades['speed_talk']['quantity'] * .1
			timer.wait_time = base_wait_time * (1 - percent_reduction)
			timer.start()
		'damage':
			additional_damage_percent = 1 + (current_upgrades['damage']['quantity'] * 0.2)
		'radius':
			additional_radius_percent = 1 + (current_upgrades['radius']['quantity'] * 0.2)
