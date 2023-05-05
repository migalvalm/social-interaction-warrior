extends Node

const BASE_RANGE = 50
const BASE_DAMAGE = 10

@export var okay_ability_scene: PackedScene
@export var base_wait_time: float

@onready var timer: Timer = $Timer 
var additional_damage_percent: float = 1
var additional_radius_percent: float = 1

func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE * additional_radius_percent)) 
	
	var query_parameters = PhysicsRayQueryParameters2D.create(
			player.global_position,
			spawn_position,
			1 #Layer Mask Bit
		)
		
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	if !result.is_empty():
		spawn_position = result['position']
	
	var okay_ability = okay_ability_scene.instantiate()
	get_tree().get_first_node_in_group('foreground_layer').add_child(okay_ability)
	okay_ability.global_position = spawn_position
	okay_ability.hitbox_component.damage = BASE_DAMAGE * additional_damage_percent

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
