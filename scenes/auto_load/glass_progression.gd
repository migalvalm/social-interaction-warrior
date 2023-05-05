extends Node

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)

func add_glass_upgrade(glass: PlayerGlass):
	if not SaveManager.save_data['player']['glasses'].has(glass.id):
		SaveManager.save_data['player']['glasses'][glass.id] = {
			'quantity': 0
		}
	
	SaveManager.save_data['player']['glasses'][glass.id]['quantity'] += 1
	SaveManager.save()

func get_upgrade_count(glass_id: String) -> int:
	if not SaveManager.save_data['player']['glasses'].has(glass_id): return 0
	return SaveManager.save_data['player']['glasses'][glass_id]['quantity']

func on_experience_collected(number: float) -> void:
	SaveManager.save_data['player']['currency'] += number
