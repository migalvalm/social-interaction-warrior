extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var enemy_texture = %Texture
@onready var health_component = $HealthComponent
@onready var death_component = $DeathComponent

var enemy_textures: Dictionary = {
	'1': 'res://assets/enemies/1.png',
	'2': 'res://assets/enemies/2.png',
	'3': 'res://assets/enemies/3.png',
	'4': 'res://assets/enemies/4.png'
}

func _ready() -> void:
	enemy_texture.texture = load(enemy_textures.values()[randi_range(0, 3)])
	death_component.set_component()

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)
