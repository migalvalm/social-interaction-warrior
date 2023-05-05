extends ParallaxBackground

@export var SPEED:float = -1

func _physics_process(_delta: float) -> void:
	self.scroll_base_offset.x += SPEED
