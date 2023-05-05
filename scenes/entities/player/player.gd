extends CharacterBody2D
class_name Player

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var hurtbox_area: Area2D = $HurtboxArea
@onready var audio_player: AudioPlayer2DComponent = $AudioPlayer2DComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var player_texture = %Texture

var player_textures: Dictionary = {
	'1': 'res://assets/player/textures/hero_1.png',
	'2': 'res://assets/player/textures/hero_2.png'
}

var number_colliding_bodies: int = 0
var base_speed = 0

func _ready() -> void:
	base_speed = velocity_component.max_speed
	set_glass(GlassManager.current_glass)
	player_texture.texture = load(player_textures.values()[randi_range(0,1)])
	
	print(GlassManager.current_glass)
	
	hurtbox_area.body_entered.connect(on_body_entered)
	hurtbox_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.glass_ability_upgrade.connect(on_glass_ability_upgrade_added)
	health_bar.set_value(health_component.get_health_percent())

func _physics_process(_delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	play_animation(movement_vector)

func set_glass(glass: PlayerGlass):
	var ability = load(glass.main_ability_path) as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())

func play_animation(direction: Vector2) -> void:
	if (direction.x != 0 || direction.y != 0):
		animation_player.play('walk')
	else: 
		animation_player.play('idle')
	
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	var y_movement = Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	
	return Vector2(x_movement, y_movement)

func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped(): return
	
	health_component.damage(1)
	damage_interval_timer.start()

func update_health_display():
	health_bar.value = health_component.get_health_percent()
	
func on_body_entered(_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(_body: Node2D) -> void:
	if number_colliding_bodies == 0: return
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()

func on_health_decreased() -> void:
	GameEvents.emit_player_damaged()
	update_health_display()
	audio_player.play_random()

func on_health_changed() -> void:
	update_health_display()

func on_glass_ability_upgrade_added(ability_upgrade, current_upgrades: Dictionary) -> void:
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == 'player_speed':
		velocity_component.max_speed = base_speed + (base_speed * (current_upgrades["player_speed"]["quantity"] * 0.2))
