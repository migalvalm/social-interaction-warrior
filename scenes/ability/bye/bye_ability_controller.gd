extends Node

@export var MAX_RANGE: int = 75

@export var ability: PackedScene
@export var base_damage: int = 5
@export var additional_damage_percent: float = 1
@export var additional_radius_percent: float = 1
@export var base_wait_time: float

@onready var timer: Timer = $Timer

func _ready():
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.glass_ability_upgrade.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player')
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group('enemy')
		
	enemies = enemies.filter(
		func(enemy: Node2D): 
			return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE * additional_radius_percent, 2)
	)
	
	enemies.sort_custom(
		func(a:Node2D, b:Node2D):
			var a_distance  = a.global_position.distance_squared_to(player.global_position)
			var b_distance  = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
	)
	
	if enemies.size() == 0: return
	
	var ability_instance = ability.instantiate() as ByeAbility
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	foreground_layer.add_child(ability_instance)
	ability_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	ability_instance.global_position = enemies[0].global_position
	ability_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - ability_instance.global_position
	ability_instance.rotation = enemy_direction.angle()

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
